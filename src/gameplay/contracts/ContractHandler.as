package gameplay.contracts 
{
	import flash.events.EventDispatcher;
	import gamedata.DataSources;
	import gameplay.contracts.bills.Bill;
	import gameplay.contracts.bills.Blackmail;
	import gameplay.contracts.bills.Bribe;
	import gameplay.contracts.bills.Gambling;
	import gameplay.contracts.bills.Housemaid;
	import gameplay.contracts.bills.Mortgage;
	import gameplay.contracts.bills.Parking;
	import gameplay.contracts.bills.Ransom;
	import gameplay.contracts.bills.Vet;
	import gameplay.contracts.imp.DangerToGoAlone;
	import gameplay.contracts.imp.WeCanKillEm;
	import gameplay.world.TimeManager;
	import gui.PopText;
	import utils.DataEvt;
	import utils.GlobalEvents;
	/**
	 * 
	 * BILLS POPUP CLOSE BUTTON 
	 * MONEY BAR
	 * BILLS FAIL ---> CINEMATIC?
	 * 
	 * PRICES AND WEAPON DSC, TITLES, FONT
	 * 
	 * 
	 * 
	 * 
	 * @author dg
	 */
	public class ContractHandler
	{
		
		private var currentTime:int = 0;
		
		private var bills:Vector.<Bill> = new Vector.<Bill>();
		private var allbills:Vector.<Bill> = new Vector.<Bill>();
		
		private var contracts:Vector.<BaseContract> = new Vector.<BaseContract>();		
		public var current:Vector.<BaseContract> = new Vector.<BaseContract>();	
		
		private var huntTasks:Vector.<Task> = new Vector.<Task>();
		private var chopTasks:Vector.<Task> = new Vector.<Task>();		
		private var otherTasks:Vector.<Task> = new Vector.<Task>();
		
		private var temporaryComplete:Array = [];		
		
		private function AddContract(cntrct:BaseContract, flag:uint):void {
			for each (var t:Task in cntrct.tasks ) 
			{
				
				t.contract = cntrct;
				
				if (t.event == GlobalEvents.ZOMBIE_KILLED) {
					huntTasks.push(t);
				}else if (t.event == GlobalEvents.TREE_CUT) {
					chopTasks.push(t);
				}else {
					otherTasks.push(t);
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
				}else {
					for (var k:int = chopTasks.length - 1; k >= 0 ; k--) 
					{
						if (otherTasks[k] == t) otherTasks.splice(k, 1);
					}
				}
			}
		}
		
		
		
		public function ContractHandler() 
		{
			
			$GLOBAL.listenTo(GlobalEvents.ZOMBIE_KILLED, onZombieKill);
			$GLOBAL.listenTo(GlobalEvents.TREE_CUT, onTreeCut);						
			$GLOBAL.listenTo(GlobalEvents.PURCHASE, onPurchase);
			
			
			addNewContract(IF_THEY_BLEED);			
			addNewContract(DANGER_TO_GO_ALONE);			
			//billsSetup();
		}
		
		private function onPurchase(e:DataEvt):void 
		{
			
			for each (var task:Task in otherTasks ) 
			{
				if (task.isDone || task.event != GlobalEvents.PURCHASE) continue;
				if (task.ProgressIfMatch(e.data) && task.contract.isDone) {
					trace("Contract complete");
					temporaryComplete.push(task.contract);
				}
			}
			
			clearAndReward();
			
		}
		
		private function billsSetup():void 
		{
			AddBill(new Bribe(), 1);
			AddBill(new Parking(), 5);
			AddBill(new Mortgage(), 9);
			
			allbills.push(new Blackmail());
			allbills.push(new Ransom());
			allbills.push(new Gambling());
			allbills.push(new Housemaid());
			
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
			
			clearAndReward();
		}
		
		private function clearAndReward():void {
			
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
			
			clearAndReward();
			
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
		
		
		
		public function timeUpdate(time:int):void 
		{
			
			currentTime = time;
			
			//NEW Contracts
			var ln:int = contracts.length;			
			for (var i:int = ln - 1; i >= 0; i--) 
			{
				if (contracts[i].startsFrom == time) {					
					//AddContract(contracts.splice(i, 1)[0]);				
				}
			}			
			
			/*
			//Expired contracts
			var ln2:int = current.length;
			for (var j:int = ln2 - 1; j >= 0; j--) 
			{				
				if (current[j].expired(time)) {	
					RemoveContract(current.splice(j, 1)[0]);					
				}
			}*/
			
			
			
			
			//BILLS
			//if (bills.length < 4 && Math.random() > 0.66) {
				//AddRandomBill();
			//}
			
			/*
			
			for (var k:int = 0; k < bills.length; k++) 
			{
				if (bills[k].expired()) {
					bills[k].onNotPaid();
					return;
				}
			}	
			
			*/
			
		}
		
		private function AddRandomBill():void 
		{
			var b:Bill = allbills.shift();
			AddBill(b);			
		}
		
		private function AddBill(b:Bill, t:int = 0):void {
			b.startDate = currentTime;
			b.term = t == 0? 2 + Math.random() * 6 : t;
			bills.push(b);
		}
		
		public function PayBill(b:Bill):void {
			
			allbills.push(b);
			trace(bills.length);
			
		}
		
		public function getContracts():Vector.<BaseContract> 
		{
			return current;
		}
		
		private function compare(x:Bill, y:Bill):Number {
			return x.timeLeft() > y.timeLeft() ? 1 : -1;
		}	
		
		public function getBillsRef():Vector.<Bill> {
			return bills.sort(compare);			
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
		
		public static function isComplete(alias:String):Boolean {
			return (mask_complete & flags[alias]) == flags[alias];
		}
		
		public static function isCurrent(alias:String):Boolean {
			return (mask_current & flags[alias]) == flags[alias];
		}		
		
		public static var mask_current:uint = 0;
		public static var mask_complete:uint = 0;
		
		public static var DANGER_TO_GO_ALONE:String = "DANGER_TO_GO_ALONE";
		public static var IF_THEY_BLEED:String = "IF_THEY_BLEED";
		
		private static var flags:Object = {
			DANGER_TO_GO_ALONE:1,
			IF_THEY_BLEED:2			
		}
		
		private var c:Object = { 
		
		
			DANGER_TO_GO_ALONE:new DangerToGoAlone(),
			IF_THEY_BLEED:new WeCanKillEm()		
		}
		
		
	}

}