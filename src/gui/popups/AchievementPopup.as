package gui.popups 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import framework.FormatedTextField;
	import framework.screens.GameScreen;
	/**
	 * ...
	 * @author DG
	 */
	public class AchievementPopup extends Popup
	{
		private var tf:FormatedTextField;
		private var temp_ico:MovieClip;
		
		public function AchievementPopup(alias:String = "") 
		{
			
			require_pause = false;
			
			var temp_mc:MovieClip = new MovieClip();
			temp_mc.graphics.beginFill(0x333333, 1);
			temp_mc.graphics.drawRect(0, 0, 240, 80);
			temp_mc.graphics.endFill();			
			addChild(temp_mc);
			
			temp_ico = new MovieClip();
			temp_ico.graphics.beginFill(0xAAAAAA, 1);
			temp_ico.graphics.drawRect(10, 10, 60, 60);
			temp_ico.graphics.endFill();
			addChild(temp_ico);
			
			tf = new FormatedTextField(10);				
			tf.width = 150;
			tf.height = 60;
			
			
			tf.x = 80;
			tf.y = 10;
			
			temp_mc.addChild(tf);
			
		}
		
		override public function build(container:MovieClip, params:Object = null):void {
			
			if (params == null) return;
			
			super.build(container, params);
			
			tf.text = "You did:" + params.a;
			setTimeout(hide, 3300);
		}
		
		override protected function animation_IN():void 
		{
			x = (Game.SCREEN_WIDTH - width) / 2;
			y = -height;
			TweenLite.to(this, 0.4, {y:10, ease:Cubic.easeOut} );
		}
		
		override protected function animation_OUT():void 
		{
			//Начинаем удалять сверху
			TweenLite.to(this, 0.4, {y: -height, onComplete:GameScreen.POP.hide, ease:Cubic.easeIn} );
		}
		
	}

}