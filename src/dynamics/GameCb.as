package dynamics 
{
	import nape.callbacks.CbType;
	/**
	 * ...
	 * @author DG
	 */
	public class GameCb 
	{
		
		//Взаимоисключающие
		public static const LUMBERJACK:CbType = new CbType();
		public static const GROUND:CbType = new CbType();
		public static const TREE:CbType = new CbType();
		public static const BUILDING:CbType = new CbType();
		static public const TRUNK:CbType = new CbType();
		static public const ZOMBIE:CbType = new CbType();
		static public const PROJECTILE:CbType = new CbType();
		
		//Служебные
		static public const INTERACTIVE:CbType = new CbType();
		static public const TIP:CbType = new CbType();
		static public const BULLET:CbType = new CbType();
		static public const PLAYER_INTERACTIVE:CbType = new CbType();
		static public const LEGS:CbType = new CbType();
		static public const PUDDLE:CbType = new CbType();
		
		
		
	}

}