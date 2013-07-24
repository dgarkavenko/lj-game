package gamedata 
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	import framework.SharedObjectShell;
	/**
	 * ...
	 * @author DG
	 */
	public class GameKeeper extends EventDispatcher implements IKeeper
	{
		
		protected var _name:String;		
		protected var shell:SharedObjectShell;
		//protected var load_data:Object;
		
		public function GameKeeper(a:String, autosave:int = 0) 
		{
			_name = a;
			shell = SharedObjectShell.instance;
			
			if (autosave > 0) {
				var savetimer:Timer = new Timer(autosave, 0);
				savetimer.addEventListener(TimerEvent.TIMER, save);
				savetimer.start();
			}
			
		}
		
		public function get name():String {
			return _name
		}	
		
		/**
		 * Сохраняем данные текущего Storage'a
		 */
		public function save(e:TimerEvent = null):void {
			shell.push(this);
		}		
			
		/**
		 * Получаем данные для текущего Storage'a
		 */
		protected function load():void {
			
			var load_data:Object = shell.pull(_name)
			if (load_data != null) extract(load_data);
		}
		
		
		/**
		 * For override 
		 */
		public function pack():Object {
			throw("GameKeeper.pack() must be overriden");
			return { };
		}
		
		/**
		 * For override 
		 */
		public function extract(load_data:Object):void {
			throw("GameKeeper.extract() must be overriden");
		}
		
	
	}

}