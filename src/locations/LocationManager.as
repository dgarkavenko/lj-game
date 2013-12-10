package locations 
{
	/**
	 * ...
	 * @author DG
	 */
	public class LocationManager 
	{
		
		public var current:BaseLocation;
		
		
		public function LocationManager() 
		{
			current = new ForestLocation();
			
		}
		
		public function goto(cls:Class, world_:GameWorld):void {
			
			current.destroy();
			current = new cls();
			current.build(world_);
			
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