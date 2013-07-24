package dynamics.interactions 
{
	import dynamics.actions.IAction;
	
	/**
	 * CbType: GameCb.INTERACTIVE
	 * @author DG
	 */
	public interface IInteractive 
	{
		function interact(action:IAction):void;
	}
	
}