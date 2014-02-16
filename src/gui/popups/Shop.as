package gui.popups 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.ui.Mouse;
	import framework.FormatedTextField;
	import framework.input.Controls;
	import framework.screens.GameScreen;
	import gamedata.DataSources;
	import gui.popups.shop.PurchaseButton;
	import ui.Shop_mc;
	/**
	 * ...
	 * @author DG
	 */
	public class Shop extends Popup
	{
		private var shop:Shop_mc;
		private var selectMatrix:Array;
		
		private var current_price:int;
		private var current_alais:String;
		
		
		public var slots:Array = ["pistol","uzi","revolver","chainsaw","axe_double","axe_rusty","axe_fire","assault","barret","chainsaw","spas","shotgun"];
		
		public function Shop() 
		{
			shop = new Shop_mc();			
			addChild(shop);
			shop.x = 110;
			shop.y = 45;
			
			selectMatrix = [];
			selectMatrix = selectMatrix.concat([1, 0.3, 0.2, 0, 0]); // red
            selectMatrix = selectMatrix.concat([1, 0.3, 0.2, 0, 0]); // green
            selectMatrix = selectMatrix.concat([0, 0, 0, 0, 0]); // blue
            selectMatrix = selectMatrix.concat([0, 0, 0, 1, 0]); // alpha
			
			shop.buy_button.stop();
			shop.buy_button.buttonMode = true;
			shop.buy_button.useHandCursor = true;
			shop.buy_button.mouseChildren = false;
			shop.buy_button.addEventListener(MouseEvent.MOUSE_OVER, buybuttonmouseover);
			shop.buy_button.addEventListener(MouseEvent.MOUSE_OUT, buybuttonmouseout);
			shop.buy_button.addEventListener(MouseEvent.CLICK, click);
			shop.buy_button.addEventListener(MouseEvent.MOUSE_DOWN, buybuttondown);
			
			
			/************
			 * 
			 * 
			 * 
			 *  	SUBTRUCT MONEY
			 * 		SHOW NOT ENOUGH
			 * 		SALE AND DISCOUNTS
			 * 		OTHER SHOP ASSETS
			 * 		PRICES AND WEAPON DSC, TITLES
			 * 		CURSOR OVER TEXT
			 * 		MONEY BAR INTERFACE
			 * 		CLOSE SHOP AFTER LEAVIG A LOCATION
			 * 
			 * 
			 * */
			
		}
		
		private function buybuttonmouseout(e:MouseEvent):void 
		{
			shop.buy_button.gotoAndStop(1);
			Controls.mouse.force_track();
		}
		
		private function click(e:MouseEvent):void 
		{
			
			shop.buy_button.gotoAndStop(1);
			
			if (current_alais != "") {
				GameWorld.lumberjack.purchased(current_alais);
			}
			
			if (GameWorld.lumberjack.hasGunOrTool(current_alais)) {
				shop.buy_button.price.text = "Equipped";
				shop.buy_button.bax.visible = false;
				
			}else {
				shop.buy_button.price.text = getCurrentPrice();
				shop.buy_button.bax.visible = true;
			}
			
			
			
		}
		
		private function buybuttondown(e:MouseEvent):void 
		{
			if (GameWorld.lumberjack.hasGunOrTool(current_alais)) return;
			shop.buy_button.gotoAndStop(3);
			shop.buy_button.price.text = getCurrentPrice();
		}
		
		private function buybuttonmouseover(e:MouseEvent):void 
		{
			Controls.mouse.force_no_track();
			if (GameWorld.lumberjack.hasGunOrTool(current_alais)) return;
			shop.buy_button.gotoAndStop(2);
		}
		
		private function out(e:MouseEvent):void 
		{
			Controls.mouse.force_track();
		}
		
		private function over(e:MouseEvent):void 
		{
			Controls.mouse.force_no_track();
		}
		
		private function OnFocus(e:MouseEvent):void 
		{
			
			for each (var item:String in  slots) 
			{				
				shop[item].bg.filters = [];
			}
			
			current_alais = e.currentTarget.alias;
			shop.title.text = current_alais;
			
			if (GameWorld.lumberjack.hasGunOrTool(current_alais)) {
				shop.buy_button.price.text = "Equipped";
				shop.buy_button.bax.visible = false;
			}else {
				current_price = DataSources.instance.getReference(current_alais).price;			
				shop.buy_button.price.text = getCurrentPrice();
				shop.buy_button.bax.visible = true;
			}
			
			
			
			
			var bg:MovieClip = shop[current_alais].bg;		
			bg.filters = [new ColorMatrixFilter(selectMatrix)];
		}
		
		private function getCurrentPrice():String 
		{
			var price:String = current_price.toString();
			if (price.length > 3) {
				var index:int = price.length - 3;
				price = price.slice(0, index) + "," + price.slice(index);
			}			
			return price;
			
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
			
			var btn:MovieClip = new MovieClip();
			
			for each (var a:String in slots) 
			{
				if (a in shop) {
					btn = shop[a];
					btn.alias = a;
					btn.mouseChildren = false;
					btn.buttonMode = true;
					btn.useHandCursor = true;
					btn.addEventListener(MouseEvent.CLICK, OnFocus);
					btn.addEventListener(MouseEvent.MOUSE_OVER, over);
					btn.addEventListener(MouseEvent.MOUSE_OUT, out);
					if (GameWorld.lumberjack.hasGunOrTool(a)) {
						btn.label.visible = false;
					}
					
				}
			}
		}
		
	}

}