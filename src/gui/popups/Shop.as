package gui.popups 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import framework.FormatedTextField;
	import framework.screens.GameScreen;
	import gui.popups.shop.PurchaseButton;
	/**
	 * ...
	 * @author DG
	 */
	public class Shop extends Popup
	{
		
		public function Shop() 
		{
			var temp_mc:MovieClip = new MovieClip();
			temp_mc.graphics.beginFill(0x333333, 1);
			temp_mc.graphics.drawRoundRect(0, 20, Game.SCREEN_WIDTH - 40, Game.SCREEN_HEIGHT - 80, 30, 30);
			temp_mc.graphics.endFill();			
			addChild(temp_mc);
			
			var title_tf:FormatedTextField = new FormatedTextField(30);
			title_tf.text = "Shop"; title_tf.y = 30; title_tf.x = 20;
			temp_mc.addChild(title_tf);
			
			var close_tf:FormatedTextField = new FormatedTextField();
			close_tf.text = "[close]"; close_tf.x = 520; close_tf.y = 30;
			temp_mc.addChild(close_tf);
			
			var i:int = 0;
			var btn:PurchaseButton
			var item:String
			
			for each (item in ["pistol", "shotgun", "assault"]) 
			{
				btn = new PurchaseButton(item);
				addChild(btn);
				btn.y = 100;
				btn.x = 30 + i * 100;
				
				
				btn.addEventListener("temp", hide);				
				i++;
			}
			
			i = 0;
			
			for each (item in ["axe_rusty", "axe_fire", "axe_double"]) 
			{
				btn = new PurchaseButton(item, true);
				addChild(btn);
				btn.y = 140;
				btn.x = 40 + i * 100;
				
				
				btn.addEventListener("temp", hide);				
				i++;
			}
			
			
			
			close_tf.addEventListener(MouseEvent.CLICK, hide);
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
		
		override public function hide(e:* = null):void {
			Mouse.hide();	
			super.hide();				
		}
		
		override public function build(container:MovieClip, params:Object = null):void 
		{
			Mouse.show();		
			super.build(container, params);
		}
		
	}

}