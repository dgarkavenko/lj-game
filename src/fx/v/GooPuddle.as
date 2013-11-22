package fx.v 
{
	import idv.cjcat.emitter.Emitter;
	import idv.cjcat.emitter.LineSource;
	import idv.cjcat.emitter.PointSource;
	/**
	 * ...
	 * @author DG
	 */
	public class GooPuddle 
	{
		
		private var emitter:Emitter;		
		private var source:LineSource = new LineSource(70);
		private var particle:GooParticle = new GooParticle();	
		
		public function GooPuddle(emi:Emitter) {	
			
			emitter = emi;			
			source.addParticle(particle);
			source.active = false;	
			emitter.addSource(source);
		}
		
		public function at(x:int, y:int, dx:int = 0, dy:int = 1, pow:int = 10):void {
			
			particle.direction.x = dx;
			particle.direction.y = dy;
			
			source.burst(pow, 2);
			source.x = x;
			source.y = y;
			
		}	
		
		
		
		
	}

}