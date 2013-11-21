package gameplay.player 
{
	import framework.screens.GameScreen;
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
			
			if (dot > 0) {
				dotToApply += dot / 30;
				if (dotToApply >= 1) {
					if (_current > 1) _current--;
					dotToApply--;
				}
			}
			
			tick_time--;
			
			GameScreen.HUD.update_hp(_current,max);
			
		}
		
		public function auraEffect(b:Boolean):void 
		{
			if (aura == b) return			
			aura = b;
			updateParams();
		}
		
		public function updateParams():void 
		{
			regen = aura? SkillList.regen_a + 1 : SkillList.regen_a;
			GameScreen.HUD.regen = regen;
			resistance = SkillList.dmg_reduction;
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