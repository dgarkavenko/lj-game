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
			
			
			if (regen == 0 || _current >= max) return;
			
			tick_time--;
			if (tick_time < 0) {		
				
				_current += regen;
				_current = _current > max ? max : _current;
				tick_time = 30;
				GameScreen.HUD.update_hp(_current,max);
				
			}
			
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
			GameScreen.HUD.update_hp(_current,max);
		}
		
		public function get current():int 
		{
			return _current;
		}
		
	}

}