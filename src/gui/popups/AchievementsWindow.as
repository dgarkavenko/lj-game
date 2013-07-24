package gui.popups 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author DG
	 */
	public class AchievementsWindow extends Popup
	{
		public function AchievementsWindow() 
		{
			var temp_mc:MovieClip = new MovieClip();
			temp_mc.graphics.beginFill(0x333333, 1);
			temp_mc.graphics.drawRoundRect(100, 100, Game.SCREEN_WIDTH - 200, Game.SCREEN_HEIGHT - 200, 10, 10);
			temp_mc.graphics.endFill();			
			addChild(temp_mc);
		}
		
	}

}