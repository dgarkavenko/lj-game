package fx.v 
{
	import idv.cjcat.emitter.fields.UniformField;
	import idv.cjcat.emitter.geom.Vector2D;
	import idv.cjcat.emitter.Particle;
	/**
	 * ...
	 * @author DG
	 */
	public class DustParticle extends Particle
	{
		
		public function DustParticle() 
		{
			
			super(DustView);
			bidirectional = false;
			directionVar = 20;	
			speedVar = 2;
			speed = 2;
			
			direction = new Vector2D(0, -2);
		
			rate = 1.4;
			life = 10;
			
			initScale = 5;
			finalScale = 2;			
			
			rotation = 0;
			rotationVar = 0;
			
			addGravity(new UniformField(0, -0.0002));
			
			scaleGrowRange = 10;
			scaleDecayRange = 10;
			damping = 0.2;
			
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
	
	private static var bdata:BitmapData = new BitmapData(1, 1, false, 0xffffee);	
	public function DustView() {		
		super(bdata);
	}
	
}