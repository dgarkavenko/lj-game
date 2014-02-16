package gameplay.contracts 
{
	import flash.events.EventDispatcher;
	import gamedata.DataSources;
	import gameplay.contracts.imp.DangerToGoAlone;
	import gameplay.contracts.imp.WeCanKillEm;
	import gui.PopText;
	import utils.DataEvt;
	import utils.GlobalEvents;
	/**
	 * ...
	 * @author dg
	 */
	public class ContractHandler
	{
		
		private var contracts:Vector.<BaseContract> = new Vector.<BaseContract>();
		
		
		public var current:Vector.<BaseContract> = new Vector.<BaseContract>();
		
		
		
		
		
		private var huntTasks:Vector.<Task> = new Vector.<Task>();
		private var chopTasks:Vector.<Task> = new Vector.<Task>();
		
		private var temporaryComplete:Array = [];
		
		
		private function AddContract(cntrct:BaseContract, flag:uint):void {
			for each (var t:Task in cntrct.tasks ) 
			{
				if (t.event == GlobalEvents.ZOMBIE_KILLED) {
					huntTasks.push(t);
				}else if (t.event == GlobalEvents.TREE_CUT) {
					chopTasks.push(t);
				}
			}
			
			current.push(cntrct);
			
			cntrct.flag = flag;
			mask_current |= flag;
		}
		
		private function RemoveContract(cntrct:BaseContract):void {
			for each (var t:Task in cntrct.tasks ) 
			{
				if (t.event == GlobalEvents.ZOMBIE_KILLED) {
					for (var i:int = huntTasks.length - 1; i >= 0 ; i--) 
					{
						if (huntTasks[i] == t) huntTasks.splice(i, 1);
					}
					
				}else if (t.event == GlobalEvents.TREE_CUT) {
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
			
			
			addNewContract(IF_THEY_BLEED);			
			addNewContract(IF_THEY_BLEED);
			
			
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
					
					mask_current &= ~complete.flag;
					mask_complete |= complete.flag;
							
					return;
				}						
			}
		}
		
		/*private function parseContracts(a:Array, ach:Boolean = false):void 
		{
			
			for each (var c:Object in a ) 
			{
				var contract:BaseContract = new BaseContract(c.starts, c.term, ach, c.title);
				if ("reward" in c) contract.reward_size = c.reward;
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
		}		*/
		
		public function timeUpdate(time:int):void 
		{
			//NEW Contracts
			var ln:int = contracts.length;			
			for (var i:int = ln - 1; i >= 0; i--) 
			{
				if (contracts[i].startsFrom == time) {					
					//AddContract(contracts.splice(i, 1)[0]);				
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
		
		public function getContracts():Vector.<BaseContract> 
		{
			return current;
		}
		
		public function addNewContract(alias:String):void 
		{
			
			if (isComplete(alias) || isCurrent(alias)) return;
			
			if (alias in c) {		
				
				if (GameWorld.lumberbody != null) {
					PopText.at(alias, GameWorld.lumberbody.position.x, GameWorld.lumberbody.position.y - 20, 0xffffff);
				}else {
					trace(alias);
				}
				
				AddContract(c[alias], flags[alias]);			
				delete c[alias];
			}			
		}
		
		public function isComplete(alias:String):Boolean {
			return (mask_complete & flags[alias]) == flags[alias];
		}
		
		public function isCurrent(alias:String):Boolean {
			return (mask_current & flags[alias]) == flags[alias];
		}		
		
		public static var mask_current:uint = 0;
		public static var mask_complete:uint = 0;
		
		public static var DANGER_TO_GO_ALONE:String = "DANGER_TO_GO_ALONE";
		public static var IF_THEY_BLEED:String = "IF_THEY_BLEED";
		
		private var flags:Object = {
			DANGER_TO_GO_ALONE:1,
			IF_THEY_BLEED:2			
		}
		
		private var c:Object = { 
		
		
			DANGER_TO_GO_ALONE:new DangerToGoAlone(),
			IF_THEY_BLEED:new WeCanKillEm()		
		}
		
		
	}

}