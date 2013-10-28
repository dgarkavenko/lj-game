package dynamics.player 
{
	import dynamics.actions.ActionTypes;
	import dynamics.actions.IAction;
	import dynamics.Collision;
	import dynamics.GameCb;
	import dynamics.interactions.IInteractive;
	import dynamics.interactions.PlayerInteractiveObject;
	import dynamics.player.weapons.Carry;
	import dynamics.player.weapons.Gun;
	import dynamics.player.weapons.GunData;

	import dynamics.player.weapons.Tool;
	import dynamics.player.weapons.ToolData;
	import dynamics.player.weapons.WeaponData;
	import dynamics.Walker;
	import flash.events.Event;
	import framework.input.Controls;
	import framework.input.Keyboard;
	import gamedata.DataSources;
	import gamedata.LumberKeeper;
	import gameplay.player.HP;
	import gameplay.player.SkillList;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Interactor;
	import nape.phys.Material;
	import nape.shape.Polygon;
	
	/**
	 * ...
	 * @author DG
	 */
	public class Lumberjack extends Walker implements IInteractive
	{
		
		public static const INITIAL_X:int = 200;
		public static const INITIAL_Y:int = 250;	
		
		
		public var onPlayerMoveCallback:Function;
		
		private var save:LumberKeeper = DataSources.lumberkeeper;
		
		
		private var hands:Hands;		
		
		
		private var gunContainer:Gun = new Gun();
		private var toolContainer:Tool = new Tool();
		private var miscContainer:Carry = new Carry();
		
		//private var equip:Array = [new GunData("spas"), new GunData("uzi"), new ToolData("axe_rusty")];
		
		
		
		private var currentCategory:int = -1;
		
		private var axes:Array = [new ToolData("axe_rusty"), new ToolData("axe_double"), new ToolData("axe_fire")];
		private var pdws:Array = [new GunData("pistol"), new GunData("revolver")];
		private var shotguns:Array = [new GunData("shotgun"), new GunData("spas")];
		private var machineguns:Array = [new GunData("uzi"), new GunData("assault")];
		private var rifles:Array = [new GunData("barret")];
		
		private var equip:Array = [axes, pdws, shotguns, machineguns, rifles];
		private var lastEquipedInCategory:Array = [0,0,0,0,0];
		
		public var hp:HP = new HP();
		//private var max_hp:int = save.max_hp;
		//private var hp:int = save.hp;
		private var xp:int = save.xp;
		
		public var skills:SkillList = new SkillList();
		public var movement:Movement;		
		public var disabled:Boolean = false;
		
		private var interactor:PlayerInteractor = new PlayerInteractor();
		
		private var _luggage:PlayerInteractiveObject;
		
		
		//TEMPORARY

		internal var lock_x:Number;
		
		private var normal_z_index:int;
		
		
		private var isStuck:Boolean = false;
		
		private var keyboard:Keyboard = Controls.keys;
		private var lastWeapon:WeaponData;
		
		
		internal function stuck():void {
			if (isStuck) return;
			isStuck = true;
			_body.scaleShapes(1, 0.5);
			_body.userData.graphicOffset.y = -25;
		}
		
		internal function unstuck():void {
			if (!isStuck) return;
			isStuck = false;
			_body.scaleShapes(1, 2);
			_body.userData.graphicOffset.y = -38;
		}
		
		public function Lumberjack(x:int, y:int) 
		{			
			
			
			//Вот из чего изготавливаются герои
			var hero_material:Material = Material.wood();	
		
			_body = build(new Vec2(x, y), [Polygon.rect( 0, 0, 16, 49), Polygon.rect(3,50,10,5)], hero_material);	
			_body.allowRotation = false;			
			//Дровосек, не перексекается с ЛАМБЕР_ИГНОР группой и ДАмми
			Collision.setFilter(_body, Collision.DUMMIES, ~(Collision.LUMBER_IGNORE|Collision.DUMMIES|Collision.LUMBER_RAY));
			
			_body.cbTypes.add(GameCb.LUMBERJACK);			
			_body.shapes.at(1).cbTypes.add(GameCb.INTERACTIVE);
			_body.shapes.at(0).cbTypes.add(GameCb.LEGS);
			
			_view = new Lumberskin();			
			_body.userData.graphicOffset = new Vec2(0, -37);
			_body.userData.graphic = _view.sprite;				
			container.layer2.addChild(_view.sprite);			
			_body.userData.y_scale = 1;
			_body.userData.x_scale = 1;
						
			
			//Скилы грузим
			skills.load(save.skills);
			skills.addEventListener(SkillList.SKILL_UP_EVENT, onSkillUpgrade);
			_body.userData.interact = interact;	
			
			//Здоровьишко		
			hp.init(save.hp);
			
			//Оружие настраиваем
			Hands.carrier = this;
			Hands.pivot = _body.position;
			Hands.carrier_view = _view as Lumberskin;
					
			selectWeapon(equip[1][0]);		
			
			interactor.setup(this, build(Vec2.get(0,0), [Polygon.rect( 0, 0, 50, 60)]), Vec2.get(15, 0));
			movement = new Movement(this);
			movement.addEventListener("onMove", onPlayerMove);
		
		}
		
		private function onPlayerMove(e:Event = null):void 
		{
			if (onPlayerMoveCallback != null) onPlayerMoveCallback();
		}
		
		private function onSkillUpgrade(e:Event = null):void 
		{
			hands.updateParams();
			hp.updateParams();
			movement.updateParams();
			
			
		}
		
		
		
		public function drop(e:Boolean = false):void {			
			
			if (keyboard.justPressed("E") || e) {
				if (_luggage == null) return;
				
				_luggage.drop(_body, facing);
				_luggage = null;
				selectWeapon(lastWeapon);
			}
		}
		
		override public function tick():void {
			
			super.tick();
			hp.tick();
			interactor.update();
			movement.tick();			
			
			if (keyboard.justPressed("E")) {
				
				onUse();
				
			}else if (keyboard.pressed("E")) {
				
				onUse(); 
				
			}
			
			
			var i:int = 0;
			
			for each (var btn:String in ["ONE","TWO","THREE","FOUR","FIVE"]) 
			{
				if (keyboard.justPressed(btn)) {
					
					if (i == currentCategory) {
						
						lastEquipedInCategory[i]++
						if (lastEquipedInCategory[i] >= equip[i].length) lastEquipedInCategory[i] = 0;						
						
					}
					
					currentCategory = i;
					
					selectWeapon(equip[currentCategory][lastEquipedInCategory[currentCategory]]);
					break;
				}
				
				i++;
				
			}
			//******************* OLD SYSTEM **************************
			
			/*for each (var btn:String in ["ONE","TWO","THREE"]) 
			{		
				if (keyboard.justPressed(btn)) {
					
					if (equip[i] == null) break;					
					selectWeapon(equip[i]);					
					break;
				}
				
				i++;
			}*/
			//******************* OLD SYSTEM **************************
			
			hands.tick();	
			
		}
		
		public function pick(io:PlayerInteractiveObject):void {	
			
			_luggage = io;	
			lastWeapon = hands.pull();
			if (hands != null) hands.kill();
			hands = miscContainer;			
			
			(_view as Lumberskin).weaponchange("wood");	//TODO here are type
			
		}
		
		private function selectWeapon(wData:WeaponData):void 
		{	
			drop(true);
			
			if (hands != null && hands.weaponType == wData.type) {	
				
				hands.select(wData);	
				
			}else {		
				
				if (hands != null) hands.kill();
				
				for each (var item:Hands in [gunContainer, toolContainer]) 
				{
					if (item.weaponType == wData.type) hands = item;
				}
				
				hands.init();	
				hands.select(wData);
			}			
			
			(_view as Lumberskin).weaponchange(wData.alias);				
		
		}
		
		
		
		private function onUse():void 
		{
			
			trace("IO:" + interactor.hasInteractiveObjects());
			
			if (interactor.hasInteractiveObjects()) {
				
				var inter:Interactor = interactor.getFocus();				
				
				
				if (_luggage != null) {
					
					//И если этот предмет требуется 
					if (inter.userData.requires(_luggage.type)) {						
						//То используем этот предмет на
						inter.userData.onUse({parent:this});					
					}else {
						//Если не требуется, то выкидываем багаж
						drop();									
					}					
					
				}else {					
					inter.userData.onUse({parent:this});
				}
				
			}else {
				if (_luggage != null) {
					drop();					
				}
			}
			
			
		}
		
		
		
		override public function getBody():Body {
			return _body;
		}
		
		/* INTERFACE dynamics.interactions.IInteractive */
		
		public function interact(action:IAction):void 
		{
			
			var params:Object = action.params;
			
			switch (action.type) 
			{
				case ActionTypes.TREE_HIT:
					
					var damage:int = action.params.power / 100;
					hp.decrease(damage);
					
					
					if (damage > 25) {
						
						movement.stuck(damage);
						stuck();
					
						
						$VFX.blood.at(params.x, params.y,0, -1, damage * 2);
					}
					else if (damage > 1) {
						trace("−"+ damage);
						$VFX.blood.at(params.x, params.y,0, -1, damage * 2);
					}
					
				break;
				
				case ActionTypes.PUDDLE_BURN:
				
					hp.dot = action.params.damage;
					
				break
				
				default:
			}
		}
		
		public function getSpriteIndex():int 
		{
			return container.getChildIndex(view.sprite);
		}
		
		//TODO REMOVE
		public function bite(facing_:int):void 
		{
			hp.decrease(10);
			$VFX.blood.at(_body.position.x, _body.position.y, -facing_, 0, 15);
			
		}
		
		public function set luggage(value:PlayerInteractiveObject):void 
		{
			_luggage = value;
		}
		
		public function get luggage():PlayerInteractiveObject 
		{
			return _luggage;
		}
		
	}

}