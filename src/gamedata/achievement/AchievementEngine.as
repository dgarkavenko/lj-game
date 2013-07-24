package gamedata.achievement 
{
	import framework.screens.GameScreen;
	import gamedata.DataSources;
	import gui.PopupManager;
	/**
	 * ...
	 * @author DG
	 */
	
	public class AchievementEngine 
	{
		
	
		
		
		private var data:Array;
		
		
		public static const TREE_DOWN:String = "tree_dwon";
		public static const JUMP:String  = "jump";
		
		private const ACTIONS:Array = [TREE_DOWN, JUMP]; 
		
		// Actions 2 Achieve
		private var A2A:Object = new Object();		
		
		public function build():void {
			
			data = [
				new Achievement("ach1", [TREE_DOWN], 1),
				new Achievement("ach2", [TREE_DOWN], 10),
				new Achievement("ach3", [JUMP], 1)
			]
			
			for each (var action:String in ACTIONS) 
			{
				
				A2A[action] = [];
				
				for each (var ach:Achievement in data ) 
				{
					if (ach.actions.indexOf(action) != -1) {
						A2A[action].push(ach);
					}
				}			
				
			}
		}
		
		public function did(action:String):void {
			
			for each (var ach:Achievement in A2A[action] ) 
			{
				
				//Вырезать объект
				if (ach.done()) continue;
				
				ach.current++;
				if (ach.done()) {
					GameScreen.POP.show(PopupManager.ACHIEVEMENT_POPUP, true, { a:ach.alias } );
					DataSources.lumberkeeper.save();
				}
			}
		}
		
		
		
		public function pull():Object 
		{
			var result:Object = {};
			for each (var ach:Achievement in data )  
			{
				result[ach.alias] = ach.current;
			}
			
			return result;
		}
		
		
	}

}