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
	import gameplay.contracts.ContractHandler;
	import gameplay.SkillList;
	import gui.ButtonHandler;
	import gui.popups.shop.PurchaseButton;
	import ui.Shop_mc;
	import utils.GlobalEvents;
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
		private var buy_button:ButtonHandler;
		private var current_obj:Object;
		
		
		public var slots:Array = ["pistol","uzi","revolver","chainsaw","axe_double","axe_rusty","axe_fire","assault","barret","spas","shotgun"];
		
		
		
		public function Shop() 
		{
			shop = new Shop_mc();			
			addChild(shop);
			shop.x = 110;
			shop.y = 45;
			
			shop.dsc.mouseEnabled = shop.title.mouseEnabled = false;
			
			selectMatrix = [];
			selectMatrix = selectMatrix.concat([1, 0.3, 0.2, 0, 0]); // red
            selectMatrix = selectMatrix.concat([1, 0.3, 0.2, 0, 0]); // green
            selectMatrix = selectMatrix.concat([0, 0, 0, 0, 0]); // blue
            selectMatrix = selectMatrix.concat([0, 0, 0, 1, 0]); // alpha
			
			
			buy_button = new ButtonHandler(shop.buy_button);
			buy_button.mouseOutAction = buybuttonmouseout;
			buy_button.mouseOverAction = buybuttonmouseover;
			buy_button.mouseClickAction = buttonclick;
			buy_button.mouseDownAction = buybuttondown;
			
			
		}
		
		private function buybuttonmouseout(e:MouseEvent):void 
		{			
			Controls.mouse.force_track();
		}
		
		private function buttonclick(e:MouseEvent):void 
		{
			if (GameWorld.lumberjack.hasGunOrTool(current_alais) || current_price > GameWorld.lumberjack.cash) return;
			
			if (current_alais != "") {
				GameWorld.lumberjack.cash -= current_price;
				GameWorld.lumberjack.purchased(current_alais);
				shop[current_alais].label.visible = false;
			}
			
			if (GameWorld.lumberjack.hasGunOrTool(current_alais)) {
				buy_button.text = "Equipped";
				shop.buy_button.bax.visible = false;
				
			}else {
				buy_button.text = getCurrentPriceString();
				shop.buy_button.bax.visible = true;
			}
		}
		
		private function buybuttondown(e:MouseEvent):void 
		{
			if (GameWorld.lumberjack.hasGunOrTool(current_alais) || current_price > GameWorld.lumberjack.cash) return;			
			
		}
		
		private function buybuttonmouseover(e:MouseEvent):void 
		{
			Controls.mouse.force_no_track();
			if (GameWorld.lumberjack.hasGunOrTool(current_alais)) return;
			
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
			current_obj = DataSources.instance.getReference(current_alais);
			shop.title.text = current_obj.title;
			shop.dsc.text = current_obj.dsc;
			
			if (GameWorld.lumberjack.hasGunOrTool(current_alais)) {
				
				shop.buy_button.bax.visible = false;				
				buy_button.text = "Equipped";
				
				
			}else {
				current_price = current_obj.price;		
				discounts();
				
				if (current_price > GameWorld.lumberjack.cash) {
					shop.dsc.text = "Let's discuss this when you have enough money";
				}
				
				shop.buy_button.bax.visible = true;				
				buy_button.text = getCurrentPriceString();
			}			
			
			
			
			var bg:MovieClip = shop[current_alais].bg;		
			bg.filters = [new ColorMatrixFilter(selectMatrix)];
		}
		
	
		
		private function discounts():void 
		{
			if (SkillList.isLearned(SkillList.GENTELMAN)) current_price *= .9;
			//50% discount
			if (ContractHandler.isCurrent(ContractHandler.DANGER_TO_GO_ALONE)) current_price *= .5;
		}
		
		private function getCurrentPriceString():String 
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
			TweenLite.to(this, 0.4, {y: -height, onComplete:GameScreen.POP.hide, onCompleteParams:[this], ease:Cubic.easeIn} );
		}
		
		override public function hide(e:* = null):void {
			Mouse.hide();	
			super.hide();
			buy_button.dontlisten();

		}
		
		override public function build(container:MovieClip, params:Object = null):void 
		{
			Mouse.show();		
			super.build(container, params);
			buy_button.listen();

			
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