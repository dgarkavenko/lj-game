package dynamics.enemies.implement 
{
	import dynamics.BaseSpriteControl;
	import dynamics.enemies.base.Standart;
	import flash.events.Event;
	import gameplay.TreeHandler;
	import nape.geom.Vec2;
	import utils.GlobalEvents;
	import visual.z.EManagerView;
	import visual.z.ManagerView;
	/**
	 * ...
	 * @author DG
	 */
	public class Manager extends Standart
	{
		public function Manager() 
		{
			super("manager");
		}
		
		override protected function setView():void {		
			
			if (Math.random() > 0.49999999999) {
				_view = new BaseSpriteControl(EManagerView);	
			}else {
				_view = new BaseSpriteControl(ManagerView);
			}
				
		}	
		
	}

}