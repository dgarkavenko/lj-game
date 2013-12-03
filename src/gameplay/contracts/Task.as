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
			if (count == targetCount) {
				isDone = true;
				contract.progress();
			}
		}
		
		public function reset():void {
			count = 0;
		}
		
		public function resetDaily():void {
			count -= sinceMorning;
			sinceMorning = 0;
		}
		
	}

}