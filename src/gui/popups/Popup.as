package gui.popups 
{
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import framework.FormatedTextField;
	import framework.screens.GameScreen;
	import gameplay.contracts.BaseContract;
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
			Mouse.hide();
			animation_OUT();
			
		}
		
		protected function AddTitle(container:MovieClip, string:String, xx:int = 0, yy:int = 0):void 
		{
			var title_tf:FormatedTextField = new FormatedTextField(30);
			title_tf.text = string; 
			
			title_tf.y = 30 + yy; 
			title_tf.x = 20 + xx;
			title_tf.width = 400;
			container.addChild(title_tf);
		}
		
		protected function AddCloseButton(container:MovieClip, X:int = 500, Y:int = 30):void {
			var close_tf:FormatedTextField = new FormatedTextField();
			close_tf.text = "[x]"; close_tf.x = X; close_tf.y = Y;
			container.addChild(close_tf);
			close_tf.addEventListener(MouseEvent.CLICK, hide);
		}
		
		public function build(container:MovieClip, params:Object = null):void 
		{			
			Mouse.show();
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
			TweenLite.to(this, 0.4, {y: -Game.SCREEN_HEIGHT, onComplete:GameScreen.POP.hide, onCompleteParams:[this]} );
		}
		
		
		
		
	}

}