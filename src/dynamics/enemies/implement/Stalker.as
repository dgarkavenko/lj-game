package dynamics.enemies.implement 
{
	import dynamics.enemies.base.Standart;
	import gameplay.TreeHandler;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author DG
	 */
	public class Stalker extends Standart
	{
		private var destination:int;
		private var ite:int = 0;
		public function Stalker() 
		{
			super("stalker");
			viewRange = 60;
		}
		
		override public function tick():void {
			super.tick();
			if (currentHP <= 0) return;
			
			if (++ite >= 10) {
				
				getConditions();			
				if (_currentShedule != null && _currentShedule.isCompleted(_conditions))
				{
					selectNewSchedule();
				}
				
				
				
				ite = 0;
				
			}
			
				
			
			if (_currentShedule != null) {
				_currentShedule.update();
			}
			
		}
		
		override protected function getConditions():void 
		{			
			_conditions.clear();	
			
			var distance:Number = Vec2.distance(_body.position, daddy.lumbervec);			
			var viewDirTowardsLj:Boolean = (_facing == 1 && _body.position.x < daddy.lumbervec.x) || (_facing == -1 && _body.position.x > daddy.lumbervec.x);
			
			if ( distance < meleeAttackRange && viewDirTowardsLj) {				
				_conditions.set(CONDITION_CAN_MELEE_ATTACK);				
				_conditions.set(CONDITION_SEE_ENEMY);
			}
			else if ((distance < viewRange && viewDirTowardsLj) || worried || distance < senceRange) {
				
				_conditions.set(CONDITION_SEE_ENEMY);				
			}			
			_conditions.set(CONDITION_CAN_STAND);
			_conditions.set(CONDITION_CAN_WALK);			
			
		}
		
		override protected function onInitStand():Boolean
		{
			_view.idle();
			_interval = Math.abs(_body.position.x - destination) < 10 ? 60 + Math.random() * 60 : 15;
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
			
			_interval = 15;
			destination = TreeHandler.inst.getNearestForegroundTreeX(_body.position.x) -3 + Math.random() * 6;
			if (destination > _body.position.x) facing = 1;
			else facing = -1;			
			
			_view.walk();		
			
			
			return true;
		}
		
		/**
		 * Процесс действия движения.
		 */
		override protected function onMove():Boolean
		{
			_body.velocity.x = 0;
			_body.applyImpulse(Vec2.get(_facing * movementSpeed, 0));
			
			
			if (Math.abs(_body.position.x - destination + Math.random()) < 3 || _interval < 0) return true;		
			return false;
		}
		
		
		
		
	}

}