package gamedata 
{

	import flash.events.Event;
	import framework.screens.GameScreen;
	import gameplay.contracts.ContractHandler;
	import gameplay.SkillList;
	import gui.PopupManager;

	/**
	 * Содержит, сохраняет и получает всю дату об игроке
	 * @author DG
	 */
	public class LumberKeeper extends GameKeeper
	{
		
	
		
		
		public var time:int = 1;
		public var money:int = 7000;
		public var skills:uint = 0;
		public var current_quests:uint = 0;
		public var complete_quests:uint = 0;
		
		public var hp:int = 0;
		
		
		
		
		
		private var params:Array = ["hp","skills","time", "current_quests", "complete_quests", "money"];
		
		public function LumberKeeper(a:String, autosave:int = 0) 
		{
			super(a, autosave);
			load();		
			
		}
		
		override public function pack():Object {
			
			refresh();
			
			var serial:Object = {};			
			for each (var param:String in params ) serial[param] = this[param]; 			
			return serial;
			
		}
		
		private function refresh():void 
		{
			hp = GameWorld.lumberjack.hp;
			skills = SkillList.learned;
			time = GameWorld.time.time;
			current_quests = ContractHandler.mask_current;
			complete_quests = ContractHandler.mask_complete;
			money = GameWorld.lumberjack.cash;
		}
		
		override public function extract(load_data:Object):void {
			
			for each (var param:String in params ) if (param in load_data) this[param] = load_data[param];	
			
		
			
			trace("---Loaded params---");			
			for (param in load_data ) trace(param + ":" + load_data[param]);					
			trace("--------------------\n");	
			
			
		}	
		
	}

}