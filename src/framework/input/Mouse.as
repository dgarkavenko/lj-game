package framework.input 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author DG stole from Flixel
	 */
	public class Mouse
	{
		
		//Для расчета относительной координаты мыши
		private var container:Sprite = GameWorld.container;
		private var tracker:DisplayObject;
		
		private var _current:int;
		private var _last:int;
		
		
		
		public function Mouse() 
		{			
			_current = 0;
			_last = 0;
		}
		
		
		
		/**
		 * Resets the just pressed/just released flags and sets mouse to not pressed.
		 */
		public function reset():void
		{
			_current = 0;
			_last = 0;
			
		}
		
		/**
		 * Check to see if the mouse is pressed.
		 * 
		 * @return	Whether the mouse is pressed.
		 */
		public function pressed():Boolean { return _current > 0; }
		
		/**
		 * Check to see if the mouse was just pressed.
		 * 
		 * @return Whether the mouse was just pressed.
		 */
		public function justPressed():Boolean { return _current == 2; }
		
		/**
		 * Check to see if the mouse was just released.
		 * 
		 * @return	Whether the mouse was just released.
		 */
		public function justReleased():Boolean { return _current == -1; }
		
		
		
		public function handleMouseDown(FlashEvent:MouseEvent):void
		{
			if(_current > 0) _current = 1;
			else _current = 2;		
		}
		
		public function handleMouseUp(FlashEvent:MouseEvent):void
		{
			if(_current > 0) _current = -1;
			else _current = 0;
		}
		
		public function update():void
		{
			
			
			
			if((_last == -1) && (_current == -1))
				_current = 0;
			else if((_last == 2) && (_current == 2))
				_current = 1;
			_last = _current;
			
			
		}
		
		public function init(visual_object:Sprite):void 
		{
			
			//keyboard
			visual_object.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, false);
			visual_object.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, false);			
			tracker = visual_object;				
		}
		
		public function get screenX():Number {
			return tracker.mouseX;
		}
		
		public function get screenY():Number {
			return tracker.mouseY;
		}
		
		public function get relativeX():Number {
			return container.mouseX;
		}
		
		public function get relativeY():Number {
			return container.mouseY;
		}
		
	}

}