package  
{
	import com.greensock.TweenLite;
	import dynamics.actions.PuddleBurnAction;
	import dynamics.actions.TreeHitAction;
	import dynamics.Collision;
	import dynamics.DynamicWorldObject;
	import dynamics.enemies.base.Dummy;
	import dynamics.enemies.implement.Spitter;
	import dynamics.enemies.implement.spitter.GooProjectile;
	import dynamics.GameCb;
	import dynamics.interactions.PlayerInteractiveObject;
	import dynamics.interactive.Boat;
	import dynamics.interactive.Engine;
	import dynamics.interactive.GasCan;
	import dynamics.player.Lumberjack;
	import dynamics.Tree;
	import flash.Boot;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.utils.setTimeout;
	import framework.Camera;
	import framework.FormatedTextField;
	import framework.input.Controls;
	import framework.PhysDebug;
	import framework.ScreenManager;
	import framework.screens.DayScreen;
	import framework.screens.GameScreen;
	import framework.screens.MenuScreen;
	import framework.SpriteContainer;
	import gamedata.DataSources;
	import gameplay.EvilGenius;
	import gameplay.player.SkillList;
	import gameplay.TreeHandler;
	import gameplay.world.Enviroment;
	import gameplay.world.Forest;
	import gameplay.world.Ground;
	import gui.PopText;
	import gui.PopupManager;
	import hud.EyeBitmap;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	import gameplay.world.Light;
	import gameplay.world.WorldTime;
	import visaul.L04;
	import visual.Bg1_bitmap;
	import visual.Bg2_bitmap;
	import visual.Fireplace_mc;
	import visual.L01;
	import visual.L02;
	import visual.L03;

	/**
	 * ...
	 * @author DG
	 */
	public class GameWorld extends Sprite
	{			
		private var gravity:Vec2 = new Vec2(0, 600);		
		private var dt:Number = 1 / 30;	
		
		public static var camera:Camera;
		
		public static var container:SpriteContainer = new SpriteContainer();
		
		
		public static var space:Space;		
		
		public static var WORLD_SIZE_X:int = 6000;
		public static var lumberjack:Lumberjack;
		public static var lumberbody:Body;
		public static var ground:Ground;
		
		public static var EG:EvilGenius;
		
		
		static public var gunFlash:Vec2;
		
		private var mouse_sprite:Bitmap;	
		
		public static var zombies:Vector.<Dummy> = new Vector.<Dummy>();
		private static var dynamicsVec:Vector.<DynamicWorldObject> = new Vector.<DynamicWorldObject>();
		
		
		
		public static var playerInteractors:Vector.<PlayerInteractiveObject> = new Vector.<PlayerInteractiveObject>();
		
		private var time:WorldTime;
		private var l:Light;
		private var temp:Boolean;
		private var fire:Fireplace_mc;
		
		
		private var loadedBitmpas:Object = new Object();
		
		
		private var projectile_listener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, GameCb.PROJECTILE, GameCb.GROUND.including(GameCb.LUMBERJACK), onProjectileHit);
		private var puddle_b_listener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, GameCb.PUDDLE, GameCb.LEGS, onPuddleBegin);
		private var puddle_e_listener:InteractionListener = new InteractionListener(CbEvent.END, InteractionType.SENSOR, GameCb.PUDDLE, GameCb.LEGS, onPuddleEnd);

		
		private function onProjectileHit(cb:InteractionCallback):void {
			cb.int1.userData.onHit();
		}
		
		private function onPuddleBegin(cb:InteractionCallback):void {
			
			lumberjack.interact(new PuddleBurnAction(5));
		}
		
		private function onPuddleEnd(cb:InteractionCallback):void {
			
			lumberjack.interact(new PuddleBurnAction(0));
		}
		
		
		
		
		public function GameWorld() 
		{
			
			if (stage) initialize();
			else addEventListener(Event.ADDED_TO_STAGE, initialize);
			
			
		}
		
		private function initialize(e:Event = null):void 
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			new Boot();
			space = new Space(gravity);
			addChild(container);	
			
			
			projectile_listener.space = space;
			puddle_b_listener.space = space;
			puddle_e_listener.space = space;
			
			time = new WorldTime(container);
			addChild(time.shade);
			addChild(time.bar);
			
			
			camera = new Camera();			
			ground = new Ground(space, container);
			
			
			lumberjack = new Lumberjack(500, Lumberjack.INITIAL_Y);			
			lumberbody = lumberjack.getBody();
			lumberjack.onPlayerMoveCallback = onPlayerMove;		
			
			//Enviroment.place_GasStation(2100);
			Forest.grow(space, container, 1000, GameWorld.WORLD_SIZE_X - 750, 35);
			
		
			
			//Бэкграунд
			bg_up();
			
			//Добавление эффектов
			container.layer1.addChild($VFX.emitter);			
			setUpMouseSprite();
			
			
			fire = new Fireplace_mc();
			
			
			addChild(fire);
			
			
			//container.layer2.addChild(fire);
			
			fire.addEventListener("tick", onFire);
			
			EG = new EvilGenius(space, container, lumberjack);
			
		}
		
		private function onFire(e:Event):void 
		{
			
			l = new Light("tick");
			l.x = 590; l.y = 335;
			
			if (temp) {
				l.bitmap = new L03();
			
			}else {
				l.bitmap = new L04();
			}
			
			temp = !temp;
			
			
			
		}
		
		private function onPlayerMove():void {
			
			if (Math.abs( lumberbody.position.x - 500) < 100) {
				lumberjack.hp.auraEffect(true)
			}else {				
				lumberjack.hp.auraEffect(false)
			}
			
		}
		
		
		//Убрать отсюда
		private function setUpMouseSprite():void 
		{
			mouse_sprite = new Bitmap(new EyeBitmap());			
			addChild(mouse_sprite);			
			Mouse.hide();
		}
		
		
		private function nextDay():void {
			
			DataSources.lumberkeeper.day++;
			DataSources.lumberkeeper.save();
			
			lumberjack.disabled = false;
			
			if (!lumberbody.allowRotation) {
				lumberbody.scaleShapes(.5, 2);
				lumberjack.movement.unlock_x();
			}else {
				lumberbody.rotation = 0;
				lumberbody.torque = 0;
				lumberbody.angularVel = 0;
				lumberbody.allowRotation = false;
			}
			
			lumberjack.view.idle();			
			lumberbody.position.setxy(Lumberjack.INITIAL_X, Lumberjack.INITIAL_Y);
			tick();
			
			ScreenManager.inst.showScreen(DayScreen);
		}
		
		
		
		private function bg_up():void 
		{
			
			
			/**
			 * Статический бэкграунд
			 */
			var bg:Sprite = new Sprite();			
			var gradientmatrix:Matrix = new Matrix();
			gradientmatrix.createGradientBox(Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT, Math.PI / 2);			
			//bg.graphics.beginGradientFill(GradientType.RADIAL, [0xcadaba, 0x9cad9d], [1, 1], [0, 255], gradientmatrix);
			bg.graphics.beginGradientFill(GradientType.RADIAL, [0x9cad9d, 0x9cad9d], [1, 1], [0, 255], gradientmatrix);			
			

			bg.graphics.drawRect(0, 0, Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT);
			bg.graphics.endFill();
			addChildAt(bg, 0);
			
			
			camera.pan_H(lumberbody.worldCOM.x);			
			var skybg:MovieClip = new MovieClip();			
			var bgdata:Object = DataSources.instance.getReference("bg");			
			
			for (var i:int = bgdata.count; i > 0; i--) 
			{				
				
				
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, lcomplete);
				loader.load(new URLRequest(bgdata["n"+i.toString()]));
			}
			
			setTimeout(addBgs, 1000);
			//addBgs();
			
			/*
			var	bg1:Bitmap = new Bitmap(new Bg1_bitmap());
			bg1.y = Game.SCREEN_HEIGHT - bg1.height - 15;			
			
			
			var	bg2:Bitmap = new Bitmap(new Bg2_bitmap());
			bg2.y = Game.SCREEN_HEIGHT - bg2.height - 15;
			
			*/
			
			/*
			var bdate:BitmapData = new BitmapData(Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT, false, 0xff717240);
			var invert:Bitmap = new Bitmap(bdate);			
			invert.blendMode = BlendMode.SUBTRACT;			
			addChildAt(invert, 1);	*/	
			
			
			//container.layer3.addChild(bg2);
			//container.layer3.addChild(bg1);
			
			//addChildAt(bg1, 1);
			//addChildAt(bg2, 1);	
			
			//camera.controlBgLayer(bg1);
			//	camera.controlBgLayer(bg2);		
			
		}
		
		private function addBgs():void 
		{			
			for (var i:int = 0; i < 10; i++) 
			{
				if ("bg" + i + ".png" in loadedBitmpas) {
				
					addChildAt(loadedBitmpas["bg" + i + ".png"], 1);
					camera.controlBgLayer(loadedBitmpas["bg" + i + ".png"]);
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
		
	
		
		public function tick():void {			
			
			
			
			PhysDebug.tick();		
			
			
			TreeHandler.inst.tick();
			
			mouse_sprite.x = Controls.mouse.screenX - 25 / 2;
			mouse_sprite.y = Controls.mouse.screenY - 13 / 2;
			
			camera.pan_H(lumberbody.worldCOM.x);
			lumberjack.tick();			
			
			$VFX.step();
			
			space.step(dt / 2, 10, 10);
			space.step(dt / 2, 10, 10);
			
			//Graphic update
			for (var i:int = 0; i < space.liveBodies.length; i++) {
				
				var body:Body = space.liveBodies.at(i);
				
				var graphic:DisplayObject = body.userData.graphic;
				if (graphic == null) continue;
				
				var graphicOffset:Vec2 = body.userData.graphicOffset;
                var position:Vec2 = graphicOffset == null? body.worldCOM.copy() : body.localPointToWorld(graphicOffset);
				
                graphic.x = position.x;
                graphic.y = position.y;
                graphic.rotation = (body.rotation * 180/Math.PI) % 360;
                position.dispose();
				
			}
			
			for each (var io:PlayerInteractiveObject in playerInteractors) 
			{
				io.tick();
			}
			
			if (Controls.keys.justPressed("L")) {		
				
				
				PopText.at("DEBUG VIEW", lumberbody.position.x, lumberbody.position.y, 0xffffff);
				
				Mouse.hide();
				trace("------------------ LOG ------------------");
				trace(lumberbody.position.toString());				
				if (PhysDebug.is_active) PhysDebug.off();
				else PhysDebug.on();
			}
			
			if (Controls.keys.justPressed("SPACE")) {				
				//GameScreen.POP.show(PopupManager.SHOP);
				lumberjack.skills.skill_up(3);
			}
			
			if (Controls.keys.justPressed("ESCAPE")) {
				ScreenManager.inst.showScreen(MenuScreen);
			}
			
			for each (var z:Dummy in zombies) 
			{
				z.tick();
			}
			
			for each (var o:DynamicWorldObject in dynamicsVec) {
				o.tick();
			}
			
			time.tick();
			
			fire.x = 550 + container.x;
			fire.y = 281 + container.y;
			
			
			WorldTime.addLight(l);
			
			
		}
		
		static public function regOnTick(object:DynamicWorldObject):void 
		{
			dynamicsVec.push(object);
		}
		static public function removeOnTick(object:DynamicWorldObject):void 
		{
			for (var i:int = 0; i < dynamicsVec.length; i++) 
			{
				if (object == dynamicsVec[i]) {
					dynamicsVec.splice(i, 1);
					break;
				}
			}
		}
		
		
	}

}