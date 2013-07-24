package gameplay.world 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author DG
	 */
	public class Light 
	{
		
		public var x:Number;
		public var y:Number;
		
		public var width:int;
		public var height:int;
		
		public var source:String;
		private var _bitmap:BitmapData;
		
		public function Light(source_:String) 
		{
			source = source_;			
		}
		
		public function set bitmap(value:BitmapData):void 
		{
			_bitmap = value;
			width = _bitmap.width;
			height = _bitmap.height;
		}
		
		public function get bitmap():BitmapData 
		{
			return _bitmap;
		}
		
	}

}