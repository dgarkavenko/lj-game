package dynamics.enemies 
{
	import dynamics.Collision;
	import dynamics.GameCb;
	import dynamics.WorldObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import visual.Wood_bitmap;
	/**
	 * ...
	 * @author DG
	 */
	public class Projectile extends WorldObject
	{
		private var _body:Body;
		private var _sprite:Bitmap;
		
		public function Projectile() 
		{
			_body = build(Vec2.get(750, 150), [Polygon.rect(0, 0, 10, 10)], Material.glass());
			_body.space = null;
			
			_body.cbTypes.add(GameCb.PROJECTILE);
			
			
			//_sprite = new Bitmap(new Spite());
			
			_body.userData.graphic = _sprite;
			_body.userData.onHit = onHit;
			Collision.setFilter(_body, Collision.LUMBER_IGNORE, Collision.TREE);	
		}
		
		public function onHit():void {
			$VFX.sawdust.at(_body.position.x, _body.position.y, 0, 300);
			remove();
		}
		
		public function add():void {
			_body.space = space;
			container.layer2.addChild(_sprite);
		}
		
		public function remove():void {
			_body.space = null;
			container.layer2.removeChild(_sprite);
		}
		
		override public function getPhysics():Body 
		{
			return _body;
		}
		
	}

}