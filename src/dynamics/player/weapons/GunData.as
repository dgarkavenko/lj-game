package dynamics.player.weapons 
{
	import gamedata.DataSources;
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
		public var force:Number;
		public var recoilPerShoot:Number;
		public var recoilReduction:Number;
		
		
		
		public var reload_counter:int = 0;
		
		
		public function GunData(a:String){
			type = TYPE_GUN;
			super(a);
		}
		
		override public function load(a:String):void 
		{
			
			var weapon:Object = DataSources.instance.getReference(a);
				
			ammo_max = ammo_current = weapon.ammo_max;
			dispersion = weapon.dispersion;
			fragments = weapon.fragments;
			mode = weapon.mode;
			rate = weapon.rate;
			reload_time = weapon.reload_time;
			damage_min = weapon.damage_min;
			damage_max = weapon.damage_max;	
			price = weapon.price;
			force = weapon.force;
			
			if ("rps" in weapon) recoilPerShoot = weapon.rps;
			else recoilPerShoot = 0;
			if ("rrpf" in weapon) recoilReduction = weapon.rrpf;
			else recoilReduction = 0;
			
			
			alias = a;
			flag = weapon.flag;
			
			
		}
		
	}

}