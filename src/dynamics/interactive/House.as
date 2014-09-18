package dynamics.interactive 
{
	import dynamics.Collision;
	import dynamics.interactions.PlayerInteractiveObject;
	import flash.display.Bitmap;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import utils.VisualAlignment;
	import visual.VentureBMP;
	import visuals.HomeHouse;
	/**
	 * ...
	 * @author DG
	 */
	public class House extends PlayerInteractiveObject
	{
		
	
	
		
		public function House() 
		{
			
			bitmap = new Bitmap(new VentureBMP());
			//body = build(new Vec2(140, 167), [Polygon.rect(0, 0, bitmap.width, bitmap.height)], Material.wood());
			body = build(new Vec2(280, 167), [[new Vec2(52,52), new Vec2(275,65), new Vec2(bitmap.width,115), new Vec2(bitmap.width, bitmap.height), new Vec2(0, bitmap.height), new Vec2(0, 120)]], Material.wood());

			
			body.userData.graphic = bitmap;
			body.space = null;			
			
			
			body.userData.graphicOffset = new Vec2(-bitmap.width/2, int(-bitmap.height/2) - 37);				
			
			body.type = BodyType.STATIC;
			VisualAlignment.apply(body);			

			Collision.setFilter(body, Collision.LUMBER_IGNORE, ~Collision.LUMBER_IGNORE);			
			applySuperPreferences(body);
			
			
		}
		
		
		
		override public function add():void {
			GameWorld.container.layer4.addChild(bitmap);
			body.space = space;
			super.add();
		}
		
		override public function onFocus():void {
			
		}
		
		override public function onLeaveFocus():void 
		{
			
		}
		
		
	}

}