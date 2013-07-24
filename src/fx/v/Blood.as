package fx.v 
{
	import idv.cjcat.emitter.Emitter;
	import idv.cjcat.emitter.PointSource;
	/**
	 * ...
	 * @author DG
	 */
	public class Blood 
	{
		
		private var emitter:Emitter;		
		private var source:PointSource = new PointSource();
		private var particle:BloodParticle = new BloodParticle();	
		
		public function Blood(emi:Emitter) {	
			
			emitter = emi;			
			source.addParticle(particle);
			source.active = false;			
			emitter.addSource(source);
		}
		
		public function at(x:int, y:int, dx:int = 0, dy:int = -1, pow:int = 60):void {
			
			particle.direction.x = dx;
			particle.direction.y = dy;
			
			source.burst(pow, 2);
			source.x = x;
			source.y = y;
			
		}	
		
		
		
	}

}