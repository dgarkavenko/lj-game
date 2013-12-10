package gameplay.world 
{
	import com.greensock.core.SimpleTimeline;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import framework.ScreenManager;
	import framework.screens.DayScreen;
	import framework.screens.GameScreen;
	import gamedata.DataSources;
	import gui.Bars.SimpleBar;
	
	/**
	 * ...
	 * @author DG
	 */
	public class TimeManager extends EventDispatcher
	{
		
		public var time:int = 1;
		public var dayTimeChangeEvent:Event = new Event(DayTimeChange);
		
		public static const DayTimeChange:String = "DayTimeChange";		
		public static const DAY:int = 0;
		public static const NIGHT:int = 1;
		
		private const NCOLOR:String = "303050";	
		
		
		public static var duration:int = 60 * 30;
		
		private static var scale:int = 2;
		
		public var shade:Bitmap;
		public var ticksToChange:int = duration;
		public var daytime:int = DAY;
		
		private var shadeColor:uint = uint("0xff" + NCOLOR);
	
		private const fill:BitmapData = new BitmapData(Game.SCREEN_WIDTH / scale, Game.SCREEN_HEIGHT / scale, true, shadeColor);
		private var container:Sprite;
		
		public var bar:SimpleBar = new SimpleBar(200, 10, 0xffffff);
		
		
		private static var lightsToRender:Vector.<Light> = new Vector.<Light>();
		private var passes:int = 0;
		
		
		public var prepassComplete:Boolean = false;
		
		public var debug:Boolean = false;
		//public var debug:Boolean = true;
		
		
		public function getCurrentDay():int {
			
			return 1 + time / 2;
			
		}
		
		public function TimeManager(cont:Sprite) 
		{
			container = cont;
			
			shade = new Bitmap(fill);
			if (!debug) shade.alpha = 0;
			shade.scaleX = shade.scaleY = scale;
			shade.blendMode = BlendMode.MULTIPLY;
			
			//shade.blendMode = BlendMode.OVERLAY;
			
			bar.x = 500
			bar.y = 15;
			/*var bdate:BitmapData= 
			
			var a:int = 35;
			var b:int = 45;
			
			for (var i:int = 0; i < 10; i++) 
			{
				
				for (var k:int = 0; k < 10; k++) {
					if (k - i < 0) continue;
					
					//bdate.setPixel32(a + i, b + k - i, uint("0x" + (k * 27).toString(16) + "303050"));
					//bdate.setPixel32(a - i, b + k - i, uint("0x" + (k * 27).toString(16) + "303050"));
					bdate.setPixel32(a + i, b - k + i, uint("0x" + (10 + k * 26).toString(16) + NCOLOR));
					bdate.setPixel32(a - i, b - k + i, uint("0x" + (10 + k * 26).toString(16) + NCOLOR));
				}
				
				
			}
			
			
			shade = new Bitmap(bdate);
			shade.scaleX = shade.scaleY = 8;
			shade.blendMode = BlendMode.MULTIPLY;*/
		}
		
		public function tick():void {
			
			if (debug && daytime == DAY) {
				daytime = NIGHT;
			}
			
			ticksToChange--;
			if (ticksToChange <= 0) {
				change();
			}
			
			if (daytime == DAY ) bar.scale((duration - ticksToChange) / duration);
			else bar.scale(ticksToChange / duration);
			
			if (daytime == NIGHT) {				
				render();				
			}
		}
		
		private function change():void 
		{			
			ticksToChange = duration;			
			if (daytime == DAY) d2n();
			else n2d();
			
			time++;
			dispatchEvent(dayTimeChangeEvent);			
		}
		
		private function n2d():void {
			//shade.alp
			//ScreenManager.inst.showScreen(DayScreen);
			
			if (!debug) TweenLite.to(shade, 3, { alpha:0 } );
			daytime = DAY;
		}
		
		private function d2n():void {			
			TweenLite.to(shade, 3, { alpha:1 } );	
			daytime = NIGHT;
		}
		
		/**
		 * Returns amount of frames till change
		 * @return amount of frames
		 */
		public function getTimeRemaining():int {			
			return ticksToChange;	
		}
		
		public static function addLight(l:Light):void {
			lightsToRender.push(l);
		}	
		
		/**
		 * Fills night shade with color
		 */
		private function prepass():void{		
			
			shade.bitmapData.fillRect(new Rectangle(0, 0, shade.width, shade.height), shadeColor);
			prepassComplete = true;			
		}
		
		/**
		 * You should call it at the end of the frame.
		 */
		public function render():void {
			
			prepass();
			
			for each (var l:Light in lightsToRender) 
			{						
				pass(l);
			}
			
			lightsToRender.length = 0;			
			//shade.bitmapData.fillRect(new Rectangle(0, (Game.SCREEN_HEIGHT - 27) / scale, shade.width, shade.height), shadeColor);
			prepassComplete = false;
			passes = 0;
		}
		
		private function isOutOfScreen(relativeX:int, relativeY:int, light:Light):Boolean 
		{		
			if (relativeX > shade.width + light.width / 2 || relativeX < -light.width / 2 || relativeY > shade.height + light.height / 2 || relativeY < -light.height / 2) {
				return true;				
			}			
			return false
		}
		
		private function pass(l:Light):void 
		{
			
			var relativeX:int = (l.x + container.x) / scale;
			var relativeY:int = (l.y + container.y) / scale;
			
			if (isOutOfScreen(relativeX, relativeY, l)) return;
			
			
			var posMatrix:Matrix = new Matrix(1, 0, 0, 1, relativeX - l.width/2, relativeY - l.height/2);			
			
			//shade.bitmapData.draw(l.bitmap, posMatrix, null, BlendMode.ADD);		
			shade.bitmapData.draw(l.bitmap, posMatrix, null, BlendMode.SCREEN);				
		}
		
		
		
	}

}