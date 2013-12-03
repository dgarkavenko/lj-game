package framework 
{
	import flash.display.Sprite;
	import framework.screens.GameScreen;
	import nape.geom.Ray;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	/**
	 * ...
	 * @author DG
	 */
	public class PhysDebug 
	{
		static private var debug:ShapeDebug;
		static public var is_active:Boolean = false;
		
		static public var debug_rays:Vector.<Ray> = new Vector.<Ray>();
		
		
		static public var container:SpriteContainer = GameWorld.container;
		static public var space:Space = GameWorld.space;
		
		public function PhysDebug() 
		{
			
		
		}
		
		static public function on():void 
		{
			if (!debug) {
				debug = new ShapeDebug(Game.SCREEN_WIDTH,  Game.SCREEN_HEIGHT, 0xFFFFFF);
				debug.drawCollisionArbiters = true;
				debug.drawConstraints = true;	
			}
			
			is_active = true;
			container.addChild(debug.display);
		}
		
		static public function off():void {
			container.removeChild(debug.display);
			is_active = false;
		}
		
		static public function tick():void 
		{
			if (!is_active) return;
			
			debug.clear();
			debug.draw(space);
			
			for each (var r:Ray in debug_rays ) 
			{
				debug.drawCircle(r.origin, 2, 0xff0000);
				debug.drawLine(r.origin, r.at(r.maxDistance), 0xff0000);
			}
		}
		
		static public function addDebugRay(ray:Ray):void {
			debug_rays.push(ray);
			
			
		}
		
	}

}