package gameplay.world 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import visual.Gas_station_mc;
	import visual.Ground_w_road_bitmap;
	/**
	 * ...
	 * @author DG
	 */
	public class Enviroment 
	{		
		
		public static function place_GasStation(x:int, g:Ground):void {
			
			
			return;
			//GAS STATION SPRITE
			var gs:MovieClip = new Gas_station_mc();
			GameWorld.container.addChild(gs);
			
			
			var gmc:Bitmap = g.getGroundBitmap();			
			gmc.bitmapData.draw(new Ground_w_road_bitmap(), new Matrix(1,0,0,1, x - gmc.x));
			
			gs.x = x + 260 + gs.width/2;
			gs.y = 306;		
			
		}
		
	}

}