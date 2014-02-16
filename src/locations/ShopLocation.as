package locations 
{
	import dynamics.GameCb;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import framework.ScreenManager;
	import framework.screens.GameScreen;
	import framework.screens.MapScreen;
	import gui.PopupManager;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import visual.Ground_bitmap;
	/**
	 * ...
	 * @author DG
	 */
	public class ShopLocation extends BaseLocation
	{
		private var ground:Body;
		private var gmc:Bitmap;
		
		public function ShopLocation() 			
		{
			location_w = Game.SCREEN_WIDTH;
			initial_x = 50;
			initial_y = 339;
		}
		
		override public function build(world_:GameWorld):void {		
			
			super.build(world_);	
			
			var ground_material:Material = Material.sand();
			ground_material.elasticity = 0.035;			
			
			ground = new Body(BodyType.STATIC, new Vec2(-100, Game.SCREEN_HEIGHT - 32));
			ground.shapes.add(new Polygon(Polygon.rect(0,0, location_w + 200, 36), ground_material));			
			ground.cbTypes.add(GameCb.GROUND);
			ground.space = GameWorld.space;
			
			var bdata:Ground_bitmap = new Ground_bitmap();	
			var mt:Matrix;
			
			gmc = new Bitmap(new BitmapData(location_w + 100, 36, true, 0x0));
			gmc.y = Game.SCREEN_HEIGHT - gmc.height;
			
			var ite:int = (location_w)/ bdata.width + 1;			
			for (var i:int = 0; i < ite; i++) 
			{
				mt = new Matrix(1, 0, 0, 1, bdata.width * i);				
				gmc.bitmapData.draw(bdata, mt);
			}
			
			GameWorld.container.layer1.addChild(gmc);
			
			GameScreen.POP.show(PopupManager.SHOP, false);
			
		}
		
		override public function destroy():void {
			super.destroy();
		}
		
		override public function right():void {
			
			GameWorld.lumberbody.applyImpulse(new Vec2( -150, -10));				
			
		}
		
		override public function left():void 
		{
			ScreenManager.inst.showScreen(MapScreen);
		}
		
	}

}