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
	import flash.display.InteractiveObject;
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
	import framework.screens.GameOverScreen;
	import framework.screens.GameScreen;
	import framework.screens.MapScreen;
	import framework.screens.MenuScreen;
	import framework.SpriteContainer;
	import gamedata.DataSources;
	import gameplay.contracts.ContractHandler;
	import gameplay.DeathReason;
	import gameplay.EvilGenius;
	import gameplay.player.HP;
	import gameplay.player.SkillList;
	import gameplay.TreeHandler;
	import locations.ForestLocation;
	import locations.HomeLocation;



	import gameplay.world.TimeManager;
	import gui.PopText;
	import gui.PopupManager;
	import hud.EyeBitmap;
	import locations.LocationManager;
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

		
		public static var EG:EvilGenius;
		
		
		static public var gunFlash:Vec2;
		
		private var mouse_sprite:Bitmap;	
		
		public static var zombies:Vector.<Dummy> = new Vector.<Dummy>();
		private static var dynamicsVec:Vector.<DynamicWorldObject> = new Vector.<DynamicWorldObject>();
		
		
		
		public static var playerInteractors:Vector.<PlayerInteractiveObject> = new Vector.<PlayerInteractiveObject>();
		
		public static var time:TimeManager;
		private var contracts:ContractHandler;
		private var locationManager:LocationManager = LocationManager.inst;
		
		
		
		private var temp:Boolean;
		
		
		
		
		
		private var projectile_listener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, GameCb.PROJECTILE, GameCb.GROUND.including(GameCb.LUMBERJACK), onProjectileHit);
		private var puddle_b_listener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, GameCb.PUDDLE, GameCb.LEGS, onPuddleBegin);
		private var puddle_e_listener:InteractionListener = new InteractionListener(CbEvent.END, InteractionType.SENSOR, GameCb.PUDDLE, GameCb.LEGS, onPuddleEnd);
		private var inhell_listener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, GameCb.HELL, GameCb.LUMBERJACK, inHell);
		
		
		
		
		
		private function onDayTimeChanged(e:Event):void 
		{
			contracts.timeUpdate(time.time);
		}

		
		private function onProjectileHit(cb:InteractionCallback):void {
			cb.int1.userData.onHit();
		}
		
		private function onPuddleBegin(cb:InteractionCallback):void {
			
			lumberjack.interact(new PuddleBurnAction(5));
		}
		
		private function onPuddleEnd(cb:InteractionCallback):void {
			
			lumberjack.interact(new PuddleBurnAction(0));
		}
		
		private function inHell(cb:InteractionCallback):void {
			
			lumberjack.lastDamage = DeathReason.DROWNED;
			protaganistIsDead();
		}
		
		
		
		
		public function GameWorld() 
		{
			
			if (stage) first_launch();
			else addEventListener(Event.ADDED_TO_STAGE, first_launch);
			
			
		}
		
		private function first_launch(e:Event = null):void {
		
			removeEventListener(Event.ADDED_TO_STAGE, first_launch);	
			new Boot();
			addChild(container);

			space = new Space(gravity);
			
			PhysDebug.space = space;
			PhysDebug.container = container;
				
			inhell_listener.space = projectile_listener.space = space;
			puddle_b_listener.space = puddle_e_listener.space = space;
				
			time = new TimeManager(container);
			time.addEventListener(TimeManager.DayTimeChange, onDayTimeChanged);		
			
			addChild(time.shade);
			addChild(time.bar);
				
			camera = new Camera();			
			
			locationManager.init(this);
			
			lumberjack = new Lumberjack(500, 500);			
			lumberbody = lumberjack.getBody();
			lumberjack.onPlayerMoveCallback = onPlayerMove;	
				
			
				
			container.layer1.addChild($VFX.emitter);
			
			EG = new EvilGenius(space, container, lumberjack);			
			initializeNewGame();
		}
		
		public function initializeNewGame():void 
		{
			
			contracts = new ContractHandler();
			contracts.timeUpdate(time.time);			
			lumberjack.getBody().position.setxy(locationManager.initial_X, locationManager.initial_Y);
			lumberjack.hp.init(100);

			setUpMouseSprite();
			
			
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
			Mouse.hide();			
			
			if (mouse_sprite == null)
			{
				mouse_sprite = new Bitmap(new EyeBitmap());
				addChild(mouse_sprite);			
				
			}
			
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
			
			if (Controls.keys.justPressed("M")) {
				ScreenManager.inst.showScreen(MapScreen);
			}
			
			if (Controls.keys.justPressed("Z")) {
			
				EG.spawnAt(Controls.mouse.relativeX, Controls.mouse.relativeY);
			}			
			
			/*if (Controls.keys.justPressed("ESCAPE")) {
				ScreenManager.inst.showScreen(MenuScreen);
			}*/
			
			for each (var z:Dummy in zombies) 
			{
				z.tick();
			}
			
			for each (var o:DynamicWorldObject in dynamicsVec) {
				o.tick();
			}
			
			time.tick();		
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
		
		static public function protaganistIsDead():void 
		{
			ScreenManager.inst.showScreen(GameOverScreen);
			
		}
		
		public function softReset():void 
		{
			
			
			TreeHandler.inst.clear();
			
			for each (var item:DynamicWorldObject in dynamicsVec ) 
			{
				item.destroy();
			}			
			
			if (EG != null) EG.clear();			
			
			for each (var io:PlayerInteractiveObject in playerInteractors) {
				io.destroy();
			}
			
			playerInteractors.length = dynamicsVec.length = 0;			
			$VFX.clear();			
		}
		
		
	}

}