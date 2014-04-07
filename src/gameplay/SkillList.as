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
		public static var DOUBLE_JUMP:uint = 2; 	//Этот навык говорит сам за себя. Беспрецедентная возможность посмеяться в лицо гравитации. 
		public static var SLICK:uint = 4; 		//zombie dont stop u, move faster //Устал от тесноты? Ищещшт свободы и скорости? SLICK позволит тебе безпрепятственно пробегать сквозь орды врагов.
		
		public static var NINJA:uint = 8; 		//GIVES KUVIROK to dodge attacks, jump over heads						
		public static var CARRY:uint = 16; //axe hits knock back zombies, faster cutting trees
			public static var PATH_OF_AXE:uint = 32; //powerfull strike with axe charged and chopping faster
		
			public static var NEGOTIATOR:uint = 64; //+10
		public static var GENTELMAN:uint = 128; //-10
		
		public static var SHORTY:uint = 256; // splash
		public static var AUTOGUNS:uint = 512; // no dispersion
		public static var AMMUNITION_WITHIN:uint = 1024; //while reloading u could shoot but costs hp
		public static var QUICK_FINGERS:uint = 2048; //no cd between shots
		
		public static var MORE_PERKS:uint = 4096; 
				public static var LUMBERJACK_IN_A_NUTSHELL:uint = 8192; //armor + tree resistance
				public static var INFERNAL_CONTRACT:uint = 16384;
			
				public static var COORDINATION:uint = 32768;	//Replace
			public static var PARTYSOLDIER:uint = 65536;
				public static var QTE_RELOAD:uint = 65536 + 65536;
			public static var SADIST:uint = QTE_RELOAD + QTE_RELOAD;
		
		static public function get strings():Dictionary 
		{
			if (strings_ == null) {
				strings_ = new Dictionary();
				strings_[DOUBLE_JUMP] = {t:"Double jump", d:"This perk speaks for itself. It is an unprecedented possibility to laugh in gravity's face."};
				strings_[SLICK] = {t:"Slick", d:"Is it too tight here? Looking for freedom and speed? This perk will allow you easily run through hordes of enemies."};
				strings_[NINJA] = {t:"Ninja", d:"Gives you a coupon for a free ninjutsu class. We will teach you to do a battle roll to help you get out of any hot situation"};
				strings_[SHORTY] = {t:"Shorty", d:"Vietnam war taught you how to use a shotgun properly: shotgun rounds now have a splash effect."};
				strings_[AUTOGUNS] = {t:"Autoguns", d:"Iraqi war taught you how to use machine guns properly. You can now shoot with no recoil at all."};
				strings_[AMMUNITION_WITHIN] = {t:"Ammunition Within", d:"After you've signed a contract with the devil you can keep shooting using your health while reloading."};
				strings_[QUICK_FINGERS] = {t:"Quick Fingers", d:"While getting ready for filming in a western movie you gain the ability of shooting as fast as your trigger finger allows you."};
				strings_[MORE_PERKS] = {t:"More Perks", d:"DO not limit your options to just three perks! Limit yourself to four perks!"};
				strings_[BEAR_VITALITY] = {t:"Bear vitality", d:"You found the wasy to activate the genes of your most bearded ancestors, it will help you grow a gorgeous, long, fabulous beard - an object of envy for any lumberjack. By the way, those genes also increase your regeneration."};
				strings_[COORDINATION] = { t:"Coordination", d:"" };
				
				strings_[CARRY] = { t:"Carry", d:"Intensive military trainings taught you how to pack 2 times more explosives and med kits to carry with you." };
				strings_[PATH_OF_AXE] = {t:"Path of Axe", d:"Some time ago, bearded Canadian lumberjacks taught you this secret art. Now you are able to control a secret ancient power. Oh yes, you can also chop trees faster." };
				strings_[NEGOTIATOR] = { t:"Negotiator", d:"You can negotiate an extra 10% bonus for literally any contract deal." };
				strings_[GENTELMAN] = {t:"Gentelman", d:"Such gentleman like you was destined to get promo deals in stores. It's 10%, but still!"};
				strings_[PARTYSOLDER] = {t:"Party Soldier", d:"Endless night parties help your travel at night and be as accurate as during the day"};

				
				
				}
			
			return strings_;
		}
		
		
		
		static public function get learned():uint 
		{
			return learned_skills;
		}
	}

}