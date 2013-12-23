package fx.v 
{
	import idv.cjcat.emitter.Emitter;
	import idv.cjcat.emitter.Particle;
	import idv.cjcat.emitter.ParticleSource;
	import idv.cjcat.emitter.PointSource;
	/**
	 * ...
	 * @author DG
	 */
	public class BaseEffect 
	{
		
		protected var emitter:Emitter;
		
		public function BaseEffect(emi:Emitter, source:ParticleSource, particle:Particle) 
		{
			emitter = emi;			
			source.addParticle(particle);
			source.active = false;	
			emitter.addSource(source);
		}
		
	}

}