package dynamics 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author DG
	 */
	public class BaseSpriteControl 
	{
		//TODO PROTECT
		protected var _sprite:MovieClip;
		protected var _facing:int;
		
		public function BaseSpriteControl(cls:Class) 
		{
			_sprite = new cls();
			_sprite.stop();			
		}	
		
		
		public function walk():void {
			_sprite.gotoAndStop("walk");
		}
		
		public function attack():void {			
			_sprite.gotoAndStop("attack");
		}
		
		public function death():void {
			
			_sprite.gotoAndStop("death");
		}
		
		public function jump():void {
			_sprite.gotoAndStop("jump");
		}
		
		public function idle():void {
			_sprite.gotoAndStop("idle");
		}
		
		public function face(dir:int):void {	
			
			if ( _facing == dir) return;
			_facing = dir;
			_sprite.scaleX = dir;
		}
		
		public function rotation(degree:Number):void 
		{
			
			var f:int;
			f = degree / 13;			
			_sprite.body.arms.gotoAndStop(f);
		}
		
		public function bruteRotation(degree:Number):void 
		{
			var f:int;
			
			if (degree < 7.5) {
				f = 1;
			}else if (degree < 22.5) {
				f = 2;
			}else if (degree < 37.5) {
				f = 3;
			}else if (degree < 52.5) {
				f = 4;
			}else if (degree < 67.5) {
				f = 5;
			}else if (degree < 82.5) {
				f = 6;
			}else if (degree < 97.5) {
				f = 7;
			}else if (degree < 112.5) {
				f = 8;
			}else if (degree < 127.5) {
				f = 9;
			}else if (degree < 142.5) {
				f = 10;
			}else if (degree < 157.5) {
				f = 11;
			}else if (degree < 172.5) {
				f = 12;
			}else
				f = 13;		
			
			_sprite.body.arms.gotoAndStop(f);
		}
		
		public function get sprite():MovieClip 
		{
			return _sprite;
		}
		
		public function set sprite(value:MovieClip):void 
		{
			_sprite = value;
		}	
		
		
	}

}