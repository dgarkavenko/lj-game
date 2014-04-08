package framework.screens 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.ui.Mouse;
	import flash.utils.setTimeout;
	import framework.FormatedTextField;	
	import framework.ScreenManager;
	import gamedata.DataSources;
	/**
	 * ...
	 * @author DG
	 */
	public class GameOverScreen extends BaseScreen
	{
		private var stats:FormatedTextField;
		
		
		public function GameOverScreen() 
		{
			
			var bg:Sprite = new Sprite();
			with (bg) {			
				graphics.beginFill(0x171729);
				graphics.drawRect(0, 0, Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT);
				graphics.endFill();
			}
			
			addChild(bg);		
			
			stats = new FormatedTextField(21, 0xffffff);			
			stats.x = 49;
			stats.y = 50;
			addChild(stats);
			
			
			
			
		}
		
		override public function init(...args):void {

			Mouse.show();
			
			stats.alpha = 1;
			stats.scaleX = stats.scaleY = 1;
			
			var msg:String = "No time to explain, but you kinda failed ("+ args[0] +")"; 
			
			
			stats.text = msg;
			stats.width = Game.SCREEN_WIDTH * 2 / 3;
			
			TweenLite.to(stats, 5, { scaleX:1.1, scaleY:1.1, onComplete:alphaOff} );
			//TweenLite.to(stats, 0.1, { alpha:0, delay:5 } );
			
			
			
			
			//TODO move to GameScreen					
			//setTimeout(function():void{ScreenManager.inst.showScreen(MenuScreen, GameScreen.RESTART_GAME)}, 6000);
		}
		
		public function alphaOff():void {
			stats.alpha = 0;
		}
	}

}