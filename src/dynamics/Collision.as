package dynamics 
{
	import nape.dynamics.InteractionGroup;
	import nape.phys.Body;
	import nape.phys.Interactor;
	import nape.shape.Shape;
	import utils.SimpleCache;
	/**
	 * ...
	 * @author DG
	 */
	public class Collision 
	{
		
		public static var rootgroup:InteractionGroup = new InteractionGroup(true);
		public static var dead:InteractionGroup = new InteractionGroup();
		public static var tree:InteractionGroup = new InteractionGroup();
		public static var groups:SimpleCache = new SimpleCache(InteractionGroup, 6);
		
		public static const LUMBER_IGNORE:uint = 2; 
		static public const NULL_OBJECT:uint = 8;		
		static public const LUMBER_RAY:uint = 4;
		static public const TREE:uint = 16;
		static public const DUMMIES:uint = 32;
		static public const IO:uint = 64;
		static public const TRUNK:uint = 128;
		static public const PEN:uint = 256;
		
		
		
		public static function setFilter(body:Body, group:uint = NaN, mask:uint = NaN):void {
			
			var eachShape:Function = function(s:Shape):void {			
				if (mask) s.filter.collisionMask = mask;
				if (group) s.filter.collisionGroup = group;
			}
			
			body.shapes.foreach(eachShape);
		}
		
		
		
	}

}