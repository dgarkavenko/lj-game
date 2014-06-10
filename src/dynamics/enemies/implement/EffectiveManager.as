package dynamics.enemies.implement 
{
	import dynamics.BaseSpriteControl;
	import dynamics.enemies.base.Standart;
	import flash.events.Event;
	import gameplay.TreeHandler;
	import nape.geom.Vec2;
	import utils.GlobalEvents;
	import visual.z.ManagerView;
	/**
	 * ...
	 * @author DG
	 */
	public class EffectiveManager extends Standart
	{
		private var ite:int = 0;
		public function EffectiveManager() 
		{
			super("manager");
		}
		
		override protected function setView():void {		
			_view = new BaseSpriteControl(ManagerView);		
		}	
		
	}

}