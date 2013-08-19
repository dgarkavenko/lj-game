package dynamics.player.weapons 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import gamedata.DataSources;
	
	/**
	 * ...
	 * @author DG
	 */
	public class GunShop 
	{
		private var _JSONLoader:URLLoader;
		private var _JSONEncodedData:Object;
		
		
		
		public var list:Array = new Array();
		
		
		public var assault:GunData = new GunData();
		public var axe:ToolData = new ToolData();
		public var axe_double:ToolData = new ToolData();
		public var axe_fire:ToolData = new ToolData();
	
	
	
		
		private function getNewWeaponDataFromConfig(name:String):WeaponData {
			
			var weapon:Object = DataSources.instance.getReference(name);
			var type:uint = uint(weapon.type);
			
			var data:WeaponData;
			
			
			
			if (type == WeaponData.TYPE_GUN) {				
				data = new GunData();				
				(data as GunData).ammo_max = (data as GunData).ammo_current = weapon.ammo_max;
				(data as GunData).dispersion = weapon.dispersion;
				(data as GunData).fragments = weapon.fragments;
				(data as GunData).mode = weapon.mode;
				(data as GunData).rate = weapon.rate;
				(data as GunData).reload_time = weapon.reload_time;
				(data as GunData).damage_min = weapon.damage_min;
				(data as GunData).damage_max = weapon.damage_max;			
				
			}else if (type == WeaponData.TYPE_TOOL) {
				data = new ToolData();
				(data as ToolData).z_dmg = Number(weapon.z_dmg);
				(data as ToolData).t_dmg = Number(weapon.t_dmg);
				(data as ToolData).inc = Number(weapon.inc);
			}else{
				data = new GunData();
			}
			
			data.price = weapon.price;
			data.alias = name;
			data.type = type;	
			data.bought = true;
			
			return data;
		}
		
		public function GunShop() 
		{
			
			list.push(getNewWeaponDataFromConfig("pistol"));
			list.push(getNewWeaponDataFromConfig("shotgun"));
			
			
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
			
			list.push(assault);
			
			axe.alias = "axe_rusty";
			axe.inc = 0.1;
			axe.bought = true;
			axe.t_dmg = 2.5;
			axe.z_dmg = 4;
			
			list.push(axe);
			
			axe_double.alias = "axe_double";
			axe_double.inc = 0.15;
			axe_double.bought = true;
			axe_double.t_dmg = 4;
			axe_double.z_dmg = 4;
			
			list.push(axe_double);
			
			axe_fire.alias = "axe_fire";
			axe_fire.inc = 0.15;
			axe_fire.bought = true;
			axe_fire.t_dmg = 3;
			axe_fire.z_dmg = 7;
			
			list.push(axe_fire);
			
				
			
			
			
		}
		
	}

}