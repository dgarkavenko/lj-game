package gameplay 
{
	/**
	 * ...
	 * @author DG
	 */
	public class KilledBy 
	{
		
		public static var TREE:uint = 1;
		public static var SHOTGUN:uint = 2;
		public static var AXE:uint = 4;
		public static var PISTOL:uint = 8;
		public static var AUTOGUN:uint = 16;
		public static var SNIPER:uint = 32;
		static public const CHAINSAW:uint = 64;
		public static var MINE:uint = 128;
		public static var DYNAMITE:uint = 256;
		
		public static var EXPLOSIVES:uint = DYNAMITE | MINE;
		public static var ANY_GUN:uint = SHOTGUN | PISTOL | AUTOGUN | SNIPER;
		public static var ANY:uint = ANY_GUN | TREE | AXE | CHAINSAW | EXPLOSIVES;
		
		
		
	}

}