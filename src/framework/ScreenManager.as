package framework {



import flash.display.Sprite;
import flash.utils.Dictionary;
import framework.screens.BaseScreen;
import framework.screens.ScreenEvent;

/**
 * ...
 * @author JuzTosS
 */
public class ScreenManager extends Sprite {

	private static var _inst:ScreenManager;

	private var _screens:Dictionary;
	private var _currentScreen:BaseScreen;
	private var _newScreen:BaseScreen;

	public function ScreenManager() {
		init();
	}

	protected function init():void {
		_screens = new Dictionary();
	}

	public function registerScreen(screen:BaseScreen):void {
		_screens[(screen as Object).constructor] = screen;
		screen.addEventListener(ScreenEvent.NEED_SCREEN, needScreenHandler);
	}

	private function needScreenHandler(e:ScreenEvent):void {
		showScreen(e.screenClass);
	}

	public function getScreen(screenClass:Class):BaseScreen {
		return _screens[screenClass];
	}

	public function showScreen(screenClass:Class, ...args):void {	
		
		_newScreen = getScreen(screenClass);	
		_newScreen.init.apply(_newScreen, args);
		if (_currentScreen) {
			_currentScreen.addEventListener(ScreenEvent.HIDE_COMPLETE, hideCompleteHandler);
			_currentScreen.hide();
		} else {
			hideCompleteHandler(new ScreenEvent(""));
		}
	}

	private function hideCompleteHandler(e:ScreenEvent):void {
		if (_currentScreen) {
			_currentScreen.removeEventListener(ScreenEvent.HIDE_COMPLETE, hideCompleteHandler);
			removeChild(_currentScreen);
		}
		addChild(_newScreen);
		_newScreen.show();
		_currentScreen = _newScreen;
	}

	public static function get inst():ScreenManager {
		if (_inst)
			return _inst;
		else
			return _inst = new ScreenManager;
	}

}

}