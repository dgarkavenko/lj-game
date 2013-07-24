package gameplay 
{
	/**
	 * ...
	 * @author DG
	 */
	public class GoalTracker 
	{
		
		
		private static var _inst: GoalTracker;	
		private var goals:Vector.<Goal>;
		public var currentGoalIndex:int = 0;
		
		
		
		public function GoalTracker(e:SingletonEnforcer) 
		{
			trace("GoalTracker on");	
			goals = new Vector.<Goal>();
			
		}
		
		static public function get inst():GoalTracker 
		{
			if (_inst == null) {
				_inst = new GoalTracker(new SingletonEnforcer());
			}			
			return _inst;
		}
		
		public function updateGoals():void {
			
			if (currentGoalIndex > goals.length - 1) return;
			
			if (goals[currentGoalIndex].completeCallback() >= 1) {
				
				trace("GOAL COMPLETED");
				if (goals[currentGoalIndex].onComplete != null) goals[currentGoalIndex].onComplete();
				currentGoalIndex++;
				
				if (currentGoalIndex > goals.length - 1) {
					trace("GAME OVER");
				}
			}
		}
		
		public function addGoal(g:Goal):void {			
			goals.push(g);
		}
		
		
		
	}
	
	
	
}

class SingletonEnforcer{
	//nothing else required here
	}
