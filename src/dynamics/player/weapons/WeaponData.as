package dynamics.player.weapons 
{
	/**
	 * ...
	 * @author DG
	 */
	public class WeaponData extends Object
	{
		
		static public const TYPE_GUN:int = 1;
		static public const TYPE_TOOL:int = 0;
		static public const TYPE_MISC:int = 2;
		
		public var price:int;
		public var bought:Boolean = false;
		public var alias:String;	
		public var type:int;
		public var flag:uint;
		
		public function WeaponData(a:String) 
		{
			if (a != "") load(a);
		}
		
		public function load(a:String):void 
		{
			
		}
		
	}

}