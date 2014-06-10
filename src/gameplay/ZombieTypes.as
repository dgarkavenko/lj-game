package gameplay 
{
	/**
	 * ...
	 * @author dg
	 */
	public class ZombieTypes 
	{
		
		public static var SPITTER:uint = 1;
		public static var STALKER:uint = 2;
		public static var CRAWLER:uint = 4;
		public static var MANAGER:uint = 8;
		
		public static var ANY:uint = SPITTER | STALKER | CRAWLER | MANAGER;
		
	}

}