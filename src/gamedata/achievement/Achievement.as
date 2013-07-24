package gamedata.achievement 
{
	import gamedata.DataSources;
	/**
	 * ...
	 * @author DG
	 */
	public class Achievement 
	{
		
		public var alias:String = "";
		public var current:int = 0;
		public var target:int;
		public var actions:Array = [];
		
		public function Achievement(alias:String, actions:Array, target:int = 1) 
		{			
			this.alias = alias;
			this.target = target;
			this.actions = actions
			
			if (alias in DataSources.lumberkeeper.achievements) {
				current = DataSources.lumberkeeper.achievements[alias];
			}
		}
		
		public function done():Boolean {
			return current >= target;
		}
		
	}

}