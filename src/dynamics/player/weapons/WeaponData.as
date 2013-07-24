package dynamics.player.weapons 
{
	/**
	 * ...
	 * @author DG
	 */
	public class WeaponData 
	{
		
		static public const TYPE_GUN:int = 0;
		static public const TYPE_TOOL:int = 1;
		
		public var price:int;
		public var bought:Boolean = false;
		public var alias:String;	
		public var type:int;
		
		public function WeaponData() 
		{
			
		}
		
	}

}