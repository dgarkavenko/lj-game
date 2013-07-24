package framework.input 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author DG
	 */
	public class Controls 
	{
		
		public static var keys:Keyboard = new Keyboard();
		public static var mouse:Mouse = new Mouse();
		
		public static function init(sprite:Sprite):void {
			keys.init(sprite);
			mouse.init(sprite);
		}
		
		static public function update():void 
		{
			keys.update();
			mouse.update();
		}
		
	}

}