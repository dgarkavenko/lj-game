package framework 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author DG
	 */
	public class SpriteContainer extends Sprite
	{
		/**
		 * Foreground layer: water
		 */
		public var layer0:Sprite;
		
		
		/**
		 * Ground
		 */
		public var layer1:Sprite;
		
		/**
		 * Dynamics layer
		 */
		public var layer2:Sprite;
		
		/**
		 * Trees
		 */
		public var layer3:Sprite;
		
		/**
		 * Background layer
		 */
		public var layer4:Sprite;
		
		public function SpriteContainer() 
		{
			layer0 = new Sprite();
			layer1 = new Sprite();
			layer2 = new Sprite();
			layer3 = new Sprite();
			layer4 = new Sprite();
			
			addChild(layer4);
			addChild(layer3);
			addChild(layer2);
			addChild(layer1);
			addChild(layer0);
			
			
		}
		
	}

}