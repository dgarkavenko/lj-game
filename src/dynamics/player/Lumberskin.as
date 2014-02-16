package dynamics.player 
{
	import dynamics.BaseSpriteControl;
	import flash.filters.GlowFilter;
	import framework.input.Controls;
	import nape.geom.Vec2;
	
	/**
	 * ...
	 * @author DG
	 */
	public class Lumberskin extends BaseSpriteControl
	{	
		private var state:String = "";		
		
		public function Lumberskin() 
		{
			
			super(Lumberjack_mc);	
			_facing = 1;
			idle();			
		}
		
		override public function idle():void {
			
			if (state == "idle") return;
			
			
			state = "idle";			
			_sprite.gotoAndStop("stand");
			_sprite.body_bg.y = _sprite.body.y = 10;
			
		}
		
		public function turnLegs(dir:int):void {
			_sprite.legs.scaleX = dir * _facing;
		}
		
		override public function battleroll(b:Boolean):void {
			
			if (!b) {
				_sprite.body.visible = true;
			}else {
				if (state == "roll") return;
				state = "roll";
				_sprite.gotoAndStop("roll");
				_sprite.body.visible = false;
			}
			
			
		}
		
		override public function walk():void {
			
			
			
			
			if (state != "run") {
				_sprite.gotoAndStop("run");
				state = "run";
			}
			
			var Y:int = -30;		
			
			//Body Y position depending on legs
			switch (_sprite.legs.currentFrame) 
			{				
				case 1: case 2: Y = -29; break;
				case 3: case 4: Y = -30; break;
				case 5: case 6: Y = -32; break;
				case 7: case 8: Y = -31; break;
				case 9:	case 10: Y = -30; break;
				case 11: case 12: Y = -28; break;
				case 13: case 14: Y = -29; break;
				case 15: case 16: Y = -31; break;
				case 17: case 18: Y = -32; break;
				case 19: case 20: Y = -31; break;
				case 21: case 22: Y = -30; break;
				case 23: case 24: Y = -27; break;				
				default: Y = -30;
			}			
			
			_sprite.body.y = _sprite.body_bg.y = Y + 42;
		}
		
		override public function jump():void {		
			
			if (state == "jump") return;			
			state = "jump";
			_sprite.gotoAndStop("jump");
			_sprite.body_bg.y = _sprite.body.y = 12;			
			
		}
		
		public function shot(melee:Boolean = false):void {
			if (melee) {
				_sprite.body.arms.play();
			}else {
				_sprite.body.arms.fire.play();
			}
		}
		
		
		public function dead():void {
			_sprite.gotoAndStop(3);
		}
		
		public function get gunpoint():Vec2 {			
			return Vec2.get(_sprite.body.arms.gunpoint.x, _sprite.body.arms.gunpoint.y);
		}
		
		public function weaponchange(wp:String):void {
			_sprite.body.gotoAndStop(wp);
			
			if (_sprite.body.arms) _sprite.body.arms.stop();
			if (_sprite.body.arms.fire) _sprite.body.arms.fire.gotoAndStop(2);
		}
		
		public function swing():void 
		{
			_sprite.body.arms.gotoAndPlay(2);
		}
		
	}

}