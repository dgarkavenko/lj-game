package gameplay.contracts 
{
	import flash.events.EventDispatcher;
	import gamedata.DataSources;
	import utils.DataEvt;
	import utils.GlobalEvents;
	/**
	 * ...
	 * @author dg
	 */
	public class ContractHandler
	{
		
		private var contracts:Vector.<BaseContract> = new Vector.<BaseContract>();
		private var current:Vector.<BaseContract> = new Vector.<BaseContract>();
		
		
		
		
		
		private var huntTasks:Vector.<Task> = new Vector.<Task>();
		private var chopTasks:Vector.<Task> = new Vector.<Task>();
		
		private var temporaryComplete:Array = [];
		
		
		private function AddContract(cntrct:BaseContract):void {
			for each (var t:Task in cntrct.tasks ) 
			{
				if (t.type == TaskType.hunt) {
					huntTasks.push(t);
				}else if (t.type == TaskType.chopping) {
					chopTasks.push(t);
				}
			}
			
			current.push(cntrct);
		}
		
		private function RemoveContract(cntrct:BaseContract):void {
			for each (var t:Task in cntrct.tasks ) 
			{
				if (t.type == TaskType.hunt) {
					for (var i:int = huntTasks.length - 1; i >= 0 ; i--) 
					{
						if (huntTasks[i] == t) huntTasks.splice(i, 1);
					}
					
				}else if (t.type == TaskType.chopping) {
					for (var j:int = chopTasks.length - 1; j >= 0 ; j--) 
					{
						if (chopTasks[j] == t) chopTasks.splice(j, 1);
					}
				}
			}
		}
		
		
		
		public function ContractHandler() 
		{
			
			$GLOBAL.listenTo(GlobalEvents.ZOMBIE_KILLED, onZombieKill);
			$GLOBAL.listenTo(GlobalEvents.TREE_CUT, onTreeCut);			
			
			parseContracts();
			trace(contracts);
		}
		
		private function onTreeCut(e:DataEvt):void 
		{
			for each (var task:Task in chopTasks ) 
			{
				if (task.isDone) continue;
				if (task.ProgressIfMatch(e.data) && task.contract.isDone) {
					trace("Contract complete");
					temporaryComplete.push(task.contract);
				}
			}
			
			reward();
		}
		
		private function reward():void {
			
			for (var i:int = 0; i < temporaryComplete.length; i++) 
			{
				complete(temporaryComplete[i]);
			}
			
			temporaryComplete.length = 0;
		}
		
		private function onZombieKill(e:DataEvt):void 
		{			
			for each (var task:Task in huntTasks ) 
			{
				if (task.isDone) continue;
				if (task.ProgressIfMatch(e.data) && task.contract.isDone) {
					trace("Contract complete");
					temporaryComplete.push(task.contract);
				}
			}
			
			reward();
			
		}
		
		private function complete(complete:BaseContract):void 
		{
			for (var i:int = current.length - 1; i >= 0; i--) 
			{
				if (complete == current[i]) {
					current.splice(i, 1);
					RemoveContract(complete);
					complete.reward();	
					trace("Contract removed");
					return;
				}						
			}
		}
		
		private function parseContracts():void 
		{
			var a:Array = DataSources.instance.getList("contracts");
			for each (var c:Object in a ) 
			{
				var contract:BaseContract = new BaseContract(c.starts, c.term, "constant" in c);
				if ("location" in c) contract.location = a.location;				
				contracts.push(contract);
				
				var ts:Array = c.tasks;
			
				for each (var t:Object in ts) 
				{
					
					trace("Added task");
					
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
						task.dayTime = t.time;
					}
					
					contract.tasks.push(task);
				}
				
				
			}
		}		
		
		public function timeUpdate(time:int):void 
		{
			//NEW Contracts
			var ln:int = contracts.length;			
			for (var i:int = ln - 1; i >= 0; i--) 
			{
				if (contracts[i].startsFrom == time) {					
					AddContract(contracts.splice(i, 1)[0]);				
				}
			}			
			
			
			//Expired contracts
			var ln2:int = current.length;
			for (var j:int = ln2 - 1; j >= 0; j--) 
			{				
				if (current[j].expired(time)) {	
					RemoveContract(current.splice(j, 1)[0]);					
				}
			}
			
			
			trace(current);
			
		}
		
		
		
		
		
	}

}