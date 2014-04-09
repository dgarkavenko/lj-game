package dynamics.actions 
{
	/**
	 * ...
	 * @author DG
	 */
	public class CaboomAction implements IAction
	{
		
		private var _type:int = ActionTypes.CABOOM;
		private var _params:Object = {};
		
		
		public function CaboomAction() 
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