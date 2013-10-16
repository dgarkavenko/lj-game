package dynamics.actions 
{
	/**
	 * ...
	 * @author DG
	 */
	public class PuddleBurnAction implements IAction
	{
		
			
		private var _type:int = ActionTypes.PUDDLE_BURN;
		private var _params:Object = {};
		
		public function PuddleBurnAction(d:int) 
		{
			_params.damage = d;
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