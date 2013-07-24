package dynamics 
{
	import nape.phys.Body;
	/**
	 * Все разумные существа должны расширять этот класс.
	 * @author DG
	 */
	public class Walker extends WorldObject
	{
		protected var _facing:int = 1;
		protected var _view:BaseSpriteControl;	
		protected var _body:Body;	
		
		
		protected var offset_x:Number = 0;
		protected var offset_y:Number = 0;
		
		public function Walker() 
		{
			
		}
		
		public function tick():void 
		{
			
		}	
		/**
		 * -1 — налево, +1 — направо
		 */
		public function set facing(value:int):void 
		{
			if (_facing == value) return;
			_facing = value;			
			_view.face(_facing);
		}
		
		public function get view():BaseSpriteControl 
		{
			return _view;
		}
		
		public function get facing():int 
		{
			return _facing;
		}
		
		
	}

}