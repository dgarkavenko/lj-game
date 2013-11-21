package dynamics.interactions 
{
	import dynamics.GameCb;
	import dynamics.WorldObject;
	import flash.display.MovieClip;
	import hud.ArrowPointer_mc;
	import nape.geom.Vec2;
	import nape.phys.Body;
	/**
	 * ...
	 * @author DG
	 */
	public class PlayerInteractiveObject extends WorldObject implements IPlayerInteractive
	{
		
		protected var label:MovieClip = new ArrowPointer_mc();
		public var type:uint = 0;
		
		static protected const TYPE_GAS_CAN:uint = 1
		static protected const TYPE_ENGINE:uint = 2	
		static protected const TYPE_BOAT:uint = 3	
		static protected const TYPE_WOOD:uint = 4;
		
		public function PlayerInteractiveObject() 
		{
			
		}
		
		public function destroy():void {
				
		}
		
		public function applySuperPreferences(body:Body):void {
			body.cbTypes.add(GameCb.PLAYER_INTERACTIVE);
			body.userData.onUse = onUse;
			body.userData.onFocus = onFocus;
			body.userData.onLeaveFocus = onLeaveFocus;
			body.userData.requires = requires;
		}
		
		
		public function onUse(params:Object):void 
		{
			
		}
		
		public function onFocus():void 
		{
			container.layer2.addChild(label);
			
		}
		
		public function onLeaveFocus():void 
		{
			container.layer2.removeChild(label);
		}
		
		public function tick():void {
			
			if (label.parent) {
				label.x = getBody().position.x
				label.y = getBody().position.y - 15;
			}
		}
		
		public function requires(type:uint):Boolean {
			return false;
		}
		
		public function drop(carry:Body, dir:int):void 
		{
			
		}
		
	}

}