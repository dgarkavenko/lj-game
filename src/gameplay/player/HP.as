package gameplay.player 
{
	import framework.screens.GameScreen;
	import gameplay.SkillList;
	import nape.geom.Vec2;
	import nape.phys.Body;
	/**
	 * ...
	 * @author DG
	 */
	public class HP 
	{
		
		//Skills
		private var resistance:Number;
		private var regen:Number;
		private var tick_time:int = 60;
		
		private var _current:int = 100;
		public var max:int = 100;
		public var dot:Number = 0;
		public var immune:Boolean = false;
		
		private var regenToApply:Number = 0;
		private var dotToApply:Number = 0;

		private var aura:Boolean = false;
		
		public function HP() 
		{
			
		}
		
		public function init(c:int = 100, m:int = 100):void {	
			_current = c;
			max = m;
			updateParams();
		}
		
		public function tick():void {	
			
			
			if (regen > 0 || _current >= max) {
				regenToApply += regen / 30;
				if (regenToApply > 1) {
					
					regenToApply--;
					_current++;
					_current = _current > max ? max : _current;
				}				
			}
			
			if (dot > 0 && !immune) {
				dotToApply += dot / 30;
				if (dotToApply >= 1) {
					if (_current > 1) _current--;
					dotToApply--;
				}
			}
			
			tick_time--;
			
			GameScreen.HUD.update_hp(_current,max);
			
		}
		
		public function updateParams():void 
		{
			if (SkillList.isLearned(SkillList.BEAR_VITALITY)) regen = 1;
			GameScreen.HUD.regen = regen;			
			GameScreen.HUD.update_hp(_current,max);
		}
		
		public function decrease(dmg:int):void {
			_current -= dmg;
			if (_current <= 0) GameWorld.protaganistIsDead();
			GameScreen.HUD.update_hp(_current,max);
		}
		
		public function get current():int 
		{
			return _current;
		}
		
	}

}