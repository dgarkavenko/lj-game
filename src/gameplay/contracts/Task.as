package gameplay.contracts 
{
	import dynamics.player.weapons.WeaponData;
	import gameplay.ZombieTypes;
	/**
	 * ...
	 * @author dg
	 */
	public class Task 
	{
	
		public var contract:BaseContract;
		
		public var type:TaskType;
		
		public var targets:Array = [];		
		public var killedBy:int = -1;		
		public var dayTime:int = -1;
		
		
	
		
		public var targetCount:int = 5;
		
		public var count:int = 0;
		public var sinceMorning:int = 0;
		
		public var isDone:Boolean = false;
		
		public function Task(count_:int, contract_:BaseContract) 
		{
			targetCount = count_;
			contract = contract_
		}
		
		public function progress(a:int = 1):void {
			
			
			count += a;
			
			trace("Task progress: " + count + "/" + targetCount );
			
			
			
			if (count == targetCount) {
				isDone = true;		
				trace("Task complete");
			}
			
			
		}
		
		public function reset():void {
			count = 0;
		}
		
		public function resetDaily():void {
			count -= sinceMorning;
			sinceMorning = 0;
		}
		
		public function ProgressIfMatch(data:Object):Boolean 
		{
			
			if (!MatchType(data.type)) return isDone;
			if (killedBy != -1 && data.how != killedBy) return isDone;
			if (dayTime != -1 && dayTime != GameWorld.time.daytime) return isDone;
			
			progress("val" in data? data.val : 1);			
			return isDone;
			
		}
		
		public function MatchType(type:int):Boolean {
			
			if (targets.length == 0) return true;
			
			for each (var t:int in targets) 
			{
				if (t == type) return true;
			}
			
			return false;
		}
		
	}

}