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
	import visuals.HomeHouse;
	/**
	 * ...
	 * @author DG
	 */
	public class House extends PlayerInteractiveObject
	{
		
		private var _body:Body;
		
		public function House() 
		{
			
			var b:Bitmap = new Bitmap(new HomeHouse());
			_body = build(new Vec2(200, 192), [Polygon.rect(0, 0, b.width, b.height)], Material.wood());
			_body.userData.graphic = b;
			GameWorld.container.layer4.addChild(b);
			
			_body.userData.graphicOffset = new Vec2(-b.width/2, int(-b.height/2));
				
			
			_body.type = BodyType.STATIC;
			VisualAlignment.apply(_body);
			
			Collision.setFilter(_body, Collision.LUMBER_IGNORE, ~Collision.LUMBER_IGNORE);			
			applySuperPreferences(_body);
		}
		
		override public function getBody():Body {
			return _body;
		}
		
	}

}