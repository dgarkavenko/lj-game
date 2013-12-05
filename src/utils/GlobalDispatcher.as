package utils 
{
	import flash.events.EventDispatcher;

	
	/**
	 * ...
	 * @author dg
	 */
	
	
	 
	public class GlobalDispatcher
	{
		
		
		
		private static var _eventAssistant:EventDispatcher = new EventDispatcher();
		
		
		public function dispatch(event:String, data:Object = null):void {
			
			_eventAssistant.dispatchEvent(new DataEvt(event, data));
			
		}
		
		public function listenTo(event:String, listener:Function, weakRef:Boolean = false):void {
			_eventAssistant.addEventListener(event, listener, false, 0, weakRef);
		}
		
		public function dontListen(event:String, listener:Function):void {
			_eventAssistant.removeEventListener(event, listener);
		}		
		
		
	
	}
}