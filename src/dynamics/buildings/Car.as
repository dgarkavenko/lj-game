package dynamics.buildings 
{
	import dynamics.interactions.IInteractive;
	import dynamics.interactions.ITipSpitter;
	import dynamics.WorldObject;
	/**
	 * ...
	 * @author DG
	 */
	public class Car extends Building implements ITipSpitter, IInteractive 
	{
		
		public function Car() 
		{
			
		}
		
		/* INTERFACE dynamics.interactions.ITipSpitter */
		
		public function showTip():void 
		{
			
		}
		
		public function hideTip():void 
		{
			
		}
		
		/* INTERFACE dynamics.interactions.IInteractive */
		
		public function interact(type:String, params:Object = null):void 
		{
			
		}
		
	}

}