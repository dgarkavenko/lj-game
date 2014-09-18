package framework.screens 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;
	import framework.FormatedTextField;
	import framework.ScreenManager;
	import gamedata.DataSources;
	/**
	 * ...
	 * @author DG
	 */
	public class DayScreen extends BaseScreen
	{
		
		
		
	
		private var dayResultField:FormatedTextField;
		private var progress:FormatedTextField;
	
		public function DayScreen() 
		{
			var bg:Sprite = new Sprite();
			with (bg) {
			
				graphics.beginFill(0x171729);
				graphics.drawRect(0, 0, Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT);
				graphics.endFill();
			}
			
			addChild(bg);		
			
			dayResultField = new FormatedTextField(21, 0xffffff);			
			dayResultField.x = 49;
			dayResultField.y = 50;
			
			progress = new FormatedTextField(36, 0xffffff);
			progress.y = 330;
			
			addChild(progress);			
			addChild(dayResultField);
			
		}
		
		override public function init(...args):void {

			trace(args);
			
			
			if (args.length > 0 && args[0] == 512) {
				dayResultField.text = "Day " + (args[1][0] - 1);
				setTimeout(function():void {					
					TweenLite.to(dayResultField, 0.2, { scaleX:1.1, scaleY:1.1, onComplete:scaleBack, onCompleteParams:[args[1][0]], ease:Cubic.easeIn});
				},600);
				
				setTimeout(function():void{ScreenManager.inst.showScreen(GameScreen, args)}, 2000);		
			}else {
				setTimeout(function():void{ScreenManager.inst.showScreen(GameScreen, args)}, 1000);		
			}		
		}
		
		private function scaleBack(a:int):void {
			dayResultField.text = "Day " + (a);
			TweenLite.to(dayResultField, 0.2, { scaleX:1, scaleY:1 } );			
			
		}
		
		
		
	
		
		
		
		
	}

}