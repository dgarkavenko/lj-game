package utils 
{
	/**
	 * ...
	 * @author DG
	 * 
	 */
	public class SimpleCache 
	{
		
		protected var _currentIndex:int = 0;
		protected var _class:Class;
		protected var _instances:Array;
		
		public function get length():int {
			return _instances.length;
		}
		
		public function get unbound():int {
			return _currentIndex + 1;
		}
		
		public function SimpleCache(targetClass:Class, initialAmount:int = 1) 
		{
			_instances = new Array();
			_currentIndex = initialAmount - 1;
			_class = targetClass;
			for (var i:int = 0; i < initialAmount; i++) _instances.push(getNewInstance());
			
		}
		
		protected function getNewInstance():Object {			
			return new _class();
		}
		
		public function getInstance():Object {
		
			if (_currentIndex >= 0)	return _instances[_currentIndex--];
			else return getNewInstance();
		}
		
		public function setInstance(inst:Object):void {
			
			_instances[++_currentIndex] = inst;
		}
		
	}

}