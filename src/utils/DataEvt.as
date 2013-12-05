package utils 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author DG
	 */

	public class DataEvt extends Event {
		
		public var data:Object;
		
		public function DataEvt(type:String,data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			this.data = data;
		} 
		
		public override function clone():Event { 
			return new DataEvt(type,data, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("DataEvt", "type", "data","bubbles", "cancelable", "eventPhase"); 
		}
		
	}

}