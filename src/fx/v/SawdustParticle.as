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
	public class SawdustParticle extends Particle
	{
		
		public function SawdustParticle() 
		{
			super(SawdustView);			
			bidirectional = false;
			directionVar = 60;
			direction = new Vector2D(0, -1);			
			speed = 5;		
			speedVar = 5;
		
			rate = 1;
			life = 25;
			damping = .05;
			
		
			
			addGravity(ParticlesConstant.GRAVITY);
			addDeflector(ParticlesConstant.GROUND_DEFLECTOR);
			
			rotationVar = 0;
			scaleVar = .5;			
			massVar = 50;
			
		}
		
	}

}

import flash.display.Bitmap;
import flash.display.BitmapData;

class SawdustView extends Bitmap {
	
	private static var bdata:BitmapData = new BitmapData(2, 2, false, 0xfaf0d3);	
	public function SawdustView() {		
		super(bdata);
	}
	
}