package gameplay.contracts 
{
	import flash.events.EventDispatcher;
	import gamedata.DataSources;
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
			parseContracts();
			trace(contracts);
		}
		
		private function parseContracts():void 
		{
			var a:Array = DataSources.instance.getList("contracts");
			for each (var c:Object in a ) 
			{
				var contract:BaseContract = new BaseContract(c.starts, c.term, "constant" in c);
				if ("location" in c) contract.location = a.location;				
				contracts.push(contract);
				
				var ts:Array = a.tasks;
				
				for each (var t:Object in ts) 
				{
					var task:Task = new Task(t.count, contract);
					
					switch (t.type) 
					{
						case "hunt":
							task.type = TaskType.hunt;
						break;
						case "chop":
							task.type = TaskType.chopping;
						break;
						default:
					}
					
					if ("killedby" in t) {
						task.killedBy = t.killedby;
					}
					
					if ("targets" in t) {
						task.targets = t.targets;
					}
					
					if ("time" in t) {
						
					}
					
					contract.tasks.push(task);
				}
				
				
			}
		}
		
		public function progress(taskType:TaskType, params:Object):void {
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
				
			}
			
		}
		
		private function checkComplete():void 
		{
			var ln:int = current.length;
			
			for (var i:int = ln - 1; i >= 0; i--) 
			{
				if (current[i].isDone) {
					var complete:BaseContract = current.splice(i, 1)[0];
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
			for (var i:int = ln - 1; i >= 0; i--) 
			{
				if (contracts[i].startsFrom == time) {
					for each (var item:Task in contracts[i].tasks) 
					{
						currentTasks.push(item);
					}
					
					current.push(contracts.splice(i, 1)[0]);
					
				}
			}
			
			trace(current);
			//Expired contracts
			var ln2:int = current.length;
			for (var j:int = ln2 - 1; j >= 0; j--) 
			{
				
				if (current[j].expired(time)) {					
					current.splice(j, 1);					
				}
			}
			
			trace(current);
		}
		
		
		
		
		
	}

}