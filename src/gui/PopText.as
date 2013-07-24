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
		private static var container:Sprite = GameWorld.container.layer0;
		
		public static function at(text:String, x:int, y:int, color:uint):void {
			
			var pop:FormatedTextField = cache.getInstance() as FormatedTextField;
			pop.textColor = color;
			pop.text = text;
			pop.alpha = 1;
			
			
			pop.x = x - pop.textWidth/2;
			pop.y = y;
			
			container.addChild(pop);
			
			TweenLite.to(pop, 1.5, { y: pop.y - 75, onComplete:fade, onCompleteParams:[pop], ease:Cubic.easeOut } );
			
			
		}
		
		public static function fade(t:FormatedTextField):void {
			TweenLite.to(t, 1, {alpha:0, onComplete:destory, onCompleteParams:[t]} );
		}
		
		
		public static function destory(t:FormatedTextField):void {
			container.removeChild(t);
			cache.setInstance(t);
		}
		
	}

}