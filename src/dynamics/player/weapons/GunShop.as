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
			var alias:String;			
			var weapon:Object;
			
			for each (alias in DataSources.instance.getList("guns")) 
			{
				var g:GunData = new GunData();
				weapon = DataSources.instance.getReference(alias);
				
				g.ammo_max = g.ammo_current = weapon.ammo_max;
				g.dispersion = weapon.dispersion;
				g.fragments = weapon.fragments;
				g.mode = weapon.mode;
				g.rate = weapon.rate;
				g.reload_time = weapon.reload_time;
				g.damage_min = weapon.damage_min;
				g.damage_max = weapon.damage_max;	
				g.price = weapon.price;
				
				g.alias = alias;
				g.type = WeaponData.TYPE_GUN;
				g.bought = true; //TEMP TODO
				
				list.push(g);
			}
			
			for each (alias in DataSources.instance.getList("tools")) 
			{
				var t:ToolData = new ToolData();
				weapon = DataSources.instance.getReference(alias);
				
				t.z_dmg = weapon.z_dmg;
				t.t_dmg = weapon.t_dmg;
				t.inc = weapon.inc;
				
				t.alias = alias;
				t.type = WeaponData.TYPE_TOOL;
				t.bought = true; //TEMP TODO
				
				list.push(t);
			}
			
			
			
				
			
			
			
		}
		
	}

}