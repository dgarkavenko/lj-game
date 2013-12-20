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
		private var _body:Body;
		
		public function RoadSign() 
		{
			var b:Bitmap = new Bitmap(new SignBMP());
			_body = build(new Vec2(500, 322), [Polygon.rect(0, 0, 47, 67)], Material.wood());
			_body.userData.graphic = b;
			_body.align();
			
			GameWorld.container.layer2.addChild(b);
			
			_body.userData.graphicOffset = new Vec2(int(-b.width/2), int(-b.height/2));
			
			Collision.setFilter(_body, Collision.LUMBER_IGNORE, ~Collision.LUMBER_IGNORE);			
			applySuperPreferences(_body);
		}
		
		override public function getBody():Body {
			return _body;
		}
		
		override public function onUse(params:Object):void 
		{
			ScreenManager.inst.showScreen(MapScreen);
		}
		
		override public function onFocus():void 
		{
			super.onFocus();
			label.x = _body.position.x;
			label.y = _body.position.y - 40;
			
		}
		
	}

}