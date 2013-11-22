package gui.Bars 
{
	import utils.SimpleCache;
	/**
	 * ...
	 * @author DG
	 */
	public class HealthBarCache extends SimpleCache
	{
		
		public function HealthBarCache(initialAmount:int = 1) 
		{
			super(SimpleBar, initialAmount);
		}
		
		override protected function getNewInstance():Object {	
			
			return (new SimpleBar(22,4,0xd60000, false, 0x505050, 1));			
			
		}
		
	}

}