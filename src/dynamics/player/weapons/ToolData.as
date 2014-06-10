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
		
		
		
		
		public function ToolData(a:String, preload_:Boolean = false) 
		{
			if (a == "chainsaw") {
				type = TYPE_CHAINSAW;
				flag = KilledBy.CHAINSAW;
			}else {
				type = TYPE_AXE;
				flag = KilledBy.AXE;
			}			
		
			super(a, preload_);
		}
		
		override public function load(a:String, w:Object = null):void 
		{
			var weapon:Object = w == null? DataSources.instance.getReference(a) : w;
				
			z_dmg = weapon.z_dmg;
			t_dmg = weapon.t_dmg;
			inc = weapon.inc;
				
			alias = a;				
		}
		
	}

}