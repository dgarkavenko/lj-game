package gameplay 
{
	import flash.utils.Dictionary;
	import utils.GlobalEvents;
	/**
	 * ...
	 * @author DG
	 */
	public class SkillList 
	{
		
		private static var strings_:Dictionary;
		
		public static var skills:Array = 	[	
		
											AMMUNITION_WITHIN, AUTOGUNS, DOUBLE_JUMP, 
											MORE_PERKS, NINJA, QUICK_FINGERS, 
											SHORTY, SLICK, BEAR_VITALITY, COORDINATION
											
											];

		
		private static var learned_skills:uint = 0;
		
		public static function isLearned(skill:uint):Boolean {
			return (learned_skills & skill) == skill;
		}
		
		public static function learn(skill:uint):void {
			learned_skills |= skill;
			$GLOBAL.dispatch(GlobalEvents.SKILLS, null);
			
		}
		
		
		public static var BEAR_VITALITY:uint = 1; //regen, beard started to grow
		public static var DOUBLE_JUMP:uint = 2; 
		public static var SLICK:uint = 4; 		//zombie dont stop u, move faster
		
		public static var NINJA:uint = 8; 		//chance to dodge attacks, jump over heads
			public static var MIGHTY_AXE:uint = 16; //axe hits knock back zombies, faster cutting trees
			public static var HADOUKEN:uint = 32; //powerfull strike with axe charged
		
			public static var NEGOTIATOR:uint = 64; //+10
			public static var GENTELMAN:uint = 128; //-10
		
		public static var SHORTY:uint = 256; // splash
		public static var AUTOGUNS:uint = 512; // no dispersion
		public static var AMMUNITION_WITHIN:uint = 1024; //while reloading u could shoot but costs hp
		public static var QUICK_FINGERS:uint = 2048; //no cd between shots
		
		public static var MORE_PERKS:uint = 4096; 
			public static var LUMBERJACK_IN_A_NUTSHELL:uint = 8192; //armor + tree resistance
			public static var INFERNAL_CONTRACT:uint = 16384;
			
		public static var COORDINATION:uint = 32768;
		
		static public function get strings():Dictionary 
		{
			if (strings_ == null) {
				strings_ = new Dictionary();
				strings_[DOUBLE_JUMP] = "Double jump";
				strings_[SLICK] = "Slick";
				strings_[NINJA] = "Ninja";
				strings_[SHORTY] = "Shorty";
				strings_[AUTOGUNS] = "Autoguns";
				strings_[AMMUNITION_WITHIN] = "Ammunition Within";
				strings_[QUICK_FINGERS] = "Quick Fingers";
				strings_[MORE_PERKS] = "More Perks";
				strings_[BEAR_VITALITY] = "Bear vitality";
				strings_[COORDINATION] = "Coordination";

			}
			
			return strings_;
		}
	}

}