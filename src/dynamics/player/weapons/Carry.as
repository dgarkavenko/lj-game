package dynamics.player.weapons 
{
	import dynamics.player.Hands;
	import framework.input.Controls;
	/**
	 * ...
	 * @author DG
	 */
	public class Carry extends Hands
	{
		
		public function Carry() 
		{
			
			weaponType = WeaponData.TYPE_MISC;
		}
		
		override public function tick():void {
			
			if (mouse.justPressed()) {
				carrier.drop(true);
			}
			
		}	
		
	}

}