package dynamics.enemies.implement 
{
	import dynamics.BaseSpriteControl;
	import dynamics.enemies.base.Standart;
	import gameplay.TreeHandler;
	import nape.geom.Vec2;
	import visual.z.SteveView;
	/**
	 * ...
	 * @author DG
	 */
	public class Stalker extends Standart
	{
		private var destination:int;
		public function Stalker() 
		{
			super("stalker");
			viewRange = 60;
		}
		
		override protected function setView():void {		
			_view = new BaseSpriteControl(SteveView);		
		}				
		
		override public function tick():void {
			
			
			if (isDead) return;
			super.tick();
			if (++ite >= 10) {
				
				getConditions();			
				if (_currentShedule != null && _currentShedule.isCompleted(_conditions))
				{
					selectNewSchedule();
				}
				
				ite = 0;
				
			}
		
			
			
		}
		
		
		
		override protected function onInitStand():Boolean
		{
			_body.velocity.x = 0;
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
			
			_interval = 15 + Math.random() * 10;
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
			_body.velocity.x = _facing * movementSpeed * 3;			
			_interval--;		
			
			if (Math.abs(_body.position.x - destination + Math.random()) < 3 || _interval < 0) return true;		
			return false;
		}
		
		
		
		
	}

}