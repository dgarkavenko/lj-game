package gui.popups 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import framework.screens.GameScreen;
	import gameplay.contracts.bills.Bill;
	import gui.ButtonHandler;
	import gui.PopText;
	import UI.bill_footer;
	import UI.bill_header;
	import UI.bill_item;
	/**
	 * ...
	 * @author DG
	 */
	public class BillPopup extends Popup
	{
		private var header:bill_header;
		private var footer:bill_footer;
		private var bill_items:Vector.<bill_item>
		
		private var pay_button:ButtonHandler;
		
		
		private var dx:int = 0;
		private var bills:Vector.<Bill>;
		
		private var current_index:int = -1;
		
		public function BillPopup() 
		{
			header = new bill_header();
			footer = new bill_footer();		
			footer.buy_button.stop();
			addChild(header);
			addChild(footer);
			
			pay_button = new ButtonHandler(footer.buy_button);
			pay_button.mouseClickAction = click;
			
			footer.title.mouseEnabled = footer.dsc.mouseEnabled = footer.title.mouseWheelEnabled = footer.dsc.mouseWheelEnabled = false;
		
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
			
		
			
			pay_button.dontlisten();
			
			for (var i:int = 0; i < bill_items.length; i++) 			
				removeChild(bill_items[i]);				
				
			bill_items.length = bills.length = 0;
			super.hide();				
		}
		
		override public function build(container:MovieClip, params:Object = null):void 
		{
			pay_button.listen();
			bills = params as Vector.<Bill>;			
			CreateBill();	
			
			super.build(container, params);
		}	
		
		private function CreateBill():void 
		{
			var totalH:int = header.height + footer.height + bills.length * 29; //такая высота у айтема
			var ypos:int = (Game.SCREEN_HEIGHT - totalH) / 2;
			header.y = ypos;
			ypos += header.height;
			
			bill_items = new Vector.<bill_item>();
			
			for (var i:int = 0; i < bills.length; i++) 
			{				
				var bi:bill_item = new bill_item();
				bill_items.push(bi);
				bi.item.text = bills[i].name;
				bi.price.text = "$" + bills[i].getCostString();
				bi.date.text = bills[i].getTimeLeft();
				bi.addEventListener(MouseEvent.CLICK, onBIClick);
				bi.mouseChildren = false;
				bi.useHandCursor = true;
				bi.buttonMode = true;
				if (!contains(bi)) addChild(bi);
				bi.y = ypos;
				ypos += bi.height;
				bi.bg.gotoAndStop(i % 2 + 1);
			}
			
			footer.y = ypos;
			
			clearSelection();
		}
		
		private function click(e:MouseEvent):void 
		{
			if (current_index >= 0 && bills[current_index].cost <= GameWorld.lumberjack.cash) {				
				GameWorld.lumberjack.cash -= bills[current_index].cost;
				trace(bills[current_index].cost);
				payment_sucs();
				
				
				PopText.at("$" + GameWorld.lumberjack.cash, GameWorld.lumberbody.position.x, GameWorld.lumberbody.position.y - 20, 0xffffff);

				
			}
		}
		
		private function payment_sucs():void {
			
			GameWorld.contracts.PayBill(bills.splice(current_index, 1)[0]);
			trace("bills.splice(current_index, 1); " + current_index);
			
			for (var i:int = 0; i < bill_items.length; i++) 
			{
				bill_items[i].removeEventListener(MouseEvent.CLICK, onBIClick);
				removeChild(bill_items[i]);
			}
			
			bill_items.length = 0;
			CreateBill();
		}
		
		
		
		private function onBIClick(e:MouseEvent):void 
		{
			for (var i:int = 0; i < bill_items.length; i++) 
			{
				if (bill_items[i] == e.currentTarget) {
					if (i != current_index) selectIndex(i);
					else clearSelection();
				}
			}			
		}
		
		private function clearSelection():void 
		{
			footer.title.text = "";
			footer.dsc.text = bills.length > 0 ? "Select one of the bills abote to pay for" : "You don't have any unpaid bills now. Come again later.";
			footer.buy_button.visible = false;
			current_index = -1;
			
			for (var j:int = 0; j < bill_items.length; j++) 
			{
				bill_items[j].bg.gotoAndStop(j % 2 + 1);
			}
		}
		
		private function selectIndex(i:int):void 
		{
			for (var j:int = 0; j < bill_items.length; j++) 
			{
				bill_items[j].bg.gotoAndStop(j % 2 + 1);
			}
			
			current_index = i;
			
			bill_items[i].bg.gotoAndStop(3);
			footer.title.text = bills[current_index].name;
			footer.dsc.text = GameWorld.lumberjack.cash >= bills[i].cost ? "Standart bill description. Will be replace soon" : "You don't have enough money to pay";
			
			
			footer.buy_button.visible = true;
			pay_button.text = bills[current_index].getCostString();
			
		}
		
	}

}