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
		
		public const GUN:uint = 0;
		public const AXE:uint = 1;
		public const SPECIAL:uint = 2;
		
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
			var type:uint = uint(_xmlData[name].type);
			var data:WeaponData;
			
			trace(type);
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