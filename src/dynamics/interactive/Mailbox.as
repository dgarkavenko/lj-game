package dynamics.interactive 
{
	import dynamics.Collision;
	import dynamics.interactions.PlayerInteractiveObject;
	import flash.display.Bitmap;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import visuals.SignBMP;
	/**
	 * ...
	 * @author DG
	 */
	public class Mailbox extends PlayerInteractiveObject
	{
		private var _body:Body;
		
		public function Mailbox() 
		{
			
		}
		
		override public function getPhysics():Body {
			return _body;
		}
		
	}

}