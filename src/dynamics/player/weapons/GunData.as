package dynamics.player.weapons 
{
	/**
	 * ...
	 * @author DG
	 */
	public class GunData extends WeaponData
	{
		
			
		public var ammo_max:int;
		public var ammo_current:int;
		public var reload_time:int;
		public var mode:uint;
		public var rate:int;
		public var dispersion:Number;
		public var fragments:int = 1;
		public var damage_min:int;
		public var damage_max:int;
		
		
		public var reload_counter:int = 0;
		
		
		public function GunData(){
			type = TYPE_GUN;
		}
		
	}

}