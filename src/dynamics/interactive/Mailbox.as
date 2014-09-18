package dynamics.interactive 
{
	import com.greensock.TweenLite;
	import dynamics.Collision;
	import dynamics.interactions.PlayerInteractiveObject;
	import flash.display.Bitmap;
	import framework.screens.GameScreen;
	import gameplay.contracts.BaseContract;
	import gameplay.contracts.bills.Bill;
	import gameplay.contracts.ContractHandler;
	import gui.PopupManager;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import utils.VisualAlignment;
	import visuals.HomeMailbox;
	import visuals.SignBMP;
	import visuals.Warning;
	import visuals.WarningClip;
	/**
	 * ...
	 * @author DG
	 */
	public class Mailbox extends PlayerInteractiveObject
	{
		
		
		private var sign:WarningClip = new WarningClip();
		
		
		override public function remove():void {
			super.remove();	
			if (bitmap.parent) bitmap.parent.removeChild(bitmap);
			if (sign.parent) sign.parent.removeChild(sign);
		}
		
		public function Mailbox() 
		{
			bitmap = new Bitmap(new HomeMailbox());
			body = build(new Vec2(228, 314), [Polygon.rect(0, 0, bitmap.width, bitmap.height)], Material.wood());
			body.userData.graphic = bitmap;
			body.align();
			body.space = null;
			body.type = BodyType.STATIC;
			
			
			
			body.userData.graphicOffset = new Vec2(int(-bitmap.width/2), int(-bitmap.height/2));
			
			VisualAlignment.apply(body);
			
			Collision.setFilter(body, Collision.LUMBER_IGNORE, ~Collision.LUMBER_IGNORE);			
			applySuperPreferences(body);
			label_offset_y = 40;
		}
		
		override public function add():void {
			
			GameWorld.container.layer2.addChild(bitmap);
			body.space = space;
			super.add();
			
			
			for each (var item:Bill in GameWorld.contracts.getBillsRef()) 
			{
				if (item.timeLeft() <= 1) {
					
					sign.x = bitmap.x + bitmap.width/2 - sign.width/2 + 2;
					sign.y = bitmap.y - 30;		
		
					GameWorld.container.layer2.addChild(sign);
					break;
				}
			}			
		}			
		
		override public function onUse(params:Object):void 
		{
			
			if (sign.parent) sign.parent.removeChild(sign);
			
			if (GameWorld.contracts.getContracts().length == 0) return;					
			//GameScreen.POP.show(PopupManager.CONTRACT, true, getContracts());
			GameScreen.POP.show(PopupManager.BILLS, true, GameWorld.contracts.getContracts());
			
			//
			//CONTRACT
			//ScreenManager.inst.showScreen(MapScreen);
		}
		
	
		
		
		
	}

}