package fx.v 
{
	import idv.cjcat.emitter.deflectors.LineDeflector;
	import idv.cjcat.emitter.fields.Field;
	import idv.cjcat.emitter.fields.UniformField;
	import idv.cjcat.emitter.geom.Vector2D;
	import idv.cjcat.emitter.Particle;
	
	/**
	 * ...
	 * @author DG
	 */
	public class GooParticle extends Particle
	{
		
		public function GooParticle() 
		{
			super(GooView);			
		
			rotationVar = 0;
			scaleVar = 2;
			
			bidirectional = false;
			directionVar = 20;
			direction = new Vector2D(0, -1);			
			speed = 1;			
		
			rate = 1;
			life = 100;
		
			initScale = 1;
			finalScale = 8;
			
			
			
			scaleDecayRange = 1;
			
			initAlpha = 1;
			finalAlpha = 0;
			
			alphaGrowRange = 1;
			alphaDecayRange = 10;
			
		}
		
	}

}

import flash.display.Bitmap;
import flash.display.BitmapData;

class GooView extends Bitmap {
	
	private static var bdata:BitmapData = new BitmapData(1, 1, false, 0x88f748);	
	public function GooView() {		
		super(bdata);
	}
	
}