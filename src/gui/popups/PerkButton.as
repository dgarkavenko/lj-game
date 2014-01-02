package gui.popups 
{
	import framework.FormatedTextField;
	import gameplay.SkillList;
	/**
	 * ...
	 * @author DG
	 */
	public class PerkButton extends FormatedTextField
	{
		
		public var skill:uint;
		
		public function PerkButton(tx:String, skill_:uint) 
		{
			super(12, 0xffffff);
			width = 300;
			text = (SkillList.isLearned(skill_)) ? tx + " - learned" : tx;
			skill = skill_;			
		}
		
		
	}
		
	

}