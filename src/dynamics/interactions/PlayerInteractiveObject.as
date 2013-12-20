package dynamics.interactions 
{
	import dynamics.GameCb;
	import dynamics.WorldObject;
	import flash.display.Bitmap;
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
		protected var label_offset_y:int = 15;
		
		protected var label:MovieClip = new ArrowPointer_mc();
		protected var body:Body;
		protected var bitmap:Bitmap;
		
		public var type:uint = 0;
		
		static protected const TYPE_GAS_CAN:uint = 1
		static protected const TYPE_ENGINE:uint = 2	
		static protected const TYPE_BOAT:uint = 3	
		static protected const TYPE_WOOD:uint = 4;
		
		public function PlayerInteractiveObject() 
		{
			
		}
		
		public function returnToCache():void {
			
		}
		
		public function destroy():void {
			remove();
			returnToCache();
		}
		
		public function applySuperPreferences(body:Body):void {
			body.cbTypes.add(GameCb.PLAYER_INTERACTIVE);
			body.userData.onUse = onUse;
			body.userData.onFocus = onFocus;
			body.userData.onLeaveFocus = onLeaveFocus;
			body.userData.requires = requires;
		}
		
		public function remove():void {
			body.space = null;
			if (bitmap.parent) bitmap.parent.removeChild(bitmap);
		}
		
		public function add():void {
			GameWorld.playerInteractors.push(this);
		}
		
		public function pose(position:Vec2):void {
			body.position.setxy(position.x, position.y);
		}
		
		
		public function onUse(params:Object):void 
		{
			
		}
		
		public function onFocus():void 
		{
			container.layer2.addChild(label);
			label.x = body.position.x;
			label.y = body.position.y - label_offset_y;	
			
		}
		
		public function onLeaveFocus():void 
		{
			container.layer2.removeChild(label);
		}
		
		public function tick():void {
			
			if (label.parent) {
				label.x = body.position.x
				label.y = body.position.y - label_offset_y;
			}
		}
		
		public function requires(type:uint):Boolean {
			return false;
		}
		
		public function drop(carry:Body, dir:int):void 
		{
			
		}
		
		override public function getBody():Body {
			return body;
		}
		
	}

}