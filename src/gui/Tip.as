package gui 
{
	import dynamics.Walker;
	import dynamics.WorldObject;
	import flash.display.Sprite;
	import framework.FormatedTextField;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author DG
	 */
	public class Tip extends Sprite
	{
	
		protected var container:Sprite = GameWorld.container;
		protected var _position:Vec2;
		protected var _offset:Vec2;
		
		private static var DEFAULT_OFFSET:Vec2 = new Vec2(0, -40);
		
		/**
		 * 
		 * @param	wo над кем будет висеть тип
		 */
		public function Tip(position:Vec2, offset:Vec2 = null, text:String = "" ) 
		{
			_position = position;
			_offset = offset;
			
			graphics.beginFill(0x363640, 1);
			graphics.drawRect( -45, -15, 90, 30);
			graphics.endFill();
			
			var tfield:FormatedTextField = new FormatedTextField(12);
			tfield.width = 80;
			tfield.height = 28;
			tfield.x = -43;
			tfield.y = -13;
			tfield.text = text;
			addChild(tfield);
			
			
		}
		
		public function show():void 
		{
			container.addChild(this);
			adjustPosition();
			
		}
		
		public function adjustPosition():void {
			x = _position.x + _offset.x;
			y = _position.y + _offset.y;
		}
		
	}

}