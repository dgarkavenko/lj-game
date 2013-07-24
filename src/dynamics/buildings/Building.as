package dynamics.buildings 
{
	import dynamics.GameCb;
	import dynamics.interactions.IInteractive;
	import dynamics.interactions.ITipSpitter;
	import dynamics.WorldObject;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	/**
	 * ...
	 * @author DG
	 */
	public class Building extends WorldObject implements ITipSpitter, IInteractive
	{
		
		protected var _body:Body;
		
		public function Building() 
		{
			
		}
		
		override public function build(position:Vec2, shapes:Array, material:Material, graphics:Class = null):Body {
			_body = super.build(position, shapes, material, graphics);
			_body.cbTypes.add(GameCb.BUILDING);
			_body.cbTypes.add(GameCb.INTERACTIVE);
			_body.cbTypes.add(GameCb.TIP);
			
			
			_body.setShapeFilters();
		}
		
		/* INTERFACE dynamics.interactions.ITipSpitter */
		
		public function showTip():void 
		{
			
		}
		
		public function hideTip():void 
		{
			
		}
		
		/* INTERFACE dynamics.interactions.IInteractive */
		
		public function interact(type:String, params:Object = null):void 
		{
			
		}
		
	}

}