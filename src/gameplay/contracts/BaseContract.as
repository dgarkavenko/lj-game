package gameplay.contracts 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author dg
	 */
	public class BaseContract
	{		
		public var startsFrom:int;
		public var term:int;
		public var isAchievement:Boolean;
		public var location:uint = 0;
		public var read:Boolean = false;
		public var title:String = "Contract";
		public var dsc:String = "Do something";
		public var reward_size:int = 0;
		public var flag:uint = 0;
		
		public var tasks:Vector.<Task> = new Vector.<Task>();
		
		public function BaseContract() 
		{
			
		}
		
		public function reset():void 
		{
			
		}
		
		public function get isDone():Boolean 
		{
			for each (var item:Task in tasks ) 
			{
				if (!item.isDone) return false;
			}			
			return true;
		}	
		
		public function reward():void 
		{
			
		}
		
		public function expired(time:int):Boolean 
		{
			return time >= startsFrom + term && !isAchievement;
		}
		
	}

}