package dynamics.enemies.implement.spitter 
{
	import dynamics.Collision;
	import dynamics.DynamicWorldObject;
	import dynamics.GameCb;
	import dynamics.WorldObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import utils.SimpleCache;
	import visual.Wood_bitmap;
	import visual.z.Goo;
	/**
	 * ...
	 * @author DG
	 */
	public class GooProjectile extends DynamicWorldObject
	{
		private var _body:Body;
		private var _sprite:Bitmap;
		
		
		public static var cache:SimpleCache = new SimpleCache(GooProjectile, 5);
		
		public function GooProjectile() 
		{
			
			
			_body = new Body();
			_body.space = null;
			
			//'feathers' in tail of arrow
			// use a mateiral with very low density (to avoid weight being shifted to back) and high friction
			// to increase fluid drag on tail (feathers 'grip' the air)
			_body.shapes.add(new Circle(5, Vec2.get(0, 0), new Material(0, 5, 2, 14.95)));
			_body.shapes.at(0).sensorEnabled = true;	
			_body.align();
			_body.allowRotation = false;
			
			_body.cbTypes.add(GameCb.PROJECTILE);
			
			_sprite = new Bitmap(new Goo());
			_body.userData.graphicOffset = new Vec2( -_sprite.width / 2, -_sprite.height / 2);
			
			_body.userData.graphic = _sprite;
			_body.userData.onHit = onHit;
			
		}
		
		public function onHit():void {
			
			
			$VFX.gooPuddle.at(_body.position.x, _body.position.y, 0, -1);
			var p:GooPuddle = GooPuddle.cache.getInstance() as GooPuddle;
			p.add(_body.position.x, _body.position.y);
			destroy();
		}
		
		public function add(rot:Number):void {
			
			
			GameWorld.regOnTick(this)
			_body.space = space;		
			_body.rotation = rot;
			container.layer2.addChild(_sprite);
			
			
		}
		
		
		override public function tick():void 
		{
			$VFX.goo.at(_body.position.x, _body.position.y, 0, -1, 5);
		}
		
		
		
		override public function destroy():void {		
			
			
			if (_body.space == null) return;
			_body.space = null;
			GameWorld.removeOnTick(this)
			
			container.layer2.removeChild(_sprite);
			cache.setInstance(this);
			
		}
		
		override public function getBody():Body 
		{
			return _body;
		}
		
	}

}