package dynamics.enemies.implement 
{
	import dynamics.actions.ActionTypes;
	import dynamics.actions.IAction;
	import dynamics.BaseSpriteControl;
	import dynamics.Collision;
	import dynamics.enemies.base.Ranged;
	import dynamics.enemies.base.Dummy;
	import dynamics.enemies.implement.spitter.GooProjectile;
	import idv.cjcat.emitter.ds.MotionData2DPool;

	import dynamics.GameCb;
	import dynamics.interactions.IInteractive;
	import dynamics.Walker;
	import flash.display.MovieClip;
	import flash.events.Event;
	import gui.Bars.HealthBarCache;
	import gui.Bars.SimpleBar;
	import nape.geom.Vec2;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import utils.SimpleCache;

	
	/**
	 * ...
	 * @author DG
	 */
	public class Spitter extends Ranged
	{
		
			
		
		private var ite:int = 0;
	
		
		
		public function Spitter() 
		{			
			super("spitter");				
					
		}
		
		override protected function launchProjectile(e:Event = null):void 
		{
			var d:int = 1;
			if (daddy.lumbervec.x < _body.position.x) d = -1;			
			facing = d;
			
			
			
			var p:GooProjectile = GooProjectile.cache.getInstance() as GooProjectile;	
			
			
			var rot:Number = Math.PI / 2 - Math.PI / 2 * d;			
			
			
			p.add(rot);			
			p.getBody().position = _body.position.add(Vec2.get(10 * d, - 15));
			p.getBody().velocity.setxy(2.7 * Vec2.distance(_body.position, daddy.lumbervec), 0);
			p.getBody().velocity.angle = rot;		
			
			super.launchProjectile(e);
		}
		
		
		
		
		override public function tick():void {
			super.tick();
			
			
			if (isDead) return;
			
			if (++ite >= 10) {
				
				getConditions();			
				if (_currentShedule != null && _currentShedule.isCompleted(_conditions))
				{
					selectNewSchedule();
				}
				
				ite = 0;
				
			}
			
				
			
			if (_currentShedule != null) {
				_currentShedule.update();
			}
			
		}
		
	}

}