package gameplay.contracts 
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author dg
	 */
	public class ContractHandler
	{
		
		private var contracts:Vector.<BaseContract> = new Vector.<BaseContract>();
		private var current:Vector.<BaseContract> = new Vector.<BaseContract>();
		
		
		private var currentTasks:Vector.<Task> = new Vector.<Task>();
		
		public function ContractHandler() 
		{
			
		}
		
		public function progress(taskType:int, params:Object) {
			if (taskType == TaskType.hunt) {
				hunted(params);
			}else if (taskType == TaskType.chopping) {
				chopped(params);
			}
		}
		
		private function chopped(params:Object):void 
		{
			
		}
		
		private function hunted(params:Object):void 
		{
			var who:int = params.type;
			var how:int = params.weapon;
			
			
			
			for each (var item:Task in currentTasks ) 
			{
				if (item.type != TaskType.hunt || item.isDone) continue;
				if (item.targettype == -1 || item.targettype == who) {					
					if (item.killedBy == -1 || item.killedBy == how) {
						if (item.dayTime == -1 || item.dayTime == GameWorld.time.daytime) {
							item.progress(1);
							checkComplete();
						}
					}
				}
			}
			
		}
		
		private function checkComplete():void 
		{
			var ln:int = current.length;
			
			for (var i:int = ln - 1; i >= 0; i--) 
			{
				if (current[i].isDone) {
					var complete:BaseContract = current.splice(i, 1);
					complete.reward();
					for each (var item:Task in complete.tasks ) 
					{
						removeTask(item);
					}
				}
			}
		}
		
		public function removeTask(item:Task):void {
			for (var i:int = 0; i < currentTasks.length - 1; i--) 
			{
				if (item == currentTasks[i]) currentTasks.splice(i, 1);
			}
		}
		
		
		
		public function timeUpdate(time:int):void 
		{
			//NEW Contracts
			var ln:int = contracts.length;			
			for (var i:int = 0; i < ln; i++) 
			{
				if (contracts[i].startsFrom == time) {
					for each (var item:Task in contracts[i].tasks) 
					{
						currentTasks.push(item);
					}
					
					current.push(contracts.splice(i, 1));
					ln--;
					i--;
				}
			}
			
			//Expired contracts
			var ln2:int = current.length;
			for (var j:int = 0; j < ln2; j++) 
			{
				if (current[j].startsFrom + current[j].term >= time) {
					if (current[j].isAchievement) {
						current[j].startsFrom = time;
						current[j].reset();
					}
					else {
						current.splice(j, 1);
						ln2--;
						j--;
					}
				}
			}
		}
		
		
		
	}

}