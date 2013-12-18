package framework.screens.MapScreen 
{
	import flash.events.MouseEvent;
	import framework.FormatedTextField;
	import locations.LocationManager;
	/**
	 * ...
	 * @author dg
	 */
	public class MapElement extends FormatedTextField
	{
		
		public var location:Class;
		
		public function MapElement(tx:String, loc:Class) 
		{
			super(12, 0xffffff);
			text = tx;
			location = loc;
			
		}
		
		
	}

}