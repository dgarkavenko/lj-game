package gui 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import dynamics.interactions.IInteractive;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import gui.Bars.SimpleBar;
	import visual.HUD;
	/**
	 * ...
	 * @author DG
	 */
	public class HUDClass extends HUD
	{
		
		private var hp_regen:int = 0;
		private var prev_hp:int = 0;
		
		private var initial_x:int = 0;
		
		public function HUDClass() 
		{
			initial_x = hp.x;
		}	
		
		public function update_hp(c:int, m:int ):void {
			
			if (prev_hp != c) {
				TweenLite.killTweensOf(hp);				
				TweenLite.to(hp, 0.1, { scaleX:1.1, scaleY:1.1, x:initial_x - (0.1 * hp.width), onComplete:scaleBack, ease:Cubic.easeIn } );
				prev_hp = c;
				hp.text = c.toString();
			}		
			
		}
		
		public function update_cash(c:int):void {
		
			var cash_str:String = c.toString();			
			cash.text = cash_str.length > 3 ? cash_str.slice(0, cash_str.length - 3) + "," + cash_str.slice(cash_str.length - 3) : cash_str;
					
			
		}
		
		public function scaleBack():void{
		
			TweenLite.to(hp, 0.1, { scaleX:1, scaleY:1, x:initial_x} );

		}
		
		public function set regen(value:int):void 
		{
			hp_regen = value;
		}
		
	}

}