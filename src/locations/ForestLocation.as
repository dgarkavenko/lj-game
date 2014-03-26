package locations 
{
	/**
	 * ...
	 * @author DG
	 */
	
	import dynamics.GameCb;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import framework.ScreenManager;
	import framework.screens.MapScreen;
	import framework.SpriteContainer;
	import gamedata.DataSources;
	import gameplay.contracts.ContractHandler;
	import gameplay.TreeHandler;
	import gameplay.world.Enviroment;
	import gameplay.world.Ground;
	import gameplay.world.Light;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	import visual.Fireplace_mc;
	import visual.Ground_bitmap;
	 
	public class ForestLocation extends BaseLocation
	{
		private var ground:Body;
		private var ground_material:Material = Material.sand();
		
		private var loadedBitmpas:Object = new Object();
		private var fire:Fireplace_mc;
		private var l:Light;
		private var bg:Sprite;
		private var gmc:Bitmap;
		
		public function ForestLocation() 
		{
			location_w = 3000;
			initial_x = 50;
			initial_y = 339;
		}
		
		override public function build(world_:GameWorld):void {
			
			super.build(world_);		
			
			
			var treedat:Vector.<TreeData> = LocationManager.inst.trees[ForestLocation];
			
			if (treedat != null) {
				
				TreeHandler.inst.growAtCoords(LocationManager.inst.trees[ForestLocation]);
				
			}else {
							
				TreeHandler.inst.growRange(GameWorld.space, GameWorld.container, 530, 2000, 12, 50);		
				TreeHandler.inst.growRange(GameWorld.space, GameWorld.container, 2020, 3020, 12);	
				TreeHandler.inst.growRange(GameWorld.space, GameWorld.container, 173, 174, 1);
				TreeHandler.inst.growRange(GameWorld.space, GameWorld.container, 256, 257, 1);
			}
			
			var stumps:Vector.<Bitmap> = LocationManager.inst.stumps[ForestLocation];
			if (stumps != null) {			
				
				trace("STUMPS:" + stumps.length);
				for (var j:int = 0; j < stumps.length; j++) 
				{
					GameWorld.container.layer3.addChild(stumps[j]);
				}
			}
		
			
			var groundWidth:int = location_w;				
			ground_material.elasticity = 0.035;
			var verts:Array = [new Vec2(-50,36), new Vec2(-50,0), new Vec2(groundWidth + 50, 0), new Vec2(groundWidth + 50,36) ];	
			
			ground = new Body(BodyType.STATIC, new Vec2(0, Game.SCREEN_HEIGHT - 32)); // dunno about 22
			ground.shapes.add(new Polygon(verts, ground_material));			
			ground.cbTypes.add(GameCb.GROUND);
			ground.space = GameWorld.space;
			
			var bdata:Ground_bitmap = new Ground_bitmap();	
			var mt:Matrix;
			
			gmc = new Bitmap(new BitmapData(location_w, 36, true, 0x0));
			
			var ite:int = location_w / bdata.width;			
			for (var i:int = 0; i < ite + 1; i++) 
			{
				mt = new Matrix(1, 0, 0, 1, bdata.width * i);				
				gmc.bitmapData.draw(bdata, mt);
			}		
			
			gmc.y = Game.SCREEN_HEIGHT - gmc.height;	
			GameWorld.container.layer1.addChild(gmc);	
			
			
		}
		
		override public function right():void {
			if (!ContractHandler.isComplete(ContractHandler.DANGER_TO_GO_ALONE)) {
				GameWorld.lumberbody.applyImpulse(new Vec2( -150, -10));
				GameWorld.contracts.addNewContract(ContractHandler.DANGER_TO_GO_ALONE);
			}else {
				//reveal location	
			}
		}
		
		override public function left():void 
		{
			ScreenManager.inst.showScreen(MapScreen);
		}
		
		override public function destroy():void {
			
			
				
			LocationManager.inst.trees[ForestLocation] = TreeHandler.inst.getTreeData();
			LocationManager.inst.stumps[ForestLocation] = TreeHandler.inst.getStumps();
			
			
			super.destroy();
			
			
			ground.space = null;
			
			GameWorld.container.layer1.removeChild(gmc);			
			
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