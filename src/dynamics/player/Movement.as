package dynamics.player 
{
	import dynamics.GameCb;
	import dynamics.WorldObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	import framework.input.Controls;
	import framework.input.Keyboard;
	import framework.input.Mouse;
	import framework.screens.GameScreen;
	import gamedata.DataSources;
	import gameplay.player.SkillList;
	import gui.PopupManager;
	import idv.cjcat.emitter.PointSource;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	/**
	 * ...
	 * @author DG
	 */
	public class Movement extends EventDispatcher
	{
		private var _carrier:Body;
		private var keys:Keyboard = Controls.keys;		
		private var mouse:Mouse = Controls.mouse;
		private var lumberjack:Lumberjack;
		private var locked_x:Number = NaN;
		private var _grounded:Boolean = true;
		
		public var jump:int = 125;
		public var walk:int = 90 * 1;
		private var speed_m:Number = 1;
		
		private var stuckX:Number = NaN;
		private var deep:int = 0;
		private var view:Lumberskin;
		
		private var moveEvent:Event = new Event("onMove");
		
		private var particleSource:PointSource = $VFX.dust.step;
		
		public function Movement(lj:Lumberjack) 
		{
			lumberjack = lj;
			_carrier = lj.getBody().castBody;
			view = lumberjack.view as Lumberskin;
			
			var groundListener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, GameCb.LEGS, GameCb.GROUND.including(GameCb.TRUNK), groundHandler);
			
			var midAirListener:InteractionListener = new InteractionListener(CbEvent.END, InteractionType.COLLISION, GameCb.LEGS, GameCb.GROUND.including(GameCb.TRUNK), midAirHandler);

			midAirListener.space = groundListener.space = _carrier.space;
		}
		
		public function stuck(deep_:int):void{
			stuckX = _carrier.position.x;
			deep = deep_/2;
		}
		
		private function groundHandler(cb:InteractionCallback):void 
		{
			if (!_grounded) _grounded = true;
			_carrier.velocity.y = 0;
			$VFX.dust.at(_carrier.position.x, _carrier.position.y + 27);
		}	
		
		private function midAirHandler(cb:InteractionCallback):void 
		{
			if (_grounded) _grounded = false;
			//_carrier.velocity.y = 0;
		}	
		
		public function lock_x(dx:Number):void 
		{
			locked_x = dx;
			
		}
		
		public function unlock_x():void {
			locked_x = NaN;
		}
		
		
		
		
		public function tick():void {			
			
			
			lumberjack.facing = _carrier.position.x > mouse.relativeX ? -1 : 1
			
			
			//Damping
			//_carrier.velocity.x *= (Math.pow(0.0001, 1 / 30));			
			_carrier.velocity.x = 0;
			
			
			if (isNaN(stuckX)) {
				
				if (keys.pressed("A") || keys.pressed("LEFT")) {
					
					_carrier.applyImpulse(new Vec2( lumberjack.facing == - 1 ? -walk /** speed_m */: -walk /** speed_m*/, 0));
					if (_grounded) {
						view.walk();		
						particleSource.active = true;
					}
					
					dispatchEvent(moveEvent);
					view.turnLegs( -1);
				
				}else if (keys.pressed("D") || keys.pressed("RIGHT")) {
					_carrier.applyImpulse(new Vec2(lumberjack.facing == 1 ? walk /** speed_m*/  : walk /** speed_m*/, 0));				
					if (_grounded) {
						view.walk();						
						particleSource.active = true;
					}
					
					
					
					view.turnLegs(1);
					dispatchEvent(moveEvent);
					
				}else {
					
					particleSource.active = false;
					
					if (_grounded) { lumberjack.view.idle();
					}else {
						lumberjack.view.jump();
					}
				}				
				
				if (keys.justPressed("W") || keys.justPressed("UP")) {				
					if (_grounded) {
						
						//grounded = false;	
						
						lumberjack.view.jump();			
						particleSource.active = false;
						_carrier.applyImpulse(new Vec2(0, -jump));						
						
						//$AE.did(AchievementEngine.JUMP);
						
					}
				}
				
				
			}else {
				
				particleSource.active = false;
				_carrier.position.x = stuckX;
				
				if (keys.justPressed("W") || keys.justPressed("UP")) {				
					
					
					deep--;
					
					if (deep <= 0) {
						
						stuckX = NaN;						
						lumberjack.unstuck();
						
						_carrier.applyImpulse(new Vec2(0, -jump));					
						_grounded = false;	
					}else {						
						_carrier.applyImpulse(new Vec2(0, -jump/15));	
					}
					
					
					
				}
				
			}
			
			if (particleSource.active) {
				particleSource.x = _carrier.position.x;
				particleSource.y = _carrier.position.y + 25;
			}
			
			
			
		}
		
		public function updateParams():void 
		{
			speed_m = SkillList.speed_m;
		}
		
		public function get grounded():Boolean 
		{
			return _grounded;
		}
		
		public function set grounded(value:Boolean):void 
		{
			_grounded = value;
		}
		
	}

}