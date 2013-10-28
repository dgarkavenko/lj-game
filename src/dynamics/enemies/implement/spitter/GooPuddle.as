package dynamics.enemies.implement.spitter 
{
	import com.greensock.TweenLite;
	import dynamics.Collision;
	import dynamics.DynamicWorldObject;
	import dynamics.GameCb;
	import dynamics.WorldObject;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import utils.SimpleCache;
	import utils.VisualAlignment;

	import visual.z.Puddle_mc;
	/**
	 * ...
	 * @author DG
	 */
	public class GooPuddle extends DynamicWorldObject
	{
		private var _body:Body;
		
		private var _sprite:MovieClip;
		private var lifetime:int = 100;
		
		public static var cache:SimpleCache = new SimpleCache(GooPuddle, 1);
		
		public function GooPuddle() 
		{
			_body = new Body(BodyType.STATIC);
			
			
			//'feathers' in tail of arrow
			// use a mateiral with very low density (to avoid weight being shifted to back) and high friction
			// to increase fluid drag on tail (feathers 'grip' the air)
			_body.shapes.add(new Polygon(Polygon.box(70, 5)));
			_body.shapes.at(0).sensorEnabled = true;	
			
			
			_body.align();
			_body.allowRotation = false;			
			_body.cbTypes.add(GameCb.PUDDLE);	
			
			_sprite = new Puddle_mc();
			_body.userData.graphic = _sprite;
			_body.userData.graphicOffset = new Vec2(-_sprite.width/2 - 20, -9);
		
			Collision.setFilter(_body, Collision.LUMBER_IGNORE, ~Collision.LUMBER_IGNORE);
			
		}
		
		override public function tick():void 
		{
			
			lifetime--;
			if (lifetime < 0) {
				remove();
			}
			
			
			$VFX.gooPuddle.at(_body.position.x, _body.position.y, 0, -1, 1);			
		}
		
		private function remove():void 
		{
			_body.space = null;
			GameWorld.removeOnTick(this);
			TweenLite.to(_sprite, 2, { alpha:0, onComplete:destroy } );
			
		}
		
		private function destroy():void {
			container.layer1.removeChild(_sprite);			
			cache.setInstance(this);
		}
		
		public function add(x:int, y:int):void {	
			_sprite.gotoAndPlay(1);
			_sprite.alpha = 1;
			
			GameWorld.regOnTick(this)
			_body.position.setxy(x, Game.SCREEN_HEIGHT - 31);
			_body.space = space;
			container.layer1.addChild(_sprite);
			VisualAlignment.apply(_body);
		}
		
	}

}