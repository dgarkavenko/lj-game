package dynamics.actions 
{
	/**
	 * ...
	 * @author DG
	 */
	public class ChainsawAction implements IAction
	{
		
		public var _params:Object = new Object();;
		private var _type:int = ActionTypes.CHAINSAW;	
		
		
		public function ChainsawAction() 
		{
			
		}
		
		/* INTERFACE dynamics.actions.IAction */
		
		public function get type():int 
		{
			return _type;
		}
		
		public function get params():Object 
		{
			return _params;
		}
		
	}

}