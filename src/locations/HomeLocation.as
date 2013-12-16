package locations 
{
	import dynamics.BaseSpriteControl;
	import dynamics.GameCb;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import gameplay.world.Ground;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	/**
	 * ...
	 * @author DG
	 */
	public class HomeLocation extends BaseLocation
	{
		private var ground:Ground;
		private var bg:Sprite;
		private var ground_material:Material = Material.rubber();
		
		
		public function HomeLocation() 
		{
			location_w = 900;
		}
		
		override public function build(world_:GameWorld):void {
			super.build(world_);
			
			var verts:Array = [new Vec2(0,36), new Vec2(9,0), new Vec2(900, 0), new Vec2(900,36) ];	
			
			var ground:Body = new Body(BodyType.STATIC, new Vec2(0, Game.SCREEN_HEIGHT - 32));
			ground.shapes.add(new Polygon(verts, ground_material));			
			ground.cbTypes.add(GameCb.GROUND);
			ground.space = GameWorld.space;
			
		}
		
		override public function addBackground():void 
		{
			/**
			 * Статический бэкграунд
			 */
			bg = new Sprite();			
			var gradientmatrix:Matrix = new Matrix();
			gradientmatrix.createGradientBox(Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT, Math.PI / 2);			
			bg.graphics.beginGradientFill(GradientType.RADIAL, [0xcadaba, 0x9cad9d], [1, 1], [0, 255], gradientmatrix);
			//bg.graphics.beginGradientFill(GradientType.RADIAL, [0x9cad9d, 0x9cad9d], [1, 1], [0, 255], gradientmatrix);			
			

			bg.graphics.drawRect(0, 0, Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT);
			bg.graphics.endFill();
			world.addChildAt(bg, 0);
					
			
		}
		
	}

}