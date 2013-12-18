package framework.screens 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import framework.FormatedTextField;
	import framework.input.Controls;
	import framework.ScreenManager;
	import framework.screens.MapScreen.MapElement;
	import locations.ForestLocation;
	import locations.HomeLocation;
	import locations.LocationManager;
	/**
	 * ...
	 * @author dg
	 */
	public class MapScreen extends BaseScreen
	{
		
		
		private var elements:Array = [];
		
		public function MapScreen() 
		{
			
			
			
			
			background(0x171729);
			
			
			var ttl:FormatedTextField = new FormatedTextField(FormatedTextField.HEADER, 0xffffff);			
			ttl.text = "Map";	
			ttl.x = 50;
			ttl.y = 50;
			addChild(ttl);
			
			elements.push(new MapElement("[Home]", HomeLocation));
			elements.push(new MapElement("[CrashSite]", ForestLocation));
			
			for (var i:int = 0; i < elements.length; i++) 
			{
				elements[i].x = 50;
				elements[i].y = 100 + i * 30;
				addChild(elements[i]);
			}
		}
		
		override protected function onReady():void {
			
			
			Mouse.show();
			
			for each (var e:MapElement in elements) 
			{
				e.addEventListener(MouseEvent.CLICK, onElementClick);
			}
			
			Game.updateFunction = tick;
		}
		
		private function onElementClick(e:MouseEvent):void 
		{
			LocationManager.inst.goto((e.currentTarget as MapElement).location);
		}
		
		private function tick():void 
		{
			if (Controls.keys.ESCAPE) close(); 
		}
		
		private function close(e:Event = null):void 
		{
			ScreenManager.inst.showScreen(GameScreen);
		}
		
		override protected function onStartHiding():void {
			Game.updateFunction = Game.EMPTY_FUNCTION;
			Mouse.hide();
			for each (var e:MapElement in elements) 
			{
				e.removeEventListener(MouseEvent.CLICK, onElementClick);
			}
		}
		
	}

}