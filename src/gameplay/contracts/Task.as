package gameplay.contracts 
{
	import dynamics.player.weapons.WeaponData;
	import gameplay.KilledBy;
	import gameplay.ZombieTypes;
	import utils.GlobalEvents;
	/**
	 * ...
	 * @author dg
	 */
	public class Task 
	{
	
		public var contract:BaseContract;
		
		public var event:String = GlobalEvents.ZOMBIE_KILLED;
		
		public var targets:uint;		
		public var killedBy:uint = KilledBy.ANY;		
		public var dayTime:int = -1;
		
		
	
		
		public var howMuch:int = 5;
		
		public var count:int = 0;
		public var sinceMorning:int = 0;
		
		public var isDone:Boolean = false;
		
		public function Task() 
		{
			
		}
		
		public function progress(a:int = 1):void {
			
			
			count += a;
			
			trace("Task progress: " + count + "/" + howMuch );			
			
			if (count == howMuch) {
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
			if (!MatchKilledBy(data.how)) return isDone;
			
			progress("val" in data? data.val : 1);			
			return isDone;
			
		}
		
		private function MatchKilledBy(how:uint):Boolean 
		{
			if (killedBy == KilledBy.ANY || (killedBy & how) == how) return true;
			else return false;
		}
		
		public function MatchType(type:uint):Boolean {			
			if ((targets & type) == type) return true;
			else return false;
			
		}
		
	}

}