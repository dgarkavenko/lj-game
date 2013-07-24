package gameplay 
{
	import dynamics.interactions.PlayerInteractiveObject;
	/**
	 * ...
	 * @author DG
	 */
	public class Goal 
	{
		
		public var completeCallback:Function;
		private var subject:PlayerInteractiveObject;
		public var onComplete:Function;
		
		public function Goal(subject_:PlayerInteractiveObject, callback:Function, text:String) 
		{
			subject = subject_;
			completeCallback = callback;
			trace("NEW GOAL: " + text);
		}
		
	}

}