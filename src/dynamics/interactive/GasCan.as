package dynamics.interactive 
{
	import dynamics.Collision;
	import dynamics.interactions.PlayerInteractiveObject;
	import dynamics.player.Lumberjack;
	import dynamics.WorldObject;
	import framework.input.Controls;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import visual.Gas_can_mc;
	/**
	 * ...
	 * @author DG
	 */
	public class GasCan extends PlayerInteractiveObject
	{
		private var _body:Body;
		
		
		public function GasCan() 
		{
			type = TYPE_GAS_CAN;
			
			_body = build(Vec2.get(750, 150), [Polygon.rect(0, 0, 14, 21)], Material.wood(), Gas_can_mc);
			_body.userData.graphicOffset = new Vec2( -7, -10.5);	
			applySuperPreferences(_body);
			
			Collision.setFilter(_body, Collision.LUMBER_IGNORE);	
			
		}
		
		override public function onFocus():void 
		{
			super.onFocus();	
			label.x = _body.position.x;
			label.y = _body.position.y - 15;
		}
		
		override public function getPhysics():Body {
			return _body;
		}
		
		override public function onUse(params:Object):void {
			
			var lj:Lumberjack = params.parent;					
			if (Controls.keys.justPressed("E")) {		
				
				if (lj.luggage == this) {
					
					_body.space = space;
					container.layer2.addChild(_body.userData.graphic);
					_body.position = lj.getBody().position;
					
					_body.velocity = lj.getBody().velocity;
					_body.applyImpulse(Vec2.get(lj.facing * 10, -10));
					
					lj.luggage = null;
					
				}else if(lj.luggage == null) {
					lj.luggage = this;
					
					container.layer2.removeChild(_body.userData.graphic);
					_body.space = null;
					
				}
				
			}
		
		}
		
		
		
		
	}

}