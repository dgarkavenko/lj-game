package dynamics.staticbuildings 
{
	import dynamics.GameCb;
	import dynamics.WorldObject;
	import flash.display.Bitmap;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import utils.VisualAlignment;
	import visual.GasStation_bitmap;
	/**
	 * ...
	 * @author DG
	 */
	public class GasStation extends WorldObject
	{
		private var gasstation:Body;
		private var asset:Bitmap;
		
		public function GasStation() 
		{			
			gasstation = build( new Vec2(360, 241), [[new Vec2(0,127), new Vec2(0, 82), new Vec2(43, 74), new Vec2(43,127)],[new Vec2(43,127), new Vec2(43,0), new Vec2(210,0), new Vec2(210,127)]], Material.wood());		
			gasstation.type = BodyType.STATIC
			asset = new Bitmap(new GasStation_bitmap());
			gasstation.userData.graphicOffset = new Vec2( -240 / 2, - 132 / 2);
			gasstation.cbTypes.add(GameCb.GROUND);
			GameWorld.container.layer4.addChild(asset);
			gasstation.userData.graphic = asset;
			VisualAlignment.apply(gasstation);
		}		
	
		public function Destroy():void {
			gasstation.space = null;
			gasstation = null;
			trace(asset.parent);
			asset = null;
		}
		
	}

}