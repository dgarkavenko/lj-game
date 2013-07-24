package fx.v
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import idv.cjcat.emitter.Emitter;
	import idv.cjcat.emitter.geom.Vector2D;
	import idv.cjcat.emitter.PointSource;
	import nape.phys.Body;
	import nape.space.Space;
	import utils.SimpleCache;
	
	/**
	 * ...
	 * @author DG
	 */
	public class Sawdust
	{
		
		private var emitter:Emitter;
		//private var sources:SimpleCache= new SimpleCache(PointSource, 1);	
		private var source:PointSource = new PointSource();
		private var particle:SawdustParticle = new SawdustParticle();	
		
		public function Sawdust(emi:Emitter) {		
			
			emitter = emi;			
			source.addParticle(particle);
			source.active = false;			
			emitter.addSource(source);
		}
		
		public function at(x:int, y:int, dir:int, pow:int):void {
			particle.direction.x = dir;
			source.burst(pow / 2, 1);
			source.x = x;
			source.y = y;
			
		}	
		
	}

}