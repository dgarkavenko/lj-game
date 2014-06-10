package dynamics.player.weapons 
{
	import dynamics.actions.ChopAction;
	import dynamics.GameCb;
	import dynamics.player.Hands;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import gui.Bars.SimpleBar;
	import nape.geom.RayResult;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;

	/**
	 * ...
	 * @author DG
	 */
	public class Tool extends Hands
	{
		
		
		private var _power:Number = 0;	
		private const MAX_POWER:Number = 4;
		
		private var toolData:ToolData;
		
		
		
		private var cd:Number = 0; //frames
		private var prepare:Boolean = false;
		
		public function Tool() 
		{
			weaponType = WeaponData.TYPE_AXE;
			_action = new ChopAction();

		}
		
		override public function interrupt():void 
		{
			prepare = false;
			_power = 0;
			updateView();
			carrier_view.stady();
			
		}
		
		override public function tick():void {
			
		
			if (mouse.justPressed()) {
				carrier_view.swing();
				prepare = true;
			}
			
			if (prepare) {
				active();
			}
			if (mouse.justReleased() && prepare) {					
				carrier_view.shot(true);
				act();
			}
			
		}	
		
	
		
		override public function kill():void {
			_power = 0; 
			
			updateView();
		}
		
		private function act():void 
		{
			prepare = false;
			
			var subj:Body;
			
			ray.origin = GameWorld.lumberbody.position;
			ray.direction.setxy(GameWorld.lumberjack.facing, 0);
			
			//rayResult = space.rayCast(ray, false, AXE_RAY_FILTER);			
			rayResultMulti = space.rayMultiCast(ray, false, AXE_RAY_FILTER);
			
			
			
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
			action;
		}
		
		private function active():void 
		{
			if (_power >= MAX_POWER) _power = MAX_POWER;
			else {
				_power += toolData.inc;
				updateView();				
			}
		}
		
		override protected function gatherAction():void {	
			
			if (rayResult) {
				_action.params.x = ray.at(rayResult.distance).x;
				_action.params.y = ray.at(rayResult.distance).y;
			}			
			
			_action.params.tree_dmg = toolData.t_dmg;
			_action.params.z_dmg = toolData.z_dmg;
			_action.params.power = _power;
			_action.params.facing = carrier.facing;
			_power = 0; 
			updateView();	
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
		
		override public function init():void {
			
			if (!carrier_view.sprite.contains(power_bar)) carrier_view.sprite.addChild(power_bar);

			
			power_bar.scale(0);			
			ray.maxDistance = 40;			
			updateView();			
		}
		
		override public function select(new_wd:WeaponData):void 
		{
			_power = 0;
			prepare = false;
			updateView();
			carrier_view.stady();
			
			toolData = new_wd as ToolData;
		}
		
		override public function pull():WeaponData {
		
			return toolData;
		}
		

		
	}

}