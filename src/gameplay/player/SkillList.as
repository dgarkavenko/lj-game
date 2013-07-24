package gameplay.player 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import gamedata.DataSources;
	
	/**
	 * ...
	 * @author DG
	 */
	public class SkillList extends EventDispatcher
	{
		
		
		
		public static var SKILL_UP_EVENT:String = "skillup";
		
		public static var price_m:Number;
		public static var reload_m:Number;
		public static var dispersion:Number;
		public static var speed_m:Number;
		public static var regen_a:int ;
		public static var exp_m:Number;
		public static var dmg_reduction:Number;
		
		public static var push_force:Number;
		public static var penetration:int = 1;
		
		private var list:Object = {
			
			0: { param : "price_m", s:0, d: [1, .95, .9, .85], title:"Haggler" }, //Shop.as
			1: { param : "reload_m", s:0, d: [1, .9, .8, .7], title:"Reloader" }, //Gun.as
			2: { param : "dispersion", s:0, d: [.05, .025, .0125, .005], title:"Sharpshooter" }, //Gun.as
			3: { param : "speed_m", s:0, d: [1, 1.15, 1.3], title:"Cardio" }, //Movement.as
			4: { param : "regen_a", s:0, d: [0, 1, 2], title:"Harding" }, //a for absolute // HP
			5: { param : "exp_m", s:0, d: [1, 1.10, 1.2, 1.3], title:"Educated" }, //m stands for multiple // XP
			6: { param : "dmg_reduction", s:0, d: [1, 0.75], title:"Bulletproof" } //HP
			
		}
		
		
		public function SkillList() 
		{
			for each (var skill:Object in list ) 
			{
				if (skill.s > 3) skill.s = 3;
				SkillList[skill.param] = skill.d[skill.s];
			}
		}
		
		public function load(data:Array):void 
		{
			for (var i:int = 0; i < data.length; i++) 
			{
				list[i].s = data[i];
				
				var skill:Object = list[i];
				if (skill.s > 3) skill.s = 3;
				SkillList[skill.param] = skill.d[skill.s];
			}
			
		}
		
		public function skill_up(i:int = 0):void {
			
			var skill:Object = list[i];
			//var skill_level:int = skill.s + 1;
			
			skill.s += 1;			
			SkillList[skill.param] = skill.d[skill.s];			
			DataSources.lumberkeeper.skills[i] = skill.s;		
			
			dispatchEvent(new Event(SKILL_UP_EVENT));
			//DataSources.lumberkeeper.save();
		}
		
		
		
		
		
	}

}