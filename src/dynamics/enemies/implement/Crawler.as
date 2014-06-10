package dynamics.enemies.implement 
{
	import dynamics.BaseSpriteControl;
	import dynamics.enemies.base.Standart;
	import flash.events.Event;
	import gameplay.TreeHandler;
	import nape.geom.Vec2;
	import utils.GlobalEvents;
	import visual.z.CrawlerView;
	/**
	 * ...
	 * @author DG
	 */
	public class Crawler extends Standart
	{
		public function Crawler() 
		{
			super("crawler");
		}
		
		override protected function setView():void {		
			_view = new BaseSpriteControl(CrawlerView);		
		}
			
		override protected function reset():void {
			super.reset();
			grabbing = false;
		}
		
		override protected function onDeath():void {
			super.onDeath();
			if (grabbing) $GLOBAL.dispatch(GlobalEvents.ZOMBIE_HOLDING_DEAD, this );	
		}
		
		override protected function onAttackAnimation(e:Event):void 
		{			
			var viewDirTowardsLj:Boolean = (_facing == 1 && _body.position.x < daddy.lumbervec.x) || (_facing == -1 && _body.position.x > daddy.lumbervec.x);
			if (Math.abs(daddy.lumbervec.x - _body.position.x) <= meleeAttackRange && viewDirTowardsLj) {
				
				if (daddy.lumbervec.y > TEMP_TODO_GRAB_HEIGHT)grabbing = GameWorld.lumberjack.grab(facing, this);
				trace(daddy.lumbervec.y);
			}
			
			//TODO зачем я удаляю постоянно слуаштель и вешаю снова?
			if (_view.sprite.mc) _view.sprite.mc.removeEventListener("onAttack", onAttackAnimation);		
		}
		
		private var TEMP_TODO_GRAB_HEIGHT:int = 330;
		
		private var grabbing:Boolean = false;
		private var eat_distance:Number = 23;
		
		
		override protected function onMeleeAttack():Boolean 
		{			
			
			if (grabbing) {
				var d:int = daddy.lumbervec.x - _body.position.x;
				var cfcnt:int = d > 0? 1 : -1;
				trace(d);
				d = Math.abs(d);
				
				if (d > eat_distance) {
					_body.position.setxy(_body.position.x + 3 * cfcnt, _body.position.y);
				}else if (d < 12) {					
					_body.position.setxy(_body.position.x - 5 * cfcnt, _body.position.y);						
				}else {
					
					if (doBlood <= 0) {
						$VFX.blood.at(_body.position.x + cfcnt * 23, _body.position.y, 0, -1, 1);
						GameWorld.lumberjack.grab(0, this);
						doBlood = 5;
					}else {
						doBlood--;
					}
					
				}
				
			}
			
			return (_view.sprite.mc.currentFrame == _view.sprite.mc.totalFrames && !grabbing) ? true : false;
		}
		
		private var doBlood:int = 0;
		
		
	}

}