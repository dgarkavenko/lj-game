package dynamics.player 
{
	import dynamics.GameCb;
	import dynamics.interactions.ActionArea;
	import nape.callbacks.InteractionCallback;
	/**
	 * ...
	 * @author DG
	 */
	public class LumberActionArea extends ActionArea
	{
		
		override protected function onEnter(cb:InteractionCallback):void 
		{
			super.onEnter(cb);
			
			trace("enter");
			
			if (cb.int2.cbTypes.has(GameCb.TIP)) {
				cb.int2.userData.showTip();
			}
			
		}
		
		override protected function onLeave(cb:InteractionCallback):void 
		{
			super.onLeave(cb);
			if (cb.int2.cbTypes.has(GameCb.TIP) && "hideTip" in cb.int2.userData) {
				cb.int2.userData.hideTip();
			}
			
		}
		
	
		
	}

}