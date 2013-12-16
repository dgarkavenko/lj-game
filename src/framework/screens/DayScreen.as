package framework.screens 
{
	import com.greensock.easing.Bounce;
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
		
		
		
		private const DAY1:String = "Day 1\n\nYou survived a shipwreck and were cast away on the abandoned island. Your only chance to survive is passing ships that could spot the fire you made. You are the";
		
		private var dayResultField:FormatedTextField;
		private var v:FormatedTextField;
	
		
		
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
			addChild(dayResultField);
			
		}
		
		override public function init(...args):void {

			
			if (DataSources.lumberkeeper.day == 1) {
				dayResultField.width = Game.SCREEN_WIDTH - 98;
				dayResultField.height = Game.SCREEN_HEIGHT - 100;
				dayResultField.text = DAY1;				
				
				v = new FormatedTextField(33.5, 0xffffff);			
				v.x = 50;
				v.y = 220;
				v.width = 10000;
				v.height = 10000;
				v.text = "SHIPWRECKED LUMBERJACK"
				v.alpha = 0;
				addChild(v);
				
				TweenLite.to(v, 4, { alpha:1, ease:Bounce.easeInOut, delay: 5 } );
				
			}else {				
				gatherDayMessage();				
			}			
			
			setTimeout(function():void{ScreenManager.inst.showScreen(GameScreen, args)}, 1000);
		}
		
		private function gatherDayMessage():void 
		{
			dayResultField.text = "Day " + DataSources.lumberkeeper.day;			
			
			dayResultField.text += "\n\n";
			v.text = "";
			
			dayResultField.text += getDayResults();
			
			var tip:String = getTip();
			
			if (tip != "") {				
				dayResultField.text += "\n\nTip:\n\n";
				dayResultField.text += tip;
			}
		}
		
		private function getTip():String 
		{
			return "Try to keep fire brighter at night it's gonna increase your chance to be spotted.";
		}
		
		private function getDayResults():String 
		{
			return "Unfortunately your fire wasn’t big enough to attract passing ship";
		}
		
		
		
	}

}