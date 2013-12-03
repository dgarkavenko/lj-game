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
		
		public var tasks:Vector.<Task> = new Vector.<Task>();
		
		public function BaseContract(initTime:int, term_:int, achievement:Boolean) 
		{
			startsFrom = initTime;
			term = term_;
			isAchievement = achievement;			
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
		
		public function progress():void 
		{
			
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