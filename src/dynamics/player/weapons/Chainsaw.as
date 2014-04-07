package dynamics.player.weapons 
{
	import dynamics.actions.ActionTypes;
	import dynamics.actions.ChainsawAction;
	import dynamics.actions.ChopAction;
	import dynamics.GameCb;
	import dynamics.player.Hands;
	import nape.geom.RayResult;
	import nape.phys.Body;
	/**
	 * ...
	 * @author DG
	 */
	public class Chainsaw extends Hands
	{
		private var tooldata:ToolData;
		
		public function Chainsaw() 
		{
			weaponType = WeaponData.TYPE_CHAINSAW;
			_action = new ChainsawAction();		
			
		}
		
		override public function init():void {
			ray.maxDistance = 55;
			updateParams();			
		}
		
		override public function select(new_wd:WeaponData):void 
		{			
			tooldata = new_wd as ToolData;		
			_action.params.tree_dmg = tooldata.t_dmg;
			_action.params.z_dmg = tooldata.z_dmg;
			_action.params.power = 1;
		}
		
		override public function tick():void {
			
			if (mouse.justPressed()) {
				carrier_view.shot(true);
			}else if (mouse.justReleased()) {
				carrier_view.sprite.body.arms.gotoAndPlay(4);
			}
			
			if (mouse.pressed()) {
				act();
			}
		}
		
		private function act():void 
		{
			
			var subj:Body;
			
			ray.origin = GameWorld.lumberbody.position;
			ray.direction.setxy(GameWorld.lumberjack.facing, 0);
			
			//rayResult = space.rayCast(ray, false, AXE_RAY_FILTER);			
			rayResultMulti = space.rayMultiCast(ray, true, AXE_RAY_FILTER);			
			
			
			if (!rayResultMulti || rayResultMulti.length == 0 ) {
				nothing();
				return;
			}
			else
			{
				
				var ln:int = rayResultMulti.length;
				
				for (var i:int = ln - 1; i > -1; i--) 
				{				
					var rr:RayResult = rayResultMulti.at(i);
					if (rr.shape.cbTypes.has(GameCb.ZOMBIE)) {
						rayResult = rr;
						subj = rr.shape.body;
						break;
					}
				}
				
				if (subj == null) {
					rayResult = rayResultMulti.at(0);
					subj = rayResult.shape.body;					
				}			
			}
				
			if (subj != null && subj.cbTypes.has(GameCb.INTERACTIVE)) subj.userData.interact(action);			
			else nothing();					
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