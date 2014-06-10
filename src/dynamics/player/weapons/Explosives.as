package dynamics.player.weapons 
{
	import dynamics.actions.CaboomAction;
	import dynamics.player.Hands;
	import dynamics.player.weapons.explosives.Grenade;
	import gui.Bars.SimpleBar;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author DG
	 */
	public class Explosives extends Hands
	{
		private var explosives:ExplosiveData;
		
		public var acc:int = 0;
		public var isSet:Boolean = false;
		
		private var _power:Number = 0;
		private var MAX_POWER:Number = 10;
		
		public var cd:int = 0;
		
		/**
		 * TODO add player velocity to the grenade and mine
		 * TODO Grenade sprites;
		 */
		
		public function Explosives() 
		{
			weaponType = WeaponData.TYPE_EXPLOSIVE;
			_action = new CaboomAction();
			_action.params.power = 100;
		}
		
		override public function init():void {
			
			if (!carrier_view.sprite.contains(power_bar)) carrier_view.sprite.addChild(power_bar);

			
			updateParams();		
			_power = 0;
			updateView();
		}
		
		override public function select(new_wd:WeaponData):void 
		{			
			explosives = new_wd as ExplosiveData;		
			
		}
		
		private function updateView():void 
		{			
			var scale:Number = _power / MAX_POWER;
			if (scale == 0) power_bar.visible = false;
			else {
				if (!power_bar.visible) power_bar.visible = true;
				power_bar.scale(scale > 1? 1 : scale);
			}
			
			power_bar.scaleX = carrier.facing;
		}
		
		

		
		override public function interrupt():void 
		{
			isSet = false;
			_power = 0;			
			carrier_view.stady();			
		}
		
		override public function tick():void {
					
			if (cd > 0) {
				cd--;
				return;
			}
			
			
			
			if (mouse.pressed() && !isSet) {
				isSet = true;
				carrier_view.shot(true);				
			}
			
			if (!isSet) return;
			
			if (mouse.pressed() && _power < MAX_POWER) {
				_power += 0.3;
				updateView();
			}
			
			if (mouse.justReleased()) {				
					act();				
			}
		}
		
		private function act():void 
		{
			if (_power > 1.5) {
				cd = 30;
				var g:Grenade = Grenade.greandeCache.getInstance() as Grenade;
				g.add(getProjectilePosition(), new Vec2(carrier.facing * 40 * _power, -100 - 30 * _power));				
				carrier_view.sprite.body.arms.gotoAndPlay(14);
				
			}else {
				carrier_view.stady();
			}
			
			
			_power = 0;
			isSet = false;
			
			updateView();
			
			
		}
		
		private function getProjectilePosition():Vec2 {
			
			return new Vec2(pivot.x + carrier.facing * 20, pivot.y);
		}
		
		private function nothing():void 
		{
			
		}
		
		override protected function gatherAction():void {	
			
			if (rayResult) {
				_action.params.x = ray.at(rayResult.distance).x;
				_action.params.y = ray.at(rayResult.distance).y;
			}			
			
			_action.params.facing = carrier.facing;
			
		}
	}

}