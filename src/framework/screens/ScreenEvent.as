package framework.screens {
import flash.events.Event;

//import Screens.BaseScreen;

/**
 * ...
 * @author JuzTosS
 */
public class ScreenEvent extends Event {
	static public const SHOW_COMPLETE:String = "showComplete";
	static public const HIDE_COMPLETE:String = "hideComplete";
	static public const NEED_SCREEN:String = "needScreen";
	public var screenClass:Class;

	public function ScreenEvent(_type:String, _screenClass:Class = null) {
		super(_type, false, false);
		screenClass = _screenClass;
	}

}

}