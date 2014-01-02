package fx.v 
{
	import gamedata.DataSources;
	import idv.cjcat.emitter.Emitter;
	import idv.cjcat.emitter.LineSource;
	import idv.cjcat.emitter.PointSource;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author DG
	 */
	public class Dust extends BaseEffect
	{
		
		private var source:LineSource = new LineSource(10);
		private var point:PointSource = new PointSource();
		
		public var step:PointSource = new PointSource();
		
		private var p:DustParticle = new DustParticle();
		private var dirt:DirtParticle = new DirtParticle();
		public function Dust(emi:Emitter) 
		{
			super(emi, source, dirt);
			
			
			point.addParticle(p);
			point.active = false;
			emi.addSource(point);
			
		
			step.active = false;
			emi.addSource(step);
			step.addParticle(dirt);
			
		}
		
		public function shot(x:int, y:int):void {
			point.x = x;
			point.y = y;
			point.burst(5);
		}
		
		public function at(x:int, y:int, powah:int = 100):void {
			source.x = x;
			source.y = y;
			source.burst(powah);
		}
	
		
	
		
		
	}

}