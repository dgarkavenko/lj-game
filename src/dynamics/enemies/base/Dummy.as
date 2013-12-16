package dynamics.enemies.base 
{
	import com.greensock.TweenLite;
	import dynamics.actions.ActionTypes;
	import dynamics.actions.IAction;
	import dynamics.BaseSpriteControl;
	import dynamics.Collision;
	import dynamics.enemies.ai.ConditionList;
	import dynamics.enemies.ai.Schedule;
	import dynamics.GameCb;
	import dynamics.interactions.IInteractive;
	import dynamics.Walker;
	import flash.utils.setTimeout;
	import framework.input.Controls;
	import gamedata.DataSources;
	import gameplay.EvilGenius;
	import gui.Bars.HealthBarCache;
	import gui.Bars.SimpleBar;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.dynamics.InteractionGroup;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Interactor;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import utils.GlobalEvents;
	import visual.z.Spitter;
	/**
	 * ...
	 * @author DG
	 */
	public class Dummy extends Walker implements IInteractive
	{
		

		public const STATE_STAND:uint = 1;
		public const STATE_WALK:uint = 2;
		public const STATE_MELEE:uint = 3;
		public const STATE_RANGED:uint = 4;
		public const STATE_PURSUIT:uint = 5;
		
		public const CONDITION_SEE_ENEMY:uint = 1;
		public const CONDITION_CAN_STAND:uint = 2;
		public const CONDITION_CAN_WALK:uint = 3;
		public const CONDITION_CAN_RANGED_ATTACK:uint = 4;
		public const CONDITION_CAN_MELEE_ATTACK:uint = 5;		
		
		protected var _conditions:ConditionList = new ConditionList();
		protected var _state:uint;
		
		
		protected var _currentShedule:Schedule;
		
		protected var stand:Schedule;
		protected var move:Schedule;
		
		
		protected var _alias:String;	
		
		protected var movementSpeed:int;
		protected var maximumHP:int;
		protected var currentHP:int;
		protected var viewRange:int = 250;		
		protected var senceRange:int = 20;
		
		protected var _interval:int;
		protected var _thinkIteration:int;	
		
		private static var healthBars:HealthBarCache = new HealthBarCache(5);
		private var health_bar:SimpleBar;
		protected var isDead:Boolean = false;
		
		protected var worried:Boolean = false;
		public var daddy:EvilGenius;
		
		
		private function show_hp():void 
		{
			if (isDead) return;
			//trace(hp);
			
			if (health_bar == null) {
				health_bar = healthBars.getInstance() as SimpleBar;		
				container.layer0.addChild(health_bar);
			}
			
			health_bar.alpha = 1;
			health_bar.scale(currentHP / maximumHP);				
			TweenLite.killTweensOf(health_bar);			
			TweenLite.to(health_bar, .2, {delay:2, alpha:0, onComplete:onHide } );
			
		}
		
		private function onHide():void {
			if (health_bar != null) healthBars.setInstance(health_bar);
			container.layer0.removeChild(health_bar);
			health_bar = null;
		}
		
		public function Dummy(alias:String) 
		{
			//_view = new BaseSpriteControl(ZStore.GetMC(alias));
			_alias = alias;			
			
			var ref:Object = DataSources.instance.getReference(_alias);
			setParameters(ref);
			
			stand = new Schedule("Stand");
			stand.addFewInterrupts([CONDITION_SEE_ENEMY, CONDITION_CAN_RANGED_ATTACK, CONDITION_CAN_MELEE_ATTACK]);
			stand.addFewTasks([onInitStand, onStand]);
			
			move = new Schedule("Move");
			move.addFewTasks([ onInitMove, onMove ]);
			move.addFewInterrupts([ CONDITION_CAN_MELEE_ATTACK, CONDITION_CAN_RANGED_ATTACK, CONDITION_SEE_ENEMY ]);
			
			_currentShedule = stand;
			_state = STATE_STAND;
			
			
		
		}
		
		private function get intType():int 
		{
			switch (_alias) 
			{
				case "spitter":
					return 1;
				break;
				case "stalker":
					return 2;
				break;
				default: return 0;
			}
			
		}
		
		override public function getBody():Body {
			return _body;
		}
		
		
		private var f:uint = 1;
		private var k:uint = 1;
		
		
		override public function tick():void {
			
			if (health_bar != null) {
					health_bar.x = _body.position.x;
					health_bar.y = _body.position.y - view.sprite.height / 2 - 10;
				}	
		}
		
		/* INTERFACE dynamics.interactions.IInteractive */
		
		public function interact(action:IAction):void 
		{
			
			var params:Object = action.params;
			
			switch (action.type) 
			{
				
				//TODO: Types to UINTS
				case ActionTypes.CHOP_ACTION:
					
					worried = true;					
					$VFX.blood.at(params.x, params.y, -params.facing, 0, params.power * 4);
					_body.applyImpulse(Vec2.get(params.facing * params.power * 2, 0));
					currentHP -= params.power * params.z_dmg;					
					show_hp();
					
				break;
				
			case ActionTypes.GUNSHOT_ACTION:				
				
					worried = true;					
					if (params.power <= 0) return;
					var v:int = Math.sqrt(params.power);
					
					
					_body.applyImpulse(Vec2.get(_state == STATE_PURSUIT ? params.facing * params.force : params.facing * params.force / 2, 0));	
				
					if (params.y < _body.position.y - view.sprite.height / 2 + 13) {
					//headshot
					
						$VFX.blood.at(params.x, params.y, -params.facing, 0, v);						
						$VFX.blood.at(params.x, params.y, 0, -1, v * 2);
						currentHP -= params.power * 2;			
						
					}else {					
						$VFX.blood.at(params.x, params.y - 30, -params.facing, 0, v);						
						currentHP -= params.power;					
					}
					
					show_hp();
					
					
				break;			
				
			case ActionTypes.TREE_HIT:
				
				$VFX.blood.at(action.params.x, action.params.y, 0, -1, action.params.power / 30);
				$VFX.blood.at(action.params.x, action.params.y + 10, 0, 1, action.params.power / 30);				
				if (action.params.power < 80) return;
				
				_body.space = null;
				dead(action.type);
				break;				
				default:			
				
			}		
				
			if (currentHP <= 0) {
				
				dead(action.type);
				
				
			}
			
			
			
			
		}
		
		
		
		private function dead(by:int):void 
		{
			
			if (isDead) return;			
			isDead = true;			
			
			view.death();
			
			$GLOBAL.dispatch(GlobalEvents.ZOMBIE_KILLED, {type:intType, how:by} );			
			
			if (health_bar != null) {
				TweenLite.killTweensOf(health_bar);
				TweenLite.to(health_bar, .2, { alpha:0, onComplete:onHide } );
			}	
			
			//TODO Remove collisions with everything but ground
			//Collision.setFilter(_body, 0, 0);
						
			_body.cbTypes.remove(GameCb.INTERACTIVE);
			_body.cbTypes.remove(GameCb.ZOMBIE);
			
			Collision.setFilter(_body, Collision.LUMBER_IGNORE);
			_body.group = Collision.dead;
			_body.group.group = Collision.rootgroup;
			
			TweenLite.to(_view.sprite, 4, { y:_body.position.y + 50, delay:2.5, onComplete:remove } );
		}
		
		protected function setParameters(ref:Object):void 
		{
			_view = new BaseSpriteControl(Spitter);
			
			
			var w:int;
			var h:int;			
						
			
			
			if ("w" in ref)
			{
				w = ref.w;				
			}else {
				
				//_view.sprite = new Spitter();
				w = _view.sprite.width;
				
			}	
			
			if ("h" in ref) {
			
				h = ref.h;
				
			}else {
			
				h= _view.sprite.height;
			}
			
			_body = build(Vec2.get(500, 300), [Polygon.rect(0,0, w, h)/*, [5,Vec2.get(6,46)]*/], Material.wood());			
			_body.cbTypes.add(GameCb.INTERACTIVE);
			_body.cbTypes.add(GameCb.ZOMBIE);
			_body.allowRotation = false;			
			_body.userData.graphic = _view.sprite;		
			_body.userData.graphicOffset = new Vec2( 0, h / 2 + 1);					
			_body.userData.interact = interact;		
			_body.space = null;
			
			// Дамми, может встретиться только с «никем» и лучом
			Collision.setFilter(_body, Collision.DUMMIES, ~(Collision.LUMBER_IGNORE|Collision.DUMMIES) );			
			
			
			movementSpeed = ref.ms;
			
			if ("ms_dispersion" in ref) movementSpeed += -ref.ms_dispersion + Math.random() * ref.ms_dispersion * 2;	
			
			maximumHP = currentHP = ref.hp;
			
			viewRange = ref.viewRange;
			senceRange = ref.senceRange;
			
		}
		
		public function add():void {
			
			reset();			
			_body.space = space;
			container.layer2.addChild(_view.sprite);
			selectNewSchedule();
			
		}
		
		protected function reset():void 
		{
			_body.velocity = new Vec2(0, 0);
				
			Collision.setFilter(_body, Collision.DUMMIES, ~(Collision.LUMBER_IGNORE | Collision.DUMMIES) );		
			if (_body.group != null) _body.group.group = null;
			_body.group = null;
			
			currentHP = maximumHP;
			isDead = false;
			view.idle();
			_conditions.clear();
			worried = false;
			if (!_body.cbTypes.has(GameCb.INTERACTIVE)) _body.cbTypes.add(GameCb.INTERACTIVE);
			if (!_body.cbTypes.has(GameCb.ZOMBIE)) _body.cbTypes.add(GameCb.ZOMBIE);			
		}
		
		public function remove():void {			
			
			destroy();	
			GameWorld.EG.deadAgain(this);
			
		}
		
		public function destroy():void {
		
			if (health_bar != null) {
				
				TweenLite.killTweensOf(health_bar);
				healthBars.setInstance(health_bar);
				container.layer0.removeChild(health_bar);
				health_bar = null;
			}
			
			if (_body.space == null) return;
			_body.space = null;
			container.layer2.removeChild(_view.sprite);			
		}
		
		
		//TODO Check this shit
		private static function letthebodyhitthefloor(cb:InteractionCallback):void {
			cb.int1.castBody.space = null;
		}
		
		public function at(X:int, Y:int):void {
			_body.position.setxy(X, Y);
		}
		
		protected function selectNewSchedule():void 
		{
			/*switch (_state) 
			{
				case STATE_STAND:
					if (_conditions.contains(CONDITION_CAN_MELEE_ATTACK)) {
						
						_state = STATE_MELEE;
						_currentShedule = meleeAttack;
						
					}else if (_conditions.contains(CONDITION_CAN_RANGED_ATTACK)) {
						
						_state = STATE_RANGED;
						_currentShedule = rangedAttack;
						
					}else if (_conditions.contains(CONDITION_SEE_ENEMY)) {
						
						_state = STATE_PURSUIT;
						_currentShedule = pursuit;
						
					}else if (_conditions.contains(CONDITION_CAN_WALK)) {
						_state = STATE_WALK;
						_currentShedule = move;
					}
				break;
				
				case STATE_WALK:				
				case STATE_PURSUIT:				
				case STATE_RANGED:				
				case STATE_MELEE:
					
					if (_conditions.contains(CONDITION_CAN_MELEE_ATTACK))
					{
						_currentShedule = meleeAttack;
						_state = STATE_MELEE;
					}
					else if (_conditions.contains(CONDITION_CAN_RANGED_ATTACK))
					{
						_currentShedule = rangedAttack;
						_state = STATE_RANGED;
						
					}else if (_conditions.contains(CONDITION_SEE_ENEMY)) {
						
						_currentShedule = pursuit;
						_state = STATE_PURSUIT;
						
					}				
					else
					{
						_currentShedule = stand;
						_state = STATE_STAND;
					}
					
				break;	
				
			}*/
			
			_currentShedule.reset();
		}
		
		protected function getConditions():void 
		{
			_conditions.clear();
			_conditions.set(CONDITION_CAN_STAND);
			_conditions.set(CONDITION_CAN_WALK);
			
			
		}
		
		protected function onInitStand():Boolean
		{
			_view.idle();
			_interval = 25 + Math.random() * 25;
			return true;
		}
		
		/**
		 * Процесс действия ожидания.
		 */
		protected function onStand():Boolean
		{
			_interval--;
			if (_interval <= 0)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * Инициализация действия движения.
		 */
		protected function onInitMove():Boolean
		{
			var f:int = (Math.random() + 0.5);
			f = f == 0? f = -1 : f = 1;
			
			facing = f;
			
			_view.walk();		
			_interval =  25 + Math.random() * 25;
			
			return true;
		}
		
		/**
		 * Процесс действия движения.
		 */
		protected function onMove():Boolean
		{
			_body.velocity.x = 0;
			_body.applyImpulse(Vec2.get(_facing * movementSpeed, 0));
	
			
			_interval--;
			if (_interval <= 0)
			{
				return true;
			}
			
			return false;
		}
		
		
		
		public function get alias():String 
		{
			return _alias;
		}
		
	}

}