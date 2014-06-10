package dynamics.player.weapons 
{
	import gamedata.DataSources;
	import gameplay.KilledBy;
	/**
	 * ...
	 * @author DG
	 */
	public class ExplosiveData extends WeaponData
	{
		
		public var capacity:int = 5;
		public var count:int = 5;
		
		
		
		public function ExplosiveData(a:String) 
		{
			type = TYPE_EXPLOSIVE;
			flag = KilledBy.EXPLOSIVES;
			super(a);
		}
		
		override public function load(a:String, w:Object = null):void 
		{			
			//var weapon:Object = DataSources.instance.getReference(a);
			alias = a;			
		}
		
	}

}