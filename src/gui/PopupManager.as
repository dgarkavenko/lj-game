package gui 
{
	import flash.display.MovieClip;
	import framework.screens.GameScreen;
	import gui.popups.AchievementPopup;
	import gui.popups.AchievementsWindow;
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
		private var queued:Vector.<Popup> = new Vector.<Popup>();
		
		//CACHED POPUPS
		public static const ACHIEVEMENTS:AchievementsWindow = new AchievementsWindow();		
		public static const ACHIEVEMENT_POPUP:AchievementPopup = new AchievementPopup();
		public static const SHOP:Shop = new Shop();
		
		public function PopupManager(container:MovieClip)
		{
			this.container = container;
			
		}
		
		
		/**
		 * Показать попап
		 * @param	pop — что показать
		 * @param	queue — стоит ли добавить его в очередь, если сейчас что-то уже показывается
		 */
		public function show(pop:Popup, queue:Boolean = false, params:Object = null):void {
			
			if (!container) return;
			
			if (popup) {				
				if (queue) queued.push(pop);				
			}else {
				pop.build(container, params);
				popup = pop;			
				if (popup.require_pause) GameScreen.world_simulation_OFF();
			}
			
			
			
		}
		
		public function hide():void {
			
			if (popup == null) return;
			popup.destory(container);
			popup = null;
			
			if (queued.length > 0) {						
				show(queued.shift());				
			}else {							
				GameScreen.world_simulation_ON();
			}
			
			container.stage.focus = container;	
			
			
		}
		
	}

}