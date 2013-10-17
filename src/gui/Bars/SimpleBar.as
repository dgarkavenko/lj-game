package gui.Bars 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author DG
	 */
	public class SimpleBar extends Sprite
	{
		
		
		private var bar:Bitmap;
		
		public function SimpleBar(w:int, h:int, color:uint, outline:Boolean = true, bgcolor:uint = 0x000000, bgalpha:Number = .5 ) 
		{
			bar = new Bitmap(new BitmapData(w, h, false, color));
			bar.x = -w/2;
			bar.y = -h/2;
			
			addChild(bar);
			
			if (outline) graphics.lineStyle(1, 0x202020);
			
			graphics.beginFill(bgcolor, bgalpha);
			graphics.drawRect(-w/2, -h/2, w, h);
			graphics.endFill();
		}
		
		public function scale(p:Number):void {
			bar.scaleX = p;
		}
		
	}

}