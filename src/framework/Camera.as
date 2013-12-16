package framework 
{
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import framework.input.Controls;
	/**
	 * ...
	 * @author DG
	 */
	public class Camera 
	{
		
		
		private var _minX:Number = Game.SCREEN_HALF_WIDTH;
		private var _minY:Number = 0;
		private var _maxX:Number = GameWorld.WORLD_SIZE_X - Game.SCREEN_HALF_WIDTH;
		private var _maxY:Number = 0;
		
		
		private var _locationWidth:int;
		
		private var _layers:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		private var _difference:Vector.<Number> = new Vector.<Number>();
		

		
		private var moveY:Boolean = false;
		private var moveX:Boolean = false;
		
		private var container:Sprite;
		
		public function setMax(max:int):void {
			_maxX = - Game.SCREEN_HALF_WIDTH + max;
		}
		
		
		
		//Wiggle
		private var wig_dx:int;
		private var wig_dy:int;
		private var wig_timer:Timer = new Timer(0, 1);
		
		private var wig_X:Number = 0;
		private var wig_Y:Number = 0;
		
		public function Camera() 
		{
			container = GameWorld.container;					
			wig_timer.addEventListener(TimerEvent.TIMER, wig);
			wig_timer.addEventListener(TimerEvent.TIMER_COMPLETE, wig_complete);
			
			if (!container) trace("Камера была создана раньше мира, лох");
			
			
		}
		
		private function wig_complete(e:TimerEvent):void 
		{
			wig_X = 0;
			wig_Y = 0;
		}		
		
		public function wiggle(dx:int, dy:int, rate:int, time:Number):void {
			wig_dx = dx;
			wig_dy = dy;
			
			wig_timer.reset();
			wig_timer.delay = 1 / rate;		
			wig_timer.repeatCount = time * rate;
			
			wig_timer.start();
		}
		
		private function wig(e:TimerEvent):void {
			wig_X = -wig_dx + 2 * Math.random() * wig_dx;
			wig_Y = -wig_dy + 2 * Math.random() * wig_dy;
		}
		
		
		
		public function controlBgLayer(layer:DisplayObject):void {
			
			if (layer.width < Game.SCREEN_WIDTH) {
				trace("Слишком маленький слой БГ, надо шире ");
			}			
			
			var diff:Number = layer.width - Game.SCREEN_WIDTH;			
			_difference.push(diff);			
			_layers.push(layer);
		
		}
		
		public function pan_H(X:Number, boundings:Boolean = true):void {
			
			
			if ( X > _maxX ) container.x = Game.SCREEN_HALF_WIDTH - _maxX;
			else if (X < _minX) container.x = Game.SCREEN_HALF_WIDTH - _minX;
			else {
				
				container.x = Game.SCREEN_HALF_WIDTH - X;
				for (var i:int = 0; i < _layers.length; i++) 
				{	
					_layers[i].x = (_difference[i]) * container.x / (GameWorld.WORLD_SIZE_X - Game.SCREEN_WIDTH);				
				}
			}
				
			container.x += wig_X;
			container.y = wig_Y;
			
		}
		
		public function pan(X:Number, Y:Number, boundings:Boolean = true):void {
			
			if ( (X < _maxX && X > _minX ) || !boundings) {				
				
				moveX = true;
				GameWorld.container.x = Game.SCREEN_HALF_WIDTH - X;
				
			}else {
				moveX = false;
			}
			
			if ((Y > _minY && Y < _maxY )|| !boundings) {
				
				moveY = true;
				GameWorld.container.y = Game.SCREEN_HALF_HEIGHT - Y;
				
			}else {
				moveY = false;
			}
			
			/*if (!moveX && !moveY) return;
			
			for (var i:int = 0; i < _layers.length; i++) 
			{
				
				var k:Number = .8 - i * .2;
				
				if (moveX) _layers[i].x = _offset_x[i] + X * k;
				if (moveY) _layers[i].y = -300 + Y * k;
			}*/
			
			
		}
		
		public function setBoundings(minX:int, maxX:int, minY:int, maxY:int):void 
		{
			_minX = minX; 	_minY = minY;	_maxX = maxX;	_maxY = maxY;
		}
		
		public function get locationWidth():int 
		{
			return _locationWidth;
		}
		
		public function set locationWidth(value:int):void 
		{
			_locationWidth = value;
			_maxX = _locationWidth - Game.SCREEN_HALF_WIDTH;
		}
		
	}

}