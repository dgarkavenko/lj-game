package framework
{
	
	import flash.net.SharedObject;
	import gamedata.IKeeper;
	/**
	 * ...
	 * @author DG
	 */
	public class SharedObjectShell
	{
		private static var _inst:SharedObjectShell;
		private var storage:SharedObject;
		
		public function SharedObjectShell(e:SingletonEnforcer) 
		{
			trace("Long life SharedObjectShell Singleton!");
			storage = SharedObject.getLocal("lolobj");
		}			
		
		public static function get instance():SharedObjectShell
		{		
			if (_inst == null) {
				_inst = new SharedObjectShell(new SingletonEnforcer());
			}
			
			return _inst;			
		}
		
		/**
		 *  Сохранить данные из одного из keeper в локальный объект
		 */
		public function push(keeper:IKeeper):void {			
			storage.data[keeper.name] = keeper.pack();
			storage.flush();			
			
			trace("---Flushed params---");
			for (var key:String in storage.data[keeper.name]) trace(key + ":" + storage.data[keeper.name][key]);
			trace("----------------------\n");
			
		}
		
		/**
		 *  Попробовать забрать сохранение с локального объекта
		 */
		public function pull(name:String):Object 
		{
			if (storage.size == 0) return null;
			if (!storage.data.hasOwnProperty(name)) return null;
			return storage.data[name];
		}
		
		public function clear():void 
		{
			storage.clear();
		}
		
		
		/**
		 * Есть ли дата какая в сэйве
		 */
		public function has():Boolean 
		{
			return storage.size > 0;
			//TODO реализовать проверку на то, нормальная ли это да та?
		}
		
	
	}

}

class SingletonEnforcer{
//nothing else required here
}