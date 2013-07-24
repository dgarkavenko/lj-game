package fx.v 
{
	import idv.cjcat.emitter.Emitter;
	/**
	 * ...
	 * @author DG
	 */
	public class VisualEffects 
	{
		
		public var emitter:Emitter = new Emitter();
		public var sawdust:Sawdust = new Sawdust(emitter);
		public var blood:Blood = new Blood(emitter);
		
		public function step():void 
		{
			emitter.step();
		}
		
	}

}