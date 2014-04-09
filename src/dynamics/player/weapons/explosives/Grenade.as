package dynamics.player.weapons.explosives 
{
	import dynamics.actions.CaboomAction;
	import dynamics.Collision;
	import dynamics.DynamicWorldObject;
	import dynamics.enemies.base.Dummy;
	import flash.display.Bitmap;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Circle;
	import utils.SimpleCache;
	import visual.fx.black_explosion_mc;
	import visual.z.Goo;
	/**
	 * ...
	 * @author DG
	 */
	public class Grenade extends DynamicWorldObject
	{
		protected var _body:Body;
		protected var _sprite:Bitmap;
		protected var timer:int = 90;
		
		public static var greandeCache:SimpleCache = new SimpleCache(Grenade, 3);
		private var boomAction:CaboomAction = new CaboomAction();
		
		public function Grenade() 
		{
			_body = new Body();
			_body.space = null;			
			
			_body.shapes.add(new Circle(5, Vec2.get(0, 0), new Material(0, 5, 2, 14.95)));
			//_body.shapes.at(0).sensorEnabled = true;	
			_body.align();
			_body.allowRotation = false;		
			
			Collision.setFilter(_body, Collision.LUMBER_IGNORE);
			
			_sprite = new Bitmap(new Goo());
			_body.userData.graphicOffset = new Vec2( -_sprite.width / 2, -_sprite.height / 2);			
			_body.userData.graphic = _sprite;
			
		}		
	
		
		public function add(pos:Vec2, acc:Vec2):void {
			
			timer = 120;
			
			_body.position = pos;
			_body.applyImpulse(acc);
			
			GameWorld.regOnTick(this)
			_body.space = space;		
			container.layer2.addChild(_sprite);		
			
			
		}
		
		override public function destroy():void {		
			
			if (_body.space == null) return;
			_body.space = null;
			GameWorld.removeOnTick(this)			
			container.layer2.removeChild(_sprite);
			greandeCache.setInstance(this);			
		}
		
		override public function tick():void 
		{
			timer--;
			if (timer <= 0) {
				boom();
			}
		}
		
		private function boom():void 
		{
			var explosion:black_explosion_mc = new black_explosion_mc();
			GameWorld.container.layer2.addChild(explosion);
			explosion.x = _body.position.x;
			explosion.y = _body.position.y;
			
			for each (var z:Dummy in GameWorld.zombies) 
			{
				var b:Body = z.getBody();		
				var d:Number = Vec2.distance(b.position, _body.position);
				
				if (d < 150) {
					
					boomAction.params.power = 2000 / d;
					z.interact(boomAction);
					b.applyImpulse(new Vec2( -_body.position.x + b.position.x, -_body.position.y + b.position.y).mul(80 / d)); 
					
					
				}
			
				
			}
			
			destroy();
		}
		
		
		override public function getBody():Body 
		{
			return _body;
		}
		
	}

}