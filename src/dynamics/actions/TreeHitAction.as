package dynamics.actions 
{
	/**
	 * ...
	 * @author DG
	 */
	public class TreeHitAction implements IAction
	{
		public var _params:Object = new Object();
		private var _type:int = ActionTypes.TREE_HIT;	
		
		
		public function TreeHitAction() 
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