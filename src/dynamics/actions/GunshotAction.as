package dynamics.actions 
{
	
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author DG
	 */
	public class GunshotAction implements IAction
	{
		
		private var _type:String = ActionTypes.GUNSHOT_ACTION;
		private var _params:Object = {};
		
		public function GunshotAction() 
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