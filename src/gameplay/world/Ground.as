package gameplay.world 
{
	import dynamics.GameCb;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import framework.SpriteContainer;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	import visual.Anchor_bitmap;
	import visual.Ground_bg_west_bitmap;
	import visual.Ground_bitmap;
	import visual.Pier_bitmap;
	import visual.PierFG_bitmap;
	import visual.Shore_mc;
	import visual.Suitcase_bitmap;
	import visual.WaterOverlay_bitmap;
	import visual.WaterOverlayEast_bitmap;

	/**
	 * ...
	 * @author DG
	 */
	public class Ground 
	{
		
		private var ground_material:Material = Material.sand();
		
		private static var MARGIN_LEFT:int = 305;
		private static var MARGIN_RIGHT:int = 305;
		
		private var ground:Body;
		private var shore_mc:MovieClip;
		private var gmc:Bitmap;
		private var gmc2:Bitmap;
		
		private var hell:Body;
		
		public static var HEIGHT:int = 32;
		
		public function Ground(space:Space, container:SpriteContainer){
			
			ground_material.elasticity = 0.035;			
			
		
					
			var groundWidth:int = GameWorld.WORLD_SIZE_X - MARGIN_RIGHT - MARGIN_LEFT;
			var verts:Array = [new Vec2(0,36), new Vec2(205,0), new Vec2(groundWidth, 0), new Vec2(groundWidth,36) ];	
			
			ground = new Body(BodyType.STATIC, new Vec2(MARGIN_LEFT, Game.SCREEN_HEIGHT - HEIGHT)); // dunno about 22
			ground.shapes.add(new Polygon(verts, ground_material));			
			ground.cbTypes.add(GameCb.GROUND);
			ground.space = space;
		
			//Graphical
			
			shore_mc = new Shore_mc();	
			shore_mc.y = Game.SCREEN_HEIGHT;
			
			
			//TEXTURE IS TO BIG TO RENDER
			//SO WE BREAK IT
			var bdata:Ground_bitmap = new Ground_bitmap();	
			var mt:Matrix;
			
			gmc = new Bitmap(new BitmapData(20 * bdata.width, 36, true, 0x0));
			
			var ite:int = 20;			
			for (var i:int = 0; i < ite; i++) 
			{
				mt = new Matrix(1, 0, 0, 1, bdata.width * i);				
				gmc.bitmapData.draw(bdata, mt);
			}		
			
			//TODO: CUT BG
			gmc.x = shore_mc.width - 1; //OVERLAPPING PIXEL
			
			
			var pier:Bitmap = new Bitmap(new Pier_bitmap());
			
			
			var widthOf2ndPart:int = groundWidth + MARGIN_RIGHT - shore_mc.width - gmc.width + 2 - 369 //pier.width; //OVERLAPPING
			gmc2 = new Bitmap(new BitmapData(widthOf2ndPart, 36, true, 0x0));
			
			ite = widthOf2ndPart / bdata.width + 1;			
			for (i = 0; i < ite; i++) 
			{
				mt = new Matrix(1, 0, 0, 1, bdata.width * i);				
				gmc2.bitmapData.draw(bdata, mt);
			}
			
			gmc2.x = gmc.x + gmc.width;
			gmc2.y = gmc.y = Game.SCREEN_HEIGHT - gmc.height;	
			
			pier.y = Game.SCREEN_HEIGHT - pier.height;
			pier.x = gmc2.x + gmc2.width - 1;
			
			container.layer1.addChild(shore_mc);	
			container.layer1.addChild(gmc);	
			container.layer1.addChild(pier);
			container.layer1.addChild(gmc2);
			
			//VisualAlignment.apply(shore);
			//VisualAlignment.apply(ground);
			
			//DECORATIONS
			
			var bm:Bitmap = new Bitmap(new WaterOverlay_bitmap());
			container.layer0.addChild(bm);
			bm.y = Game.SCREEN_HEIGHT - bm.height;
			
			bm = new Bitmap(new Anchor_bitmap());
			container.layer0.addChild(bm);
			bm.y = Game.SCREEN_HEIGHT - bm.height - 5;
			bm.x = 420;
			
			bm = new Bitmap(new Suitcase_bitmap());
			container.layer0.addChild(bm);
			bm.y = Game.SCREEN_HEIGHT - bm.height - 2;
			bm.x = 445;
			
			/*bm = new Bitmap(new PierFG_bitmap());
			container.layer0.addChild(bm);
			bm.y = Game.SCREEN_HEIGHT - bm.height;
			bm.x = pier.x + 345;*/
			
			bm = new Bitmap(new WaterOverlayEast_bitmap());
			container.layer0.addChild(bm);
			bm.y = Game.SCREEN_HEIGHT - bm.height;
			bm.x = pier.x;
			
			bm = new Bitmap(new Ground_bg_west_bitmap());
			container.layer4.addChild(bm);
			bm.y = Game.SCREEN_HEIGHT - bm.height;
				
			hell = new Body(BodyType.STATIC, new Vec2(0, Game.SCREEN_HEIGHT + 90));
			hell.shapes.add(new Polygon(Polygon.rect(0, 0, GameWorld.WORLD_SIZE_X, 100)));
			hell.space = space;
			hell.cbTypes.add(GameCb.HELL);
			
		}
		
		public function getGroundIndex():int{
			return GameWorld.container.layer3.getChildIndex(shore_mc);
		}
		
		public function getGroundBitmap():Bitmap 
		{
			return gmc;
		}
		
		
		
		
	}

}