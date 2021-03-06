package locations 
{
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import framework.ScreenManager;
	import framework.screens.GameScreen;
	import framework.screens.LoadingScreen;
	import utils.VisualAlignment;
	/**
	 * ...
	 * @author DG
	 */
	public class LocationManager 
	{
		
		public var current:BaseLocation;
		private var currentClass:Class;
		private var world:GameWorld;		
		private static var _inst:LocationManager;
		
		public var trees:Dictionary = new Dictionary();
		public var stumps:Dictionary = new Dictionary();
		
		public function LocationManager() {
			
		}
		
		static public function get inst():LocationManager
		{
			if (_inst == null) _inst = new LocationManager();
			return _inst;
		}
		
		public function init(world_:GameWorld):void
		{
			world = world_;
			current = new HomeLocation();
			currentClass = HomeLocation;
			current.build(world);			
		}
		
		public function goto(cls:Class):void {
			
			if (current == null || currentClass == cls) return;
			
			ScreenManager.inst.showScreen(LoadingScreen);
			
			current.destroy();
			current = new cls();
			currentClass = cls;
			current.build(world);
			GameWorld.lumberbody.position.setxy(current.initial_x, current.initial_y);
			VisualAlignment.apply(GameWorld.lumberbody);			
			setTimeout(loadComplete, 500);			
			
		}
		
		public function ljPositionChangedTo(x:Number):void 
		{
			if (x > current.location_w) current.right();
			else if (x < 0) current.left();
		}
		
		private function loadComplete():void {
			ScreenManager.inst.showScreen(GameScreen);
			current.OnLoadComplete();
			Game.updateFunction = world.tick;
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