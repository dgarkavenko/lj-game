package dynamics.interactive 
{
	import dynamics.Collision;
	import dynamics.interactions.PlayerInteractiveObject;
	import flash.display.Bitmap;
	import framework.screens.GameScreen;
	import gameplay.contracts.BaseContract;
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
	/**
	 * ...
	 * @author DG
	 */
	public class Mailbox extends PlayerInteractiveObject
	{
		
		public var getContracts:Function;
		
		public function Mailbox() 
		{
			bitmap = new Bitmap(new HomeMailbox());
			body = build(new Vec2(90, 314), [Polygon.rect(0, 0, bitmap.width, bitmap.height)], Material.wood());
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
		}
		
		override public function onUse(params:Object):void 
		{
			if (getContracts == null || getContracts().length == 0) return;		
			
			GameScreen.POP.show(PopupManager.CONTRACT, true, getContracts());
			
			
			//
			//CONTRACT
			//ScreenManager.inst.showScreen(MapScreen);
		}
		
		
		
	}

}