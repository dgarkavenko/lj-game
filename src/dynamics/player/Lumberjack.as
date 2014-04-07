package dynamics.player 
{
	import com.greensock.TweenLite;
	import dynamics.actions.ActionTypes;
	import dynamics.actions.IAction;
	import dynamics.Collision;
	import dynamics.GameCb;
	import dynamics.interactions.IInteractive;
	import dynamics.interactions.PlayerInteractiveObject;
	import dynamics.player.weapons.Carry;
	import dynamics.player.weapons.Chainsaw;
	import dynamics.player.weapons.Explosives;
	import dynamics.player.weapons.Gun;
	import dynamics.player.weapons.GunData;
	import framework.input.Mouse;
	import gameplay.DeathReason;
	import gameplay.SkillList;
	import gui.PopText;
	import utils.DataEvt;
	import utils.GlobalEvents;

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
		
		
		public var lastDamage:String = "";
		
		private var save:LumberKeeper = DataSources.lumberkeeper;
		public var cash:int = save.money;
		
		private var hands:Hands;		
		
		
		private var gunContainer:Gun = new Gun();
		private var toolContainer:Tool = new Tool();
		private var explosives:Explosives = new Explosives();
		private var chainsaw:Chainsaw = new Chainsaw();
		
		private var miscContainer:Carry = new Carry();
		
		//private var equip:Array = [new GunData("spas"), new GunData("uzi"), new ToolData("axe_rusty")];
		
		private var mouse:Mouse = Controls.mouse;
		
		
		private var currentCategory:int = -1;
		
		private var axes:Array = [new ToolData("axe_rusty")/*, new ToolData("axe_double"), new ToolData("axe_fire")*/];
		private var pdws:Array = [new GunData("pistol")/*, new GunData("revolver")*/];
		private var shotguns:Array = [/*new GunData("shotgun"), new GunData("spas")*/];
		private var machineguns:Array = [/*new GunData("uzi"), new GunData("assault")*/];
		private var rifles:Array = [/*new GunData("barret")*/];
		
		private var equip:Array = [axes, pdws, shotguns, machineguns, rifles];
		private var lastEquipedInCategory:Array = [0,0,0,0,0];
		
		public var hp:HP = new HP();
		//private var max_hp:int = save.max_hp;
		//private var hp:int = save.hp;
	
		private var rollend:Boolean = false;
		
		

		public var movement:Movement;		
		public var disabled:Boolean = false;
		public var quovirouk:int = 0;
		
		
		
		private var interactor:PlayerInteractor = new PlayerInteractor();
		
		private var _luggage:PlayerInteractiveObject;
		
		
		//TEMPORARY

		internal var lock_x:Number;
		
		private var normal_z_index:int;
		
		
		private var isStuck:Boolean = false;
		
		private var keyboard:Keyboard = Controls.keys;
		private var lastWeapon:WeaponData;
		private var quovirouk_cd:int = 0;
		
		
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
		
		public function zombieCollision(a:int):void {
			movement.zombieCollision = a;
		}
		
		public function Lumberjack(x:int, y:int) 
		{			
			
			
			//Вот из чего изготавливаются герои
			var hero_material:Material = Material.wood();	
		
			_body = build(new Vec2(x, y), [Polygon.rect( 0, 0, 16, 49), Polygon.rect(3,50,10,5)], hero_material);	
			_body.allowRotation = false;			
			//Дровосек, не перексекается с ЛАМБЕР_ИГНОР группой и ДАмми
			Collision.setFilter(_body, 256, ~(Collision.LUMBER_IGNORE|Collision.LUMBER_RAY));
			
			_body.cbTypes.add(GameCb.LUMBERJACK);			
			_body.shapes.at(1).cbTypes.add(GameCb.INTERACTIVE);
			_body.shapes.at(0).cbTypes.add(GameCb.LEGS);
			
			_view = new Lumberskin();			
			_body.userData.graphicOffset = new Vec2(0, -37);
			_body.userData.graphic = _view.sprite;				
			container.layer2.addChild(_view.sprite);			
			_body.userData.y_scale = 1;
			_body.userData.x_scale = 1;
						
			

			_body.userData.interact = interact;	
			
			//Здоровьишко		
			var ref:Object = DataSources.instance.getReference("lumberjack");
			hp.init(ref.hp);
			
			//Оружие настраиваем
			Hands.carrier = this;
			Hands.pivot = _body.position;
			Hands.carrier_view = _view as Lumberskin;
					
			selectWeapon(equip[1][0]);		
			
			interactor.setup(this, build(Vec2.get(0,0), [Polygon.rect( 0, 0, 50, 60)]), Vec2.get(15, 0));
			movement = new Movement(this);
			movement.jump = ref.jump;
			movement.walk = ref.ms;
			
			
			$GLOBAL.listenTo(GlobalEvents.SKILLS, onSkillUpgrade);
		
		}
		
		public function setMoveCallback(f:Function):void {
			movement.onMove = f;
		}
		
		private function onSkillUpgrade(e:DataEvt = null):void 
		{
			trace("SKILL_UP");
			hands.updateParams();
			hp.updateParams();
			movement.updateParams();						
		}
		
		private function selectNew(index:int):void {
			selectWeapon(equip[index][equip[index].length - 1]);
		}
		
		public function serialize():void {
			
			var weapons:Array;
			
			for each (var ary:Array in equip ) 
			{
				for each (var dt:WeaponData in ary) 
				{
					weapons.push(dt.alias);
				}
			}			
			
			
		}
		
		public function purchased(a:String):void {
			
			PopText.at("$" + cash, _body.position.x, _body.position.y - 20, 0xffffff);

			
			if (hasGunOrTool(a)) {
				trace("I have it already");
				return;
			}
			
			if (a == "axe_double" || a == "axe_fire" || a == "axe_rust" || a == "chainsaw") {
				axes.push(new ToolData(a));
				selectNew(0);
			}else if ( a == "revolver" || a == "pistol") {
				pdws.push(new GunData(a));	
				selectNew(1);
			}else if (a == "shotgun" || a == "spas") {
				shotguns.push(new GunData(a));	
				selectNew(2);
			}else if (a =="uzi" || a == "assault") {
				machineguns.push(new GunData(a));	
				selectNew(3);
			}else if (a == "barret") {
				rifles.push(new GunData(a));
				selectNew(4);
			}
			else
			{
				trace("WRONG WEAPON ALIAS");
			}			
		}
		
		public function hasGunOrTool(a:String):Boolean {
			for each (var ary:Array in equip ) 
			{
				for each (var dt:WeaponData in ary) 
				{
					if (dt.alias == a) return true;
				}
			}
			
			return false;
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
			
			if (quovirouk_cd > 0) quovirouk_cd--;
			hp.tick();
			interactor.update();
			
			// Use items or other shi. Prevents double using
			if (keyboard.justPressed("E")) onUse();				
			else if (keyboard.pressed("E"))	onUse(); 	
			
			// Quovirouk			
			if (quovirouk > 0) {	
				
				
				view.battleroll(true);
				
				if (quovirouk > 16) {
					_body.velocity.x = 50 * facing;
				}else if (quovirouk > 9) {
					

					_body.velocity.x = 330 * facing;
				}else if (quovirouk > 5) {
					$VFX.dust.at(_body.position.x, _body.position.y + 27, 10);
					_body.velocity.x = 250 * facing;
				}else if (quovirouk > 2)
				{	$VFX.dust.at(_body.position.x, _body.position.y + 27, 10);
					_body.velocity.x = 150 * facing;
				}else {
					_body.velocity.x = 150 * facing;
				}
				
				quovirouk--;				
				if (quovirouk == 0)	rollend = true;
				return;
			}
			
			if (rollend) {
				rollend = false;
				hp.immune = false;
				view.battleroll(false);
			}
			
			if (quovirouk_cd <= 0 && keyboard.justPressed("SPACE") && SkillList.isLearned(SkillList.NINJA)) {	
					
				if (keyboard.pressed("A")) {
					facing = -1;
				}else if (keyboard.pressed("D")) {
					facing = 1;
				}
				quovirouk = 20;		
				hands.interrupt();
				hp.immune = true;
				quovirouk_cd = 30;
				return;
			}	
			
			//Movement and aiming			
			facing = _body.position.x > mouse.relativeX ? -1 : 1
			movement.tick();	
			
			//Changin weapons
			var i:int = 0;
			for each (var btn:String in ["ONE","TWO","THREE","FOUR","FIVE"]) 
			{
				if (keyboard.justPressed(btn)){
					
					if (i == currentCategory) {
						
						lastEquipedInCategory[i]++
						if (lastEquipedInCategory[i] >= equip[i].length) lastEquipedInCategory[i] = 0;						
						
					}
					
					currentCategory = i;
					if (equip[currentCategory].length < 1) return;
					
					selectWeapon(equip[currentCategory][lastEquipedInCategory[currentCategory]]);
					break;
				}
				
				i++;
				
			}
			
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
				
				for each (var item:Hands in [gunContainer, toolContainer, explosives, chainsaw]) 
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
					
					lastDamage = DeathReason.TREE;
					
					if (action.params.power < 150) return;
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
			if (hp.immune) {
				PopText.at("DODGED", _body.position.x, _body.position.y - 20, 0xffffff);
				return;
			}else {
				hp.decrease(10);
				$VFX.blood.at(_body.position.x, _body.position.y, -facing_, 0, 15);
			}		
			
		}
		
		public function growBeard():void 
		{
			
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