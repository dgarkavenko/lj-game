package framework.screens {
	import flash.display.MovieClip;
	import flash.events.Event;
	import framework.input.Controls;
	import framework.ScreenManager;
	import framework.SharedObjectShell;
	import gui.HUDClass;
	import gui.PopupManager;


	/**
	 * ...
	 * @author DG
	 */
	public class GameScreen extends BaseScreen {

		
		public static var NEW_GAME:uint = 0;
		public static var CONTINUE_GAME:uint = 1;
		public static var RESTART_GAME:uint = 2;
		
		public var WORLD:GameWorld;
		public static var HUD:HUDClass;
		public static var POP:PopupManager;
		
	
		

		public function GameScreen() {			
			
			WORLD = new GameWorld();			
			HUD = new HUDClass();			
			POP = new PopupManager(HUD);		
			
			addChild(WORLD);			
			addChild(HUD);				
		}
		
		public function world_simulation_ON():void {
			//Запустить все таймеры
			
			Game.updateFunction = WORLD.tick;
			
			
		}
		
		/**
		 * Поставить мир на паузу.
		 */
		public function world_simulation_OFF():void {
			//Заморозить все таймеры
			Game.updateFunction = Game.EMPTY_FUNCTION;
		}
	
		override public function init(...args):void {	
			
			if (args.length > 0) {
				if (args[0] == RESTART_GAME) {
					WORLD.softReset();
					WORLD.initializeNewGame();		
					trace("restarting");
				}
			}					
		}
	
		
		override protected function onReady():void {
			world_simulation_ON();
		}
		
		override protected function onStartHiding():void {
			world_simulation_OFF();
		}
		
		override protected function onStartShowing():void {	
			
		}
	
	
	}

}