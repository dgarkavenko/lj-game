package utils 
{
	import dynamics.GameCb;
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	/**
	 * ...
	 * @author DG
	 */
	public class BodyCache extends SimpleCache
	{
		
		private var cb:CbType;
		
		public function BodyCache(targetClass:Class, initialAmount:int = 1, cbType:CbType = null) 
		{
			cb = cbType;
			super(Body, initialAmount);			
		}
		
		override protected function getNewInstance():Object {	
			
			var b:Body = new Body(BodyType.DYNAMIC, Vec2.get(0, 0));			
			if (cb != null) {
				b.cbTypes.add(cb);
			}
			return b;
		}
	}

}