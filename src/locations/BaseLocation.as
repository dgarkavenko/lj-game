package locations 
{
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
		
		public function tick():void 
		{
			
		}
		
		public function destroy():void {
			
		}
		
		
		
	}

}