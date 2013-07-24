package dynamics.player.weapons 
{
	/**
	 * ...
	 * @author DG
	 */
	public class GunShop 
	{
		
		public var list:Array;
		
		public var pistol:GunData = new GunData();
		public var shotgun:GunData = new GunData();
		public var assault:GunData = new GunData();
		public var axe:ToolData = new ToolData();
		public var axe_double:ToolData = new ToolData();
		public var axe_fire:ToolData = new ToolData();
		
		public function GunShop() 
		{
			pistol.ammo_max = pistol.ammo_current = 7;
			pistol.dispersion = 0;
			pistol.fragments = 1
			pistol.mode = Gun.SEMI;
			pistol.rate = 220;
			pistol.reload_time = 40;
			pistol.damage_min = 5;
			pistol.damage_max = 6;
			pistol.alias = "pistol";
			pistol.bought = true;
			
			shotgun.ammo_max = shotgun.ammo_current = 2;
			shotgun.dispersion = 0.066;
			shotgun.fragments = 6;
			shotgun.mode = Gun.SEMI;
			shotgun.rate = 200;
			shotgun.reload_time = 120;
			shotgun.damage_min = 3;
			shotgun.damage_max = 5;
			shotgun.alias = "shotgun";
			shotgun.bought = true;
			
			assault.ammo_max = assault.ammo_current = 20;
			assault.dispersion = 0;
			assault.fragments = 1
			assault.mode = Gun.AUTO;
			assault.rate = 150;
			assault.reload_time = 40;
			assault.damage_min = 7;
			assault.damage_max = 10;
			assault.alias = "assault";
			assault.bought = true;
			
			axe.alias = "axe_rusty";
			axe.inc = 0.1;
			axe.bought = true;
			axe.t_dmg = 2.5;
			axe.z_dmg = 4;
			
			axe_double.alias = "axe_double";
			axe_double.inc = 0.15;
			axe_double.bought = true;
			axe_double.t_dmg = 4;
			axe_double.z_dmg = 4;
			
			axe_fire.alias = "axe_fire";
			axe_fire.inc = 0.15;
			axe_fire.bought = true;
			axe_fire.t_dmg = 3;
			axe_fire.z_dmg = 7;
			
				
			
			list = [pistol, shotgun, assault, axe_fire, axe_double, axe];
			
		}
		
	}

}