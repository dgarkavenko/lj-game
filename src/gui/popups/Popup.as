package gui.popups 
{
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import framework.screens.GameScreen;
	/**
	 * ...
	 * @author DG
	 */
	public class Popup extends Sprite
	{
		public var require_pause:Boolean = true;		
		
		public static const D:int = 10;
		public static const LEFT:int = D;
		public static const RIGHT:int = Game.SCREEN_WIDTH - D;
		public static const TOP:int = D;
		public static const BOTTOM:int = Game.SCREEN_HEIGHT - D;
		
		public function Popup() 
		{			
			//addEventListener(MouseEvent.CLICK, hide);
		}
		
		public function hide(e:* = null):void 
		{
			animation_OUT();
			
		}
		
		public function build(container:MovieClip, params:Object = null):void 
		{
			container.addChild(this);
			animation_IN();
		}
		
		public function destory(container:MovieClip):void 
		{
			container.removeChild(this);
		}
		
		protected function animation_IN():void 
		{
			y = -Game.SCREEN_HEIGHT;
			TweenLite.to(this, 0.4, {y:0} );
		}
		
		protected function animation_OUT():void 
		{
			//Начинаем удалять сверху
			TweenLite.to(this, 0.4, {y: -Game.SCREEN_HEIGHT, onComplete:GameScreen.POP.hide} );
		}
		
		
		
		
	}

}