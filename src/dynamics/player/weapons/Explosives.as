package dynamics.player.weapons 
{
	import dynamics.actions.CaboomAction;
	import dynamics.player.Hands;
	import dynamics.player.weapons.explosives.Grenade;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author DG
	 */
	public class Explosives extends Hands
	{
		private var explosives:ExplosiveData;
		
		public var acc:int = 0;
		
		public function Explosives() 
		{
			weaponType = WeaponData.TYPE_EXPLOSIVE;
			_action = new CaboomAction();
			_action.params.power = 100;
		}
		
		override public function init():void {
			updateParams();			
		}
		
		override public function select(new_wd:WeaponData):void 
		{			
			explosives = new_wd as ExplosiveData;		
			
		}
		override public function tick():void {
			
			if (mouse.justPressed()) {
				carrier_view.shot(true);
			}else if (mouse.justReleased()) {
				carrier_view.sprite.body.arms.gotoAndPlay(4);
			}
			
			if (mouse.justReleased()) {
				act();
			}
		}
		
		private function act():void 
		{
			var g:Grenade = Grenade.greandeCache.getInstance() as Grenade;
			g.add(getProjectilePosition(), new Vec2(carrier.facing * 350, -300));
			
			
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