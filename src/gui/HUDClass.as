package gui 
{
	import dynamics.interactions.IInteractive;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import gui.Bars.SimpleBar;
	import hud.Hud_mc;
	/**
	 * ...
	 * @author DG
	 */
	public class HUDClass extends Hud_mc
	{
		
		private var hp_regen:int = 0;
		
		
		public function HUDClass() 
		{
			
		}	
		
		public function update_hp(c:int, m:int ):void {
			hp_bar.slider.scaleX = c < 0 ? 0 : c / m;
			hp_tf.text = c + "/" + m;
			if (hp_regen > 0) hp_tf.text += " (+" + hp_regen + ")";
		}
		
		public function set regen(value:int):void 
		{
			hp_regen = value;
		}
		
	}

}