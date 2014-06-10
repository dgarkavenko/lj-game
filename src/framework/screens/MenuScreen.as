/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 19.01.12
 * Time: 23:08
 * To change this template use File | Settings | File Templates.
 */
package framework.screens {

import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import framework.FormatedTextField;
import framework.input.Controls;
import framework.misc.PixelButton;
import framework.ScreenManager;
import framework.SharedObjectShell;
import menu.intro;
import visual.Shore_mc;


public class MenuScreen extends BaseScreen {
	
	private var option:uint = GameScreen.NEW_GAME;
	//private var intro_scene:intro = new intro();
	
	public function MenuScreen() {
		
		
		var bg:Sprite = new Sprite();
		with (bg) {
			
			graphics.beginFill(0x010429);
			graphics.drawRect(0, 0, Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT);
			graphics.endFill();
		}
		
		addChild(bg);	
		
		
		//addChild(intro_scene);
		//intro_scene.addEventListener("end", onIntroEnd);
		onIntroEnd(null);
	}
	
	private function onIntroEnd(e:Event):void 
	{
		createStartGameButton();
	}
	
	override public function init(...args):void {
		if (args.length > 0) option = args[0];
	}

	private function createStartGameButton():void {
		
		var title:FormatedTextField = new FormatedTextField(30);	
		title.width = Game.SCREEN_WIDTH / 2;
		title.height = Game.SCREEN_HEIGHT;
		//title.text = "SHIPWRECKED LUMBERJACK, THE GAME";
		title.x = Game.SCREEN_HALF_WIDTH - title.textWidth / 2 + 5;
		title.y = 60;
		

		addChild(title);
		
		var newgame:PixelButton = new PixelButton("New game");	
		newgame.addEventListener(MouseEvent.CLICK, newGame);
		newgame.x = Game.SCREEN_HALF_WIDTH - newgame.width * .5;
		newgame.y = 200;
		addChild(newgame);
		
		/*if (SharedObjectShell.instance.has()) {
			var continuegame:PixelButton = new PixelButton("Continue");
			continuegame.addEventListener(MouseEvent.CLICK, continueGame);
			continuegame.x  = Game.SCREEN_HALF_WIDTH - newgame.width * .5;
			continuegame.y = 250;
			addChild(continuegame);
		}*/
		
		
		
	}
	
	override protected function onReady():void {
		Game.updateFunction = function():void {
			if (Controls.keys.justPressed("ESCAPE")) ScreenManager.inst.showScreen(GameScreen, false);
		}
	}
	
	private function continueGame(e:MouseEvent):void 
	{		
		ScreenManager.inst.showScreen(DayScreen);		
		
	}

	private function newGame(e:MouseEvent):void {
		
		SharedObjectShell.instance.clear();
		
				
		ScreenManager.inst.showScreen(DayScreen, option);
	}

}
}
