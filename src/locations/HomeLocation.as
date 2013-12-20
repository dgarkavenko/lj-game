package locations 
{
	import dynamics.BaseSpriteControl;
	import dynamics.GameCb;
	import dynamics.interactive.House;
	import dynamics.interactive.Mailbox;
	import dynamics.interactive.RoadSign;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import gameplay.TreeHandler;
	import gameplay.world.Forest;
	import gameplay.world.Ground;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import visual.Ground_bitmap;
	import visuals.HomeBGBMP;
	/**
	 * ...
	 * @author DG
	 */
	public class HomeLocation extends BaseLocation
	{
		private var ground:Body;
		private var bg:Bitmap;
		private var gmc:Bitmap;
		
		
		private static var house:House;
		private static var sign:RoadSign;
		private static var mailbox:Mailbox;
		
		
		
		public function HomeLocation() 
		{
			location_w = 640;
			initial_x = 439;
			initial_y = 339;
		}
		
		override public function build(world_:GameWorld):void {
			super.build(world_);
			
			var verts:Array = [new Vec2(0, 36), new Vec2(9, 0), new Vec2(900, 0), new Vec2(900, 36) ];	
			
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
			
			if (house == null || sign == null || mailbox == null) {
				house = new House();
				sign = new RoadSign();
				mailbox = new Mailbox();
			}		
			
			house.add();
			sign.add();
			mailbox.add();
			
			TreeHandler.inst.grow(GameWorld.space, GameWorld.container, 24, 25, 1);
			
			
			
		}
		
		override public function addBackground():void 
		{
			/**
			 * Статический бэкграунд
			 */
			
			bg = new Bitmap(new HomeBGBMP());
			bg.x = -130;
			GameWorld.container.layer4.addChild(bg);
			//GameWorld.camera.controlBgLayer(bg);
			
		}
		
		override public function destroy():void {
			super.destroy();
			ground.space = null;
			ground = null;
			
			GameWorld.container.layer1.removeChild(gmc);
		}
		
	}

}