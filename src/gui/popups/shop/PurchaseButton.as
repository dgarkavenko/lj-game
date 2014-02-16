package gui.popups.shop 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import framework.FormatedTextField;
	import framework.input.Controls;
	/**
	 * ...
	 * @author DG
	 */
	public class PurchaseButton extends MovieClip
	{
		
		public var item:String;
		private var melee:Boolean = false;
		
		public function PurchaseButton(a:String, m:Boolean = false ) 
		{
			
			item = a;	
			melee = m;
			var title:FormatedTextField = new FormatedTextField();
			title.text = "["+ a + "]"; 
			addChild(title);
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_OVER, over);
			addEventListener(MouseEvent.MOUSE_OUT, out);
			
		}
		
		private function out(e:MouseEvent):void 
		{
			Controls.mouse.force_track();
		}
		
		private function over(e:MouseEvent):void 
		{
			Controls.mouse.force_no_track();
		}
		

		
		private function onClick(e:MouseEvent):void 
		{
			trace(item);
			Controls.mouse.reset();
			
			//GameWorld.lumberjack.set_weapon(item, melee);
			//dispatchEvent(new Event("temp"));
		}
		
		
	}

}