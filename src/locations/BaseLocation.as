package locations 
{
	import gameplay.TreeHandler;
	import gameplay.world.Ground;
	
	/**
	 * ...
	 * @author DG
	 */
	public class BaseLocation 
	{
		public var initial_y:int = 250;
		public var initial_x:int = 500;
		public var location_w:int;
		
		
		protected var world:GameWorld;
		
		public function BaseLocation() 
		{
			
		}
		
		public function build(world_:GameWorld):void {
			
			world = world_;
			world.softReset();
			GameWorld.camera.locationWidth = location_w;
			addBackground();
			
		}
		
		public function addBackground():void 
		{
			
		}
		
		public function destroy():void {
				
			while (GameWorld.container.layer0.numChildren > 0) {
				GameWorld.container.layer0.removeChildAt(0);
			}
			
			while (GameWorld.container.layer4.numChildren > 0) {
				GameWorld.container.layer4.removeChildAt(0);
			}
		
		}
		
		public function left():void 
		{
			
		}
		
		public function right():void 
		{
			
		}
		
		public function OnLoadComplete():void 
		{
			
		}
		
		public function timeUpdate(time:int):void 
		{
			
		}
		
		
		
	}

}