package gui.popups.shop 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import framework.FormatedTextField;
	/**
	 * ...
	 * @author DG
	 */
	public class PurchaseButton extends MovieClip
	{
		
		private var item:String;
		private var melee:Boolean = false;
		
		public function PurchaseButton(a:String, m:Boolean = false ) 
		{
			
			item = a;	
			melee = m;
			var title:FormatedTextField = new FormatedTextField();
			title.text = "["+ a + "]"; 
			addChild(title);
			addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		private function onClick(e:MouseEvent):void 
		{
			//GameWorld.lumberjack.set_weapon(item, melee);
			dispatchEvent(new Event("temp"));
		}
		
	}

}