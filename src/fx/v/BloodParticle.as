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
	public class BloodParticle extends Particle
	{
		
		public function BloodParticle() 
		{
			super(BloodView);			
			bidirectional = false;
			directionVar = 90;
			direction = new Vector2D(0, -1);			
			speed = 7;		
			speedVar = 5;			
			
		
			rate = 1.4;
			life = 200;
			damping = .1;
			
			scaleVar = 2;
			
			addGravity(ParticlesConstant.GRAVITY);
			addDeflector(ParticlesConstant.GROUND_DEFLECTOR);
			
			rotationVar = 0;			
			massVar = 100;
			
		}
		
	}

}

import flash.display.Bitmap;
import flash.display.BitmapData;

class BloodView extends Bitmap {
	
	private static var bdata:BitmapData = new BitmapData(2, 2, false, 0x9e0707);	
	public function BloodView() {		
		super(bdata);
	}
	
}