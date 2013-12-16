package locations 
{
	/**
	 * ...
	 * @author DG
	 */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import framework.ScreenManager;
	import framework.SpriteContainer;
	import gamedata.DataSources;
	import gameplay.TreeHandler;
	import gameplay.world.Enviroment;
	import gameplay.world.Ground;
	import gameplay.world.Light;
	import nape.space.Space;
	import visual.Fireplace_mc;
	 
	public class ForestLocation extends BaseLocation
	{
		private var ground:Ground;
		private var loadedBitmpas:Object = new Object();
		private var fire:Fireplace_mc;
		private var l:Light;
		private var bg:Sprite;
		
		public function ForestLocation() 
		{
			location_w = 6000;
		}
		
		override public function build(world_:GameWorld):void {
			
			super.build(world_);
			
			ground = new Ground(GameWorld.space, GameWorld.container);
			
			//Enviroment.place_GasStation(2100, ground);
			var ref:Object = DataSources.instance.getReference("world");			
			TreeHandler.inst.grow(GameWorld.space, GameWorld.container, 1000, GameWorld.WORLD_SIZE_X - 750, ref.trees);		
			
			
			
		}
		
		override public function destroy():void {
			ground.hell.space = null;
			ground.ground.space = null;
			
			while (GameWorld.container.layer1.numChildren > 0) {
				GameWorld.container.layer1.removeChildAt(0);
			}
			
			while (GameWorld.container.layer0.numChildren > 0) {
				GameWorld.container.layer0.removeChildAt(0);
			}
			
			while (GameWorld.container.layer4.numChildren > 0) {
				GameWorld.container.layer4.removeChildAt(0);
			}
			
			world.removeChild(bg);
			world = null;
		}
		
		override public function addBackground():void 
		{
			/**
			 * Статический бэкграунд
			 */
			bg = new Sprite();			
			var gradientmatrix:Matrix = new Matrix();
			gradientmatrix.createGradientBox(Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT, Math.PI / 2);			
			//bg.graphics.beginGradientFill(GradientType.RADIAL, [0xcadaba, 0x9cad9d], [1, 1], [0, 255], gradientmatrix);
			bg.graphics.beginGradientFill(GradientType.RADIAL, [0x9cad9d, 0x9cad9d], [1, 1], [0, 255], gradientmatrix);			
			

			bg.graphics.drawRect(0, 0, Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT);
			bg.graphics.endFill();
			world.addChildAt(bg, 0);
			
			var bgdata:Object = DataSources.instance.getReference("bg");			
			
			for (var i:int = bgdata.count; i > 0; i--) 
			{							
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, lcomplete);
				loader.load(new URLRequest(bgdata["n"+i.toString()]));
			}
			
			
			
			setTimeout(addBgs, 1000);			
			
		}
		
		private function addBgs():void 
		{			
			for (var i:int = 0; i < 10; i++) 
			{
				if ("bg" + i + ".png" in loadedBitmpas) {
				
					world.addChildAt(loadedBitmpas["bg" + i + ".png"], 1);
					GameWorld.camera.controlBgLayer(loadedBitmpas["bg" + i + ".png"]);
				}
			}			
			
		}
		
		private function lcomplete(e:Event):void 
		{			
			var bitmapData:BitmapData = Bitmap(LoaderInfo(e.target).content).bitmapData;
			
			var	bg:Bitmap = new Bitmap(bitmapData);
			bg.y = Game.SCREEN_HEIGHT - bg.height;					
			
			var s:String = LoaderInfo(e.target).url;
			loadedBitmpas[s.substr(s.length - 7, s.length)] = bg;
			
			
		}
		
	}

}