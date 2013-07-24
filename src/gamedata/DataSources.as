package gamedata
{
	import flash.net.SharedObject;
	
	/**
	 * Синглтон содержащий всех дата киперов.
	 * @author DG
	 */
	public class DataSources 
	{
		
		private static var _inst:DataSources;
		private var lumber:LumberKeeper;
	
	
		
		public function DataSources(e:SingletonEnforcer) 
		{
			trace("Sources on");
			lumber = new LumberKeeper("ljack", 0);
		}			
		
		public static function get instance():DataSources
		{		
			if (_inst == null) {
				_inst = new DataSources(new SingletonEnforcer());
			}			
			return _inst;			
		}		
		
		public static function get lumberkeeper():LumberKeeper 
		{
			return instance.lumber;
		}
	
	}

}

class SingletonEnforcer{
//nothing else required here
}