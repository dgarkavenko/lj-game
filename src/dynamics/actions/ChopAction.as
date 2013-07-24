package dynamics.actions 
{
	/**
	 * ...
	 * @author DG
	 */
	public class ChopAction implements IAction
	{
		public var _params:Object = new Object();;
		private var _type:String = ActionTypes.CHOP_ACTION;	
		
		
		public function ChopAction() 
		{
			
		}
		
		/* INTERFACE dynamics.actions.IAction */
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get params():Object 
		{
			return _params;
		}
	}

}