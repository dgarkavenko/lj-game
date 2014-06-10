package fx.v 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import idv.cjcat.emitter.Emitter;
	import idv.cjcat.emitter.ParticleSource;
	import utils.SimpleCache;
	import visual.Explosion_mc;
	/**
	 * ...
	 * @author DG
	 */
	public class VisualEffects 
	{
		
		public var emitter:Emitter = new Emitter();
		public var sawdust:Sawdust = new Sawdust(emitter);
		public var blood:Blood = new Blood(emitter);
		public var goo:Goo = new Goo(emitter);
		public var gooPuddle:GooPuddle = new GooPuddle(emitter);
		public var dust:Dust = new Dust(emitter);
		
		public var explosions:SimpleCache = new SimpleCache(Explosion_mc, 1);
		
		public function addExplosion(x:int, y:int, parent:DisplayObjectContainer):void {
			var e:Explosion_mc = explosions.getInstance() as Explosion_mc;
			parent.addChild(e);
			e.x = x;
			e.y = y;
			e.addEventListener("fin", animationEnd);
			e.gotoAndPlay(1);
			
			
		}
		
		private function animationEnd(e:Event):void 
		{
			var explosionmc:Explosion_mc = e.currentTarget as Explosion_mc;
			explosionmc.parent.removeChild(explosionmc);
			explosions.setInstance(explosionmc);
			explosionmc.removeEventListener("fin", animationEnd);
			explosionmc = null;
			
		}
		
		public function step():void 
		{
			emitter.step();
		}
		
		public function clear():void 
		{
			emitter.clear();
		}
		
	}

}