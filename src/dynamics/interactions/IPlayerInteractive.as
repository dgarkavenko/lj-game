package dynamics.interactions 
{
	
	/**
	 * ...
	 * @author DG
	 */
	public interface IPlayerInteractive 
	{
		function onUse(params:Object):void;
		function onFocus():void;
		function onLeaveFocus():void;
	}
	
}