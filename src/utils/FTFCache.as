package utils 
{
	import framework.FormatedTextField;
	/**
	 * ...
	 * @author DG
	 */
	public class FTFCache extends SimpleCache
	{
		
		private var _fontSize:int = 14;
		
		public function FTFCache(targetClass:Class, initialAmount:int = 1, fontSize:int = 14) 
		{
			_fontSize = fontSize;
			super(targetClass, initialAmount);
		}
		
	
		
		override protected function getNewInstance():Object {	
			
			var b:FormatedTextField = new FormatedTextField(_fontSize);						
			return b;
		}
		
	}

}