package gui 
{
	import flash.display.MovieClip;
	import framework.screens.GameScreen;
	import gui.popups.AchievementPopup;
	import gui.popups.BillPopup;
	import gui.popups.ContractWindow;
	import gui.popups.PerkPopup;
	import gui.popups.Popup;
	import gui.popups.Shop;
	/**
	 * ...
	 * @author DG
	 */
	public class PopupManager 
	{
		private var container:MovieClip;
		private var popup:Popup;
		private var pops:Vector.<Popup> = new Vector.<Popup>();
		private var queued:Vector.<Popup> = new Vector.<Popup>();
		private var queuedParams:Array = [];
		
		//CACHED POPUPS
		public static const CONTRACT:ContractWindow = new ContractWindow();		
		public static const ACHIEVEMENT_POPUP:AchievementPopup = new AchievementPopup();
		public static const SHOP:Shop = new Shop();
		public static const PERKS:PerkPopup = new PerkPopup();
		static public const BILLS:BillPopup = new BillPopup();
		
		public function PopupManager(container:MovieClip)
		{
			this.container = container;
			
		}
		
		
		public function isOpen(pop:Popup):Boolean {
			for (var i:int = 0; i < pops.length; i++) 
			{
				if (pops[i] == pop) return true;
			}
			
			return false;
		}
		
		/**
		 * Показать попап
		 * @param	pop — что показать
		 * @param	queue — стоит ли добавить его в очередь, если сейчас что-то уже показывается
		 */
		public function show(pop:Popup, queue:Boolean = false, params:Object = null):void {
			
			if (!container) return;
			
			if (pops.length > 0) {				
				if (queue) {
					queued.push(pop);	
					queuedParams.push(params);
				}else {				
					pop.build(container, params);
					pops.push(pop);		
					if (pop.require_pause) GameScreen.world_simulation_OFF();
				}
			}else {
				pop.build(container, params);
				pops.push(pop);		
				if (pop.require_pause) GameScreen.world_simulation_OFF();
			}		
			
		}
		
		public function hide(pop:Popup):void {
			
			if (pops.length == 0) return;
			
			for (var i:int = 0; i < pops.length; i++) 
			{
				if (pop == pops[i]) {
					pops.splice(i, 1);
					break;
				}
			}
			
			pop.destroy(container);
			
			if (queued.length > 0) {						
				show(queued.shift(), false, queuedParams.shift());				
			}else {							
				GameScreen.world_simulation_ON();
			}
			
			if (container.stage) container.stage.focus = container;	
			
			
		}
		
	}

}