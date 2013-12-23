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
		private var particle:BloodParticle = new BloodParticle();	
		
		public static var NUMBER_OF_SOURCES:int = 3;
		public var sources:Vector.<PointSource> = new Vector.<PointSource>();		
		public var source2use:int = 0;
		
		public function Blood(emi:Emitter) {	
			
			emitter = emi;		
			
			for (var i:int = 0; i < NUMBER_OF_SOURCES; i++) 
			{
				var src:PointSource = new PointSource();
				src.addParticle(particle);
				src.active = false;
				emitter.addSource(src);
				sources.push(src);
			}
		}
		
		public function at(x:int, y:int, dx:int = 0, dy:int = -1, pow:int = 60):void {
			
			particle.direction.x = dx;
			particle.direction.y = dy;
			
			var src:PointSource = sources[source2use];
			src.burst(pow, 2);
			src.x = x;
			src.y = y;
				
			source2use++;
			if (source2use > NUMBER_OF_SOURCES - 1) source2use = 0;
			
			
		}	
		
		
		
		
		
	}

}