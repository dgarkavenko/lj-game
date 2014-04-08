package gui 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author DG
	 */
	public class ButtonHandler 
	{
		
		public var clip:MovieClip;
		
		public var mouseDownAction:Function;
		public var mouseClickAction:Function;
		public var mouseOutAction:Function;
		public var mouseOverAction:Function;
		
		private var _text:String = "1000";
		
		public function ButtonHandler(clip_:MovieClip) 
		{
			clip = clip_;
			ButtonMode(clip);
		
		
		}
		
		public static function ButtonMode(mc:MovieClip):void {
			mc.stop();
			mc.buttonMode = true;
			mc.useHandCursor = true;
			mc.mouseChildren = false;
		}
		
		public function listen():void {
			clip.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			clip.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			clip.addEventListener(MouseEvent.CLICK, mouseClick);
			clip.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			clip.gotoAndStop(3);
			clip.price.text = text;
			if (mouseDownAction != null) mouseDownAction(e);
		}
		
		private function mouseClick(e:MouseEvent):void 
		{
			clip.gotoAndStop(1);
			clip.price.text = text;
			if (mouseClickAction!= null) mouseClickAction(e);
		}
		
		private function mouseOut(e:MouseEvent):void 
		{
			clip.gotoAndStop(1);
			clip.price.text = text;
			if (mouseOutAction!= null) mouseOutAction(e);
		}
		
		private function mouseOver(e:MouseEvent):void 
		{
			clip.gotoAndStop(2);
			clip.price.text = text;
			if (mouseOverAction!= null) mouseOverAction(e);
		}
		
		public function dontlisten():void {
			clip.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			clip.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			clip.removeEventListener(MouseEvent.CLICK, mouseClick);
			clip.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(value:String):void 
		{
			_text = value;
			clip.price.text = _text;
		}
		
	}

}