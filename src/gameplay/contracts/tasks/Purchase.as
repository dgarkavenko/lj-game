package gameplay.contracts.tasks 
{
	import gameplay.contracts.Task;
	import utils.GlobalEvents;
	/**
	 * ...
	 * @author DG
	 */
	public class Purchase extends Task
	{
		
		public function Purchase(types:uint, howmuch_:int) 
		{
			targets = types;
			howMuch = howmuch_;
			event = GlobalEvents.PURCHASE;
		}
		
		override public function ProgressIfMatch(data:Object):Boolean 
		{	
			trace(targets);
			trace(data.type);
			
			if (!MatchType(data.type)) return isDone;			
			progress("val" in data? data.val : 1);			
			return isDone;			
		}
		
	}

}