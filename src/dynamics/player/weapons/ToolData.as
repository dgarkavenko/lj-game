package dynamics.player.weapons 
{
	import gamedata.DataSources;
	import gameplay.KilledBy;
	/**
	 * ...
	 * @author DG
	 */
	public class ToolData extends WeaponData
	{
		
		public var z_dmg:Number;
		public var t_dmg:Number;
		public var inc:Number;
		
		
		
		
		public function ToolData(a:String) 
		{
			type = TYPE_TOOL;
			flag = KilledBy.AXE;
			super(a);
		}
		
		override public function load(a:String):void 
		{
			var weapon:Object = DataSources.instance.getReference(a);
				
			z_dmg = weapon.z_dmg;
			t_dmg = weapon.t_dmg;
			inc = weapon.inc;
				
			alias = a;				
		}
		
	}

}