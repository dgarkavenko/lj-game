package fx.v 
{
	import gameplay.world.Ground;
	import idv.cjcat.emitter.deflectors.LineDeflector;
	import idv.cjcat.emitter.fields.UniformField;
	/**
	 * ...
	 * @author DG
	 */
	public class ParticlesConstant 
	{
		
		static public const GRAVITY:UniformField = new UniformField(0, 0.7)
		static public const GROUND_DEFLECTOR:LineDeflector = new LineDeflector(0, Game.SCREEN_HEIGHT - Ground.HEIGHT - 2);
		
		
	}

}