package fx.v 
{
	import idv.cjcat.emitter.fields.UniformField;
	import idv.cjcat.emitter.geom.Vector2D;
	import idv.cjcat.emitter.Particle;
	/**
	 * ...
	 * @author DG
	 */
	public class DirtParticle extends Particle
	{
		
		public function DirtParticle() 
		{
			
			super(DustView);
			bidirectional = true;
			directionVar = 10;	
			speedVar = 1;
			speed = 7.5;
			
			direction = new Vector2D(1, 0);
		
			rate = 0.1;
			life = 20;
			
			scaleVar = 1;
			
			initScale = 6;
			finalScale = 3;			
			
			rotation = 0;
			rotationVar = 0;
			
			addGravity(new UniformField(0, -0.15));
			
			scaleGrowRange = 10;
			scaleDecayRange = 10;
			damping = 0.4;
			
			/*
			initAlpha = 1;
			finalAlpha = 0;
			
			alphaGrowRange = 1;
			
			alphaDecayRange = 10;*/
		}
		
	}
	




}
import flash.display.Bitmap;
import flash.display.BitmapData;

 class DustView extends Bitmap {
	
	private static var bdata:BitmapData = new BitmapData(1, 1, false, 0xccddcc);	
	public function DustView() {		
		super(bdata);
	}
	
}