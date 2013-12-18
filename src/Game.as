package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.registerClassAlias;
	import flash.system.Security;
	import flash.text.TextFormat;
	import framework.input.Controls;
	import framework.ScreenManager;
	import framework.screens.BaseScreen;
	import framework.screens.DayScreen;
	import framework.screens.GameOverScreen;
	import framework.screens.GameScreen;
	import framework.screens.LoadingScreen;
	import framework.screens.MapScreen;
	import framework.screens.MenuScreen;
	import gamedata.DataSources;
	/**
	 * ...
	 * @author DG
	 */
	public class Game extends Sprite
	{
		
		Security.allowDomain("*.*");
		[Embed(systemFont="Nokia Cellphone FC", 
		fontName = "nokia", 
		mimeType = "application/x-font", 
		fontWeight="normal", 
		fontStyle="normal", 
		advancedAntiAliasing="true", 
		embedAsCFF="false")]
		private var embed_font_1:Class;	
		
		public static const SCREEN_WIDTH:int = 640;
		public static const SCREEN_HEIGHT:int = 400;
		public static const SCREEN_HALF_WIDTH:int = 320;
		public static const SCREEN_HALF_HEIGHT:int = 200;
		
		//UPDATE FUNCTION			
		public static const EMPTY_FUNCTION:Function = function():void { };
		public static var updateFunction:Function = EMPTY_FUNCTION;	
		
		
		public static var tick:Function = function():void {
			
		}
		
		public function Game() 
		{
			trace("v" + Version.Major  + "." + Version.Minor + "." + Version.Build );
			trace("@" + Version.Timestamp);			
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			
			if (e != null) removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//registerClassAlias("flash.geom.Point", Point);
			
			addChild(ScreenManager.inst);
			/*ScreenManager.inst.scaleX = 2;
			ScreenManager.inst.scaleY = 2;*/
			Controls.init(ScreenManager.inst);
			addEventListener(Event.ENTER_FRAME, tick);
			
			stage.stageFocusRect = false;
			
			ScreenManager.inst.registerScreen(new GameScreen());
			ScreenManager.inst.registerScreen(new MenuScreen());
			ScreenManager.inst.registerScreen(new DayScreen());
			ScreenManager.inst.registerScreen(new GameOverScreen());
			ScreenManager.inst.registerScreen(new LoadingScreen());
			ScreenManager.inst.registerScreen(new MapScreen());
			ScreenManager.inst.showScreen(MenuScreen);
			
		}
		
		private function tick(e:Event):void 
		{
			Controls.update();
			updateFunction();
		}
		
		/*public function clone(source:*):*
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return(myBA.readObject());
		}*/
		
	}

}