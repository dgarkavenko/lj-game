package utils 
{
	import flash.display.DisplayObject;
	import nape.geom.Vec2;
	import nape.phys.Body;
	/**
	 * ...
	 * @author DG
	 */
	public class VisualAlignment 
	{
		
		public static function apply(body:Body):void {
			
		
			var graphic:DisplayObject = body.userData.graphic;
			if (graphic == null) return;
			
			var graphicOffset:Vec2 = body.userData.graphicOffset;
            var position:Vec2 = graphicOffset == null? body.worldCOM.copy() : body.localPointToWorld(graphicOffset);
			
            graphic.x = position.x;
            graphic.y = position.y;
            graphic.rotation = (body.rotation * 180/Math.PI) % 360;
            position.dispose();
			
			
		}
		
	}

}