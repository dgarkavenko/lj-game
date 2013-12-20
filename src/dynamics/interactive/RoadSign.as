package dynamics.interactive 
{
	import dynamics.Collision;
	import dynamics.interactions.PlayerInteractiveObject;
	import flash.display.Bitmap;
	import framework.ScreenManager;
	import framework.screens.MapScreen;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import visuals.SignBMP;
	/**
	 * ...
	 * @author DG
	 */
	public class RoadSign extends PlayerInteractiveObject
	{
		
		
		public function RoadSign() 
		{
			bitmap = new Bitmap(new SignBMP());
			body = build(new Vec2(500, 322), [Polygon.rect(0, 0, 47, 67)], Material.wood());
			body.userData.graphic = bitmap;
			body.align();			
			body.userData.graphicOffset = new Vec2(int(-bitmap.width/2), int(-bitmap.height/2));			
			Collision.setFilter(body, Collision.LUMBER_IGNORE, ~Collision.LUMBER_IGNORE);			
			applySuperPreferences(body);
			
			label_offset_y = 40;
		}		
		
		override public function onUse(params:Object):void 
		{
			ScreenManager.inst.showScreen(MapScreen);
		}
		
		override public function add():void {
			GameWorld.container.layer2.addChild(bitmap);
			body.space = space;
			super.add();
		}
		
	}

}