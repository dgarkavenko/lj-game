package gui 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import framework.FormatedTextField;
	import utils.FTFCache;
	import utils.SimpleCache;
	/**
	 * ...
	 * @author DG
	 */
	public class PopText 
	{
		
		public static var DEFAULT_COLOR:uint = 0x00ff00;		
		private static  var cache:FTFCache = new FTFCache(FormatedTextField, 3, 14);
		private static var container:Sprite = GameWorld.container;
		
		public static function at(text:String, x:int, y:int, color:uint, asc:int = 75, time:Number = 1.5):FormatedTextField {
			
			var pop:FormatedTextField = cache.getInstance() as FormatedTextField;
			pop.textColor = color;
			pop.text = text;
			pop.alpha = 1;
			pop.scaleX = pop.scaleY = 1;			
			
			
			pop.x = x - pop.textWidth/2;
			pop.y = y;
			
			pop.width = pop.textWidth + 20;
			
			container.addChild(pop);
			
			TweenLite.to(pop, time, { y: pop.y - asc, onComplete:fade, onCompleteParams:[pop], ease:Cubic.easeOut} );
			return pop;
			
		}
		
		public static function fade(t:FormatedTextField):void {
			TweenLite.to(t, 0.5, {alpha:0, scaleX:1.2, scaleY:1.2, onComplete:destory, onCompleteParams:[t]} );
		}
		
		
		public static function destory(t:FormatedTextField):void {
			container.removeChild(t);
			cache.setInstance(t);
		}
		
	}

}