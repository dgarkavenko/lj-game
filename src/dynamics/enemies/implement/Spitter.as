package dynamics.enemies.implement 
{
	import dynamics.actions.ActionTypes;
	import dynamics.actions.IAction;
	import dynamics.BaseSpriteControl;
	import dynamics.Collision;
	import dynamics.enemies.base.Ranged;
	import dynamics.enemies.Dummy;
	import dynamics.enemies.Projectile;
	import dynamics.GameCb;
	import dynamics.interactions.IInteractive;
	import dynamics.Walker;
	import flash.display.MovieClip;
	import flash.events.Event;
	import gui.Bars.HealthBarCache;
	import gui.Bars.SimpleBar;
	import nape.geom.Vec2;
	import nape.phys.Material;
	import nape.shape.Polygon;

	
	/**
	 * ...
	 * @author DG
	 */
	public class Spitter extends Ranged
	{
		
		private var sprite:MovieClip;
		
		private var max_hp:int = 50;
		
		
		private static var lj_pos:Vec2;
		
		private var ite:int = 0;
		
		
		
		
		public function Spitter() 
		{			
			super("spitter");		
			
			sprite = new MovieClip();			
			sprite = _view.sprite;			
			
		}
		
		
		
		
		override protected function getConditions():void 
		{
			
			_conditions.clear();
			
			var distance:Number = Vec2.distance(_body.position, lj_pos);
			
			//if ( distance < meleeRange && meleeAttackCooldown <= 0) _conditions.set(CONDITION_CAN_MELEE_ATTACK);
			if ( distance < 160) _conditions.set(CONDITION_CAN_RANGED_ATTACK);		
			if (distance < 250) _conditions.set(CONDITION_SEE_ENEMY);
			
			_conditions.set(CONDITION_CAN_STAND);
			_conditions.set(CONDITION_CAN_WALK);
			
			
		}
		
		override protected function selectNewSchedule():void 
		{
			switch (_state) 
			{
				case STATE_STAND:
					if (_conditions.contains(CONDITION_CAN_MELEE_ATTACK)) {
						
						_state = STATE_MELEE;
						_currentShedule = meleeAttack;
						
					}else if (_conditions.contains(CONDITION_CAN_RANGED_ATTACK)) {
						
						if ( rangedAttackCooldown > 0) {
							_state = STATE_STAND;
							_currentShedule = stand;
							
						}else {							
							_state = STATE_RANGED;
							_currentShedule = rangedAttack;
						}
						
						
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
						if ( rangedAttackCooldown > 0) {
							_state = STATE_STAND;
							_currentShedule = stand;
							
						}else {							
							_state = STATE_RANGED;
							_currentShedule = rangedAttack;
						}
						
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
				
			}
			
			_currentShedule.reset();
		}
		
		override protected function onInitRangedAttack():Boolean
		{
			
			
			view.attack();
			sprite.body.addEventListener("onAttack", launchProjectile);

			
			return true;
		}
		
		private function launchProjectile(e:Event = null):void 
		{
			
			var d:int = 1;
			if (lj_pos.x < _body.position.x) d = -1;
			
			_view.face(d);
			
			
			
			sprite.body.removeEventListener("onAttack", launchProjectile);
			var p:Projectile = new Projectile();
			p.add();
			p.getPhysics().position = _body.position.add(Vec2.get(10 * d, - 15));
			
			
			var imp:Vec2 = Vec2.get(Vec2.distance(_body.position, lj_pos) / 4 * d, -75 );
			
			p.getPhysics().applyImpulse(imp);
		}
		
		override protected function onRangedAttack():Boolean 
		{
			
			return (sprite.body.currentFrame == sprite.body.totalFrames) ? true : false;
			
		}
		
		override protected function onEndRangedAttack():Boolean 
		{			
			rangedAttackCooldown = 100;			
			view.idle();
			return true;
		}
		
		override protected function onEndMeleeAttack():Boolean 
		{
			return true;
		}
		
		override protected function onMeleeAttack():Boolean 
		{
			return true;
		}
		
		
		override protected function onInitStand():Boolean
		{
			view.idle();
			_interval = rangedAttackCooldown <= 0 ? 25 + Math.random() * 25 : rangedAttackCooldown;
			return true;
		}
		
		
		
		override protected function onInitMeleeAttack():Boolean
		{
			view.attack();
			
			return true;
		}
		
		/**
		 * Процесс действия ожидания.
		 */
		override protected function onStand():Boolean
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
		override protected function onInitMove():Boolean
		{
			
			var f:int = (Math.random() + 0.5);
			f = f == 0? f = -1 : f = 1;
			
			facing = f;
			
			view.walk();		
			_interval =  25 + Math.random() * 25;
			
			return true;
		}
		
		/**
		 * Процесс действия движения.
		 */
		override protected function onMove():Boolean
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
		
		/**
		 * Инициализация действия преследования.
		 */
		override protected function onInitPursuit():Boolean
		{
			
			view.walk();
			return true;
		}
		
		/**
		 * Процесс действия преследования.
		 */
		override protected function onPursuit():Boolean
		{
			var d:int = 1;
			if (lj_pos.x < _body.position.x) d = -1;			
			_view.face(d);
			
			_body.velocity.x = 0;
			_body.applyImpulse(Vec2.get(d * movementSpeed, 0));			
			
			return false;
		}
		
		override public function tick():void {
			
			if (++ite >= 10) {
				
				getConditions();			
				if (_currentShedule != null && _currentShedule.isCompleted(_conditions))
				{
					selectNewSchedule();
				}
				
				ite = 0;
				
			}
			
			if (rangedAttackCooldown > 0) rangedAttackCooldown--;
			
			
			
			if (_currentShedule != null) {
				_currentShedule.update();
			}
			
		}
		
	}

}