package framework.screens {
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import framework.FormatedTextField;
	import framework.input.Controls;
	import framework.ScreenManager;
	import framework.SharedObjectShell;
	import gui.HUDClass;
	import gui.PopupManager;
	import intro.ceo;
	import intro.company;
	import visual.Chapter1;


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
		
		public static var WORLD_UPDATE_FUNCTION:Function;
		

		public function GameScreen() {			
			
			WORLD = new GameWorld();	
			WORLD_UPDATE_FUNCTION = WORLD.tick;
			HUD = new HUDClass();			
			POP = new PopupManager(HUD);		
			
			addChild(WORLD);
			addChild(HUD);
			
			//Intro();			
		}
		
		private var iceo:ceo;
		private var icompany:company;
		private var ichapter1:Chapter1;
		private var part:FormatedTextField;
		private var paying:FormatedTextField;
		
		
		private function Intro():void 
		{
			
			WORLD.scaleX = 1.5;
			WORLD.scaleY = 1.5;			
			WORLD.x = -300;
			WORLD.y = -200;			
			
			setTimeout(StartIntorSeq, 2750);	
			
		}
		
		private function StartIntorSeq():void {
			icompany = new company();
			addChild(icompany);		
			TweenLite.to(WORLD, 0.3, { delay:3, scaleX: 8, scaleY :8, x: -1200, y: -2450, onStart:HideCompanyLabels, onComplete:AddCeoLabeles} );
		}
		
		private function AddCeoLabeles():void {
			
			TweenLite.to(WORLD, 0.3, { delay:3, scaleX: 1, scaleY :1, x: 0, y: 0, onStart:HideCeoLabels} );			
			iceo = new ceo();
			addChild(iceo);			
		}
		
		private function HideCompanyLabels():void 
		{
			removeChild(icompany);
			icompany = null;
		}
		
		private function HideCeoLabels():void 
		{
			removeChild(iceo);			
			iceo = null;
			
			part = new FormatedTextField(28, 0x28283d, true);
			paying = new FormatedTextField(38, 0xffffff, true);
			WORLD.addChild(part);
			WORLD.addChild(paying);
			
			part.text = "Part One";
			
			paying.text = "PAYING THE DEBTS";
			paying.width = part.width = 640;
			
			
			//paying.x = part.x = Game.SCREEN_HALF_WIDTH;
			part.y = 40;
			paying.y = 80;
			
			TweenLite.to(part, 4, {scaleX:1.1, scaleY:1.1, x: (640 - 640* 1.1)/2, ease:Cubic.easeOut} );

			TweenLite.to(paying, 5, {scaleX:1.125, scaleY:1.125, x: (640 - 640* 1.125)/2, onComplete:HideChapter, ease:Cubic.easeOut} );
		}
		
		private function HideChapter():void 
		{
			TweenLite.to(paying, 1, { alpha:0 } );
			
			TweenLite.to(part, 1, { alpha:0, onComplete:function():void {
				WORLD.removeChild(part);
				WORLD.removeChild(paying);
				part = paying = null;
			}} );
		}
		
		
		
		
		
		
		public static function world_simulation_ON():void {
			//Запустить все таймеры
			
			Game.updateFunction = WORLD_UPDATE_FUNCTION;
			
			
		}
		
		/**
		 * Поставить мир на паузу.
		 */
		public static function world_simulation_OFF():void {
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