package locations 
{
	import flash.utils.setTimeout;
	import framework.ScreenManager;
	import framework.screens.GameScreen;
	import framework.screens.LoadingScreen;
	/**
	 * ...
	 * @author DG
	 */
	public class LocationManager 
	{
		
		public var current:BaseLocation;
		
		
		public function LocationManager() 
		{
			current = new HomeLocation();
			
		}
		
		public function goto(cls:Class, world_:GameWorld):void {
			
			ScreenManager.inst.showScreen(LoadingScreen);
			
			current.destroy();
			current = new cls();
			current.build(world_);
			
			setTimeout(loadComplete, 1500);
			
			
		}
		
		private function loadComplete():void {
			ScreenManager.inst.showScreen(GameScreen);
		}
		
		public function get initial_Y():int 
		{
			return current.initial_y;
		}	
		
		public function get initial_X():int 
		{
			return current.initial_x;
		}		
		
		
	}

}