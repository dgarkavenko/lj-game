package dynamics.player 
{
	import dynamics.GameCb;
	import dynamics.WorldObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	import framework.input.Controls;
	import framework.input.Keyboard;

	import framework.screens.GameScreen;
	import gamedata.DataSources;
	import gameplay.SkillList;

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

		private var lumberjack:Lumberjack;
		private var locked_x:Number = NaN;
		private var _grounded:Boolean = true;
		public var doublejump:Boolean = false;

		
		public var jump:int = 125;
		public var walk:int = 90 * 1;
		public var zombieCollision:int = 0;
		public var zombiecontact:Boolean = false;
		public var onMove:Function;
		private var speed_m:Number = 1;
		
		private var stuckX:Number = NaN;
		private var deep:int = 0;
		private var view:Lumberskin;
		
		//private var moveEvent:Event = new Event("onMove");
		
		private var particleSource:PointSource = $VFX.dust.step;
		
		
		private var slick:Boolean = false;
	

		
		public function Movement(lj:Lumberjack) 
		{
			lumberjack = lj;
			_carrier = lj.getBody().castBody;
			view = lumberjack.view as Lumberskin;
			
			var groundListener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, GameCb.LEGS, GameCb.GROUND.including([GameCb.TRUNK]), groundHandler);
			
			var midAirListener:InteractionListener = new InteractionListener(CbEvent.END, InteractionType.COLLISION, GameCb.LEGS, GameCb.GROUND.including([GameCb.TRUNK]), midAirHandler);

			midAirListener.space = groundListener.space = _carrier.space;
		}
		
		public function stuck(deep_:int):void{
			stuckX = _carrier.position.x;
			deep = deep_/2;
		}
		
		private function groundHandler(cb:InteractionCallback):void 
		{
			_grounded = true;
			if (SkillList.isLearned(SkillList.DOUBLE_JUMP)) doublejump = true;			
			if (cb.int2.cbTypes.has(GameCb.GROUND)) {
				$VFX.dust.at(_carrier.position.x, _carrier.position.y + 27);
				_carrier.velocity.y = 0;
				
			}		
			
			zombiecontact = false;
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
		
		private function walkThisWay(dir:int):void 
		{
			
			if (onMove != null) onMove();
			
			var currentSpeed:Number = slick ? walk : walk / (1 + zombieCollision / 3);	
			
			
			view.turnLegs( dir);
			
			
			_carrier.applyImpulse(new Vec2(currentSpeed * dir, 0));
			if (_grounded) {
				view.walk();		
				if (slick) particleSource.active = true;
			}
			
			
		}
		
		
		public function tick():void {			
			
			
			
			_carrier.velocity.x = 0;
			
			
			if (isNaN(stuckX)) {
				
				if (keys.pressed("A") || keys.pressed("LEFT")) {
					
					walkThisWay( -1);
				
				
				}else if (keys.pressed("D") || keys.pressed("RIGHT")) {
					
					walkThisWay(1);
					
					
				}else {
					
					particleSource.active = false;				
					if (_grounded) { lumberjack.view.idle();
					}else {
						lumberjack.view.jump();
					}
				}				
				
				if (keys.justPressed("W") || keys.justPressed("UP")) {				
					if (_grounded || doublejump) {
						
						//grounded = false;	
						if (_grounded == false) {
							doublejump = false;
							_carrier.velocity.y = 0;
							
							if (!zombiecontact) $VFX.dust.at(_carrier.position.x, _carrier.position.y + 27, 25);
							else $VFX.blood.at(_carrier.position.x, _carrier.position.y + 27, 0, -1, 5);
						}
						
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
			if (SkillList.isLearned(SkillList.SLICK)) {
				slick = true;
				walk = 110;
			}			
			if (SkillList.isLearned(SkillList.DOUBLE_JUMP) && grounded) doublejump = true;
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