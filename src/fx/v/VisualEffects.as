package fx.v 
{
	import idv.cjcat.emitter.Emitter;
	import utils.SimpleCache;
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
		
		
		
		public function step():void 
		{
			emitter.step();
		}
		
	}

}