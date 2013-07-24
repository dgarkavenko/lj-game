package gamedata 
{

	import flash.events.Event;
	import framework.screens.GameScreen;
	import gameplay.player.SkillList;
	import gui.PopupManager;

	/**
	 * Содержит, сохраняет и получает всю дату об игроке
	 * @author DG
	 */
	public class LumberKeeper extends GameKeeper
	{
		
		public var achievements:Object = {};
		public var pixels:int = 0;
		public var jumps:int = 0;		
		public var score:int = 0;
		
		public var skills:Array = [0,0,0,0,0,0]
		
		
		public var day:int = 1;
		public var wood:int = 0;
		public var money:int = 0;
		
		public var hp:int = 100;
		public var max_hp:int = 100;
		public var xp:int = 0;		
		
		
		private var params:Array = ["pixels", "jumps", "score", "day", "skills", "hp", "xp","max_hp"];
		
		public function LumberKeeper(a:String, autosave:int = 0) 
		{
			super(a, autosave);
			load();		
			
		}
		
		override public function pack():Object {
			
			var serial:Object = {};			
			for each (var param:String in params ) serial[param] = this[param]; 			
			return serial;
			
		}
		
		override public function extract(load_data:Object):void {
			
			for each (var param:String in params ) if (param in load_data) this[param] = load_data[param];	
			
		
			
			trace("---Loaded params---");			
			for (param in load_data ) trace(param + ":" + load_data[param]);					
			trace("--------------------\n");	
			
			
		}	
		
	}

}