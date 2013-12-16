package framework.screens 
{
	import flash.display.Sprite;
	import framework.FormatedTextField;
	/**
	 * ...
	 * @author DG
	 */
	public class LoadingScreen extends BaseScreen
	{
		
		public function LoadingScreen() 
		{
			var bg:Sprite = new Sprite();
			with (bg) {
			
				graphics.beginFill(0x171729);
				graphics.drawRect(0, 0, Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT);
				graphics.endFill();
			}
			
			addChild(bg);		
			
			var loading:FormatedTextField = new FormatedTextField(12, 0xffffff);	
			addChild(loading);
			loading.text = "loading...";
			loading.x = Game.SCREEN_HALF_WIDTH - loading.textWidth / 2;
			loading.y = 200;
		}
		
	}

}