package dynamics.player.weapons 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author DG
	 */
	public class GunShop 
	{
		private var _xmlLoader:URLLoader;
		private var _xmlData:XML;
		
		private var _weapon:XML;
		
		public var list:Array;
		
		public var pistol:GunData = new GunData();
		public var shotgun:GunData = new GunData();
		public var assault:GunData = new GunData();
		public var axe:ToolData = new ToolData();
		public var axe_double:ToolData = new ToolData();
		public var axe_fire:ToolData = new ToolData();
	
		public function loadXML(fileName:String):void {
			
			_xmlLoader = new URLLoader();
			_xmlLoader.addEventListener(Event.COMPLETE, xmlLoadComplete);
			_xmlLoader.load(new URLRequest(fileName));
			
		}
		
		private function xmlLoadComplete(e:Event):void 
		{
			_xmlData = new XML(e.target.data);
			_xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete);
			_xmlLoader = null;
			
			/*for each ( var title:String in ["pistol", "shotgun", "assault", "axe_fire", "axe_double", "axe"] ) 
			{*/
				list.push(getDataFromXML("pistol"));
			//}
			
			
			
		}
		
		private function getDataFromXML(name:String):WeaponData {
			
			var weapon:XML = _xmlData[name];
			var type:uint = uint(weapon.type);
			
			var data:WeaponData;
			
			if (type == WeaponData.TYPE_GUN) {				
				data = new GunData();
				
				data.ammo_max = pistol.ammo_current = int(weapon.ammo_max);
				data.dispersion = Number(weapon.dispersion);
				data.fragments = int(weapon.fragments);
				data.mode = uint(weapon.mode);
				data.rate = int(weapon.rate);
				data.reload_time = int(weapon.reload_time);
				data.damage_min = int(weapon.damage_min);
				data.damage_max = int(weapon.damage_max);			
				
			}else if (type == WeaponData.TYPE_TOOL) {
				data = new ToolData();
				data.z_dmg = Number(weapon.z_dmg);
				data.t_dmg = Number(weapon.t_dmg);
				data.inc = Number(weapon.inc);
			}else{
				data = new GunData();
			}
			
			data.price = int(weapon.price);
			data.alias = weapon.alias;
			data.type = type;			
			return data;
		}
		
		public function GunShop() 
		{
			
			loadXML("weapons.xml");
			
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