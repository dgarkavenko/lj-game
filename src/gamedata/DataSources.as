package gamedata
{
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import utils.GlobalEvents;
	
	/**
	 * Синглтон содержащий всех дата киперов.
	 * @author DG
	 */
	public class DataSources 
	{
		
		private static var _inst:DataSources;
		private var lumber:LumberKeeper;
	
		
		private var _JSONLoader:URLLoader;
		private var _JSONEncoded:Object;
		
		
		public function DataSources(e:SingletonEnforcer) 
		{
			trace("Sources on");
			lumber = new LumberKeeper("ljack", 0);		
			loadJSON("swfbuilds/config.txt");
			//loadJSON("http://lumberjack.rawapps.ru/swfbuilds/config.txt");
		}			
		
		private function loadJSON(fileName:String):void {			
				
			_JSONLoader = new URLLoader();
			_JSONLoader.addEventListener(Event.COMPLETE, loadComplete);
			_JSONLoader.load(new URLRequest(fileName));	
			
		}
		
		private function loadComplete(e:Event):void 
		{
			_JSONEncoded = JSON.parse(e.target.data);
			_JSONLoader.removeEventListener(Event.COMPLETE, loadComplete);
			_JSONLoader = null;		
			$GLOBAL.dispatch(GlobalEvents.LOADED_CONFIG);
		}
		
		public function getReference(alias:String):Object 
		{
			trace("DataSources: Getting ref for " + alias);  
			return _JSONEncoded[alias];
		}
		
		public function getList(alias:String):Array
		{
			trace("DataSources: Getting list for " + alias);  
			return _JSONEncoded[alias];			
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