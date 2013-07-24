package framework.misc 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import framework.FormatedTextField;
	import hud.PixelButton_mc;
	/**
	 * ...
	 * @author DG
	 */
	public class PixelButton extends PixelButton_mc
	{
		
		public function PixelButton(title:String, size:int = 14) 
		{
			
			var tf:FormatedTextField = new FormatedTextField();
			tf.defaultTextFormat.size = size;
			tf.text = title; tf.height = tf.textHeight;
			addChild(tf);
			
			tf.x = (width - tf.textWidth) / 2;
			tf.y = 10;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			stop();
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseOut);
			
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			gotoAndStop("down");
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			gotoAndStop("over");
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			gotoAndStop("up");
		}
		
	
		
		private function onRemove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			removeEventListener(MouseEvent.CLICK, onMouseOut);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
		}
		
	}

}