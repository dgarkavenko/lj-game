package dynamics.enemies 
{
	import dynamics.actions.ActionTypes;
	import dynamics.actions.IAction;
	import dynamics.BaseSpriteControl;
	import dynamics.Collision;
	import dynamics.enemies.ai.ConditionList;
	import dynamics.enemies.ai.Schedule;
	import dynamics.GameCb;
	import dynamics.interactions.IInteractive;
	import dynamics.Walker;
	import gamedata.DataSources;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Polygon;
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
		protected var pursuit:Schedule;	
		
		protected var _alias:String;
		
		protected var movementSpeed:int;
		protected var maximumHP:int;
		protected var currentHP:int;
		protected var viewRange:int;		
		
		protected var ljPos:Vec2;		
		protected var _interval:int;
		protected var _thinkIteration:int;
		
		
		public function Dummy(alias:String) 
		{
			//_view = new BaseSpriteControl(ZStore.GetMC(alias));
			_alias = alias;
			setParameters();
			
			stand = new Schedule("Stand");
			stand.addFewInterrupts([CONDITION_SEE_ENEMY, CONDITION_CAN_RANGED_ATTACK, CONDITION_CAN_MELEE_ATTACK]);
			stand.addFewTasks([onInitStand, onStand]);
			
			move = new Schedule("Move");
			move.addFewTasks([ onInitMove, onMove ]);
			move.addFewInterrupts([ CONDITION_CAN_MELEE_ATTACK, CONDITION_CAN_RANGED_ATTACK, CONDITION_SEE_ENEMY ]);
			
			pursuit = new Schedule("Pursuit");
			pursuit.addFewTasks([ onInitPursuit, onPursuit ]);
			pursuit.addFewInterrupts([CONDITION_CAN_RANGED_ATTACK ]);						
			
			
			_currentShedule = stand;
			_state = STATE_STAND;
		}
		
		/* INTERFACE dynamics.interactions.IInteractive */
		
		public function interact(action:IAction):void 
		{
			
			var params:Object = action.params;
			
			switch (action.type) 
			{
				
				//TODO: Types to UINTS
				case ActionTypes.CHOP_ACTION:
					
					$VFX.blood.at(params.x, params.y, -params.facing, 0, params.power * 4);
					_body.applyImpulse(Vec2.get(params.facing * params.power * 2, 0));
					currentHP -= params.power * params.z_dmg;
					
				break;
				
				case ActionTypes.GUNSHOT_ACTION:
				
					/*var h:int = sprite.height;					
					var c:int = _body.position.y;
					var mod:int = 1;
					
					if (params.y < c - h / 2 + 10) mod = 2;
					
					$VFX.blood.at(params.x, params.y, -params.facing, 0, params.power * mod);
					_body.applyImpulse(Vec2.get(params.facing * params.power * 2, -params.power));					
					hp -= params.power * mod;*/
					
					
					
				break;				
				
				default:			
				
			}
			
			
			
			
		}
		
		protected function setParameters():void 
		{
			//_view = new BaseSpriteControl();
			var z:DataSources = DataSources.instance;
			
			var w:int;
			var h:int;
			
			if (int(z.getParameter(_alias, "override")) == 1)
			{
				w = z.getParameter(_alias, "w");
				h = z.getParameter(_alias, "h");
			}else {
				
				w = _view.sprite.width;
				h= _view.sprite.height;
			}		
			
			//_body = build(Vec2.get(X, Y), [Polygon.rect(0,0, 12, 42), [5,Vec2.get(6,46)]], Material.wood());			
			_body.cbTypes.add(GameCb.INTERACTIVE);
			_body.cbTypes.add(GameCb.ZOMBIE);
			_body.allowRotation = false;			
			_body.userData.graphic = _view.sprite;		
			_body.userData.graphicOffset = new Vec2( 0, -_view.sprite.height / 2);			
			container.layer2.addChild(_view.sprite);			
			_body.userData.interact = interact;			
			
			// Дамми, может встретиться только с «никем» и лучом
			Collision.setFilter(_body, Collision.DUMMIES, ~(Collision.LUMBER_IGNORE|Collision.DUMMIES) );			
			ljPos = GameWorld.lumberbody.position;
			
			movementSpeed = int(z.getParameter(_alias, "ms"));
			maximumHP = int(currentHP = z.getParameter(_alias, "hp"));
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
			return true;
		}
		
		/**
		 * Процесс действия ожидания.
		 */
		protected function onStand():Boolean
		{
			return true;
		}
		
		/**
		 * Инициализация действия движения.
		 */
		protected function onInitMove():Boolean
		{
			return true;
		}
		
		/**
		 * Процесс действия движения.
		 */
		protected function onMove():Boolean
		{
			return true;
		}
		
		/**
		 * Инициализация действия преследования.
		 */
		protected function onInitPursuit():Boolean
		{
			return true;
		}
		
		/**
		 * Процесс действия преследования.
		 */
		protected function onPursuit():Boolean
		{
			return true;
		}
		
	}

}