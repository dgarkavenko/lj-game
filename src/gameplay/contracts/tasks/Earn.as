package gameplay.contracts.tasks 
{
	import gameplay.contracts.Task;
	import utils.GlobalEvents;
	/**
	 * ...
	 * @author DG
	 */
	public class Earn extends Task
	{
		
		public function Task(howmuch_:int) 
		{
			howMuch = howmuch_;
			event = GlobalEvents.MONEY_EARNED;
		}
		
		override public function ProgressIfMatch(data:Object):Boolean 
		{				
			if (data.cash >= howMuch) return true;	
		}
		
	}

}