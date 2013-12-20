package dynamics.interactive 
{
	import dynamics.Collision;
	import dynamics.interactions.PlayerInteractiveObject;
	import flash.display.Bitmap;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import visuals.HomeMailbox;
	import visuals.SignBMP;
	/**
	 * ...
	 * @author DG
	 */
	public class Mailbox extends PlayerInteractiveObject
	{
		
		
		public function Mailbox() 
		{
			bitmap = new Bitmap(new HomeMailbox());
			body = build(new Vec2(90, 322), [Polygon.rect(0, 0, bitmap.width, bitmap.height)], Material.wood());
			body.userData.graphic = bitmap;
			body.align();
			body.space = null;
			
			
			body.userData.graphicOffset = new Vec2(int(-bitmap.width/2), int(-bitmap.height/2));
			
			Collision.setFilter(body, Collision.LUMBER_IGNORE, ~Collision.LUMBER_IGNORE);			
			applySuperPreferences(body);
			label_offset_y = 40;
		}
		
		override public function add():void {
			GameWorld.container.layer2.addChild(bitmap);
			body.space = space;
			super.add();
		}
		
	}

}