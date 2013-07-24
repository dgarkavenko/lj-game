package dynamics.enemies 
{
	import com.greensock.TweenLite;
	import dynamics.actions.ActionTypes;
	import dynamics.actions.IAction;
	import dynamics.BaseSpriteControl;
	import dynamics.Collision;
	import dynamics.GameCb;
	import dynamics.interactions.IInteractive;
	import dynamics.Walker;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import gamedata.DataSources;
	import gameplay.world.Ground;
	import gui.Bars.HealthBarCache;
	import gui.Bars.SimpleBar;
	import gui.PopText;
	import gui.Tip;
	import idv.cjcat.emitter.ds.MotionData2DPool;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Interactor;
	import nape.phys.Material;
	import nape.shape.Polygon;	
	import zombie.Stinker_mc;
	
	/**
	 * ...
	 * @author DG
	 */
	public class Dummie extends Walker implements IInteractive 
	{
		private var _tip:Tip;		
		private var sprite:MovieClip;
		
		private var max_hp:int = 50;
		private var hp:int = 50;
		
		private var lj_pos:Vec2;
		private var speed:int = 11 + Math.random() * 4;
		
	
		private static var healthBars:HealthBarCache = new HealthBarCache(5);
		private var health_bar:SimpleBar;
		
		//private static var z_shape:Array = [];
		
		
		
		public function Dummie(X:int, Y:int) 
		{
			
			
			sprite = new MovieClip;
			_view = new BaseSpriteControl(Stinker_mc);
			
			
			sprite = _view.sprite;
			
			var w:int = _view.sprite.width;
			var h:int = _view.sprite.height;
			
			_body = build(Vec2.get(X, Y), [Polygon.rect(0,0, 12, 42), [5,Vec2.get(6,46)]], Material.wood());

			
			_body.cbTypes.add(GameCb.INTERACTIVE);
			_body.cbTypes.add(GameCb.ZOMBIE);
			
			
			_body.userData.graphic = _view.sprite;		
			container.layer2.addChild(_view.sprite);
			
			_body.userData.interact = interact;	
			
			//_tip = new Tip(_body.position, new Vec2(0, -50), "Oh, please!");
			
			_body.allowRotation = false;
			
			// Дамми, может встретиться только с «никем» и лучом
			Collision.setFilter(_body, Collision.DUMMIES, ~(Collision.LUMBER_IGNORE|Collision.DUMMIES) );
			
			lj_pos = GameWorld.lumberbody.position;
			
			setTimeout(_view._sprite.play, 200 + Math.random() * 500);
			
		}		
		
		override public function getPhysics():Body {
			return _body;
		}
		
		/* INTERFACE dynamics.interactions.IInteractive */
		
		public function interact(action:IAction):void 
		{
			if (hp <= 0) return;
			var params:Object = action.params;
			
			switch (action.type) 
			{
				case ActionTypes.CHOP_ACTION:
					
					$VFX.blood.at(params.x, params.y, -params.facing, 0, params.power * 4);
					_body.applyImpulse(Vec2.get(params.facing * params.power * 3, 0));
					hp -= params.power * params.z_dmg;
					
					show_hp();
					
				break;
				
				case ActionTypes.GUNSHOT_ACTION:
				
					var h:int = sprite.height;					
					var c:int = _body.position.y;
					var mod:int = 1;
					
					if (params.y < c - h / 2 + 10) mod = 2;
					
					$VFX.blood.at(params.x, params.y, -params.facing, 0, params.power * mod);
					_body.applyImpulse(Vec2.get(params.facing * params.power, 0));					
					hp -= params.power * mod;
					
					if (hp <= 0) {
						
						_body.applyImpulse(Vec2.get(params.facing * params.power * 3, 0));
					}
					
					show_hp();
					
				break;
				
				case ActionTypes.TREE_HIT:
					$VFX.blood.at(params.x, params.y, 0, -1, 100);
					squash();
					return;
				break;
				default:
			}
			
			
			if (hp <= 0) dead(params);
			
			
		}
		
		private function show_hp():void 
		{
			if (hp <= 0) return;
			//trace(hp);
			
			if (health_bar == null) {
				health_bar = healthBars.getInstance() as SimpleBar;		
				container.layer0.addChild(health_bar);
			}
			
			health_bar.alpha = 1;
			health_bar.scale(hp / max_hp);				
			TweenLite.killTweensOf(health_bar);			
			TweenLite.to(health_bar, .2, {delay:2, alpha:0, onComplete:onHide } );
			
		}
		
		private function onHide():void {
			healthBars.setInstance(health_bar);
			container.layer0.removeChild(health_bar);
			health_bar = null;
		}
		
		private function dead(params:Object = null):void 
		{
			
			_view._sprite.stop();
			
			PopText.at("$10", _body.position.x, _body.position.y, 0xbbee48);
			DataSources.lumberkeeper.money += 10;
			
			
			
			if (health_bar != null) {
				TweenLite.killTweensOf(health_bar);
				TweenLite.to(health_bar, .2, { alpha:0, onComplete:onHide } );
			}
			
			var f:int = params.facing;
			
			if (params.y > _body.position.y) f = -f;
			
			_body.allowRotation = true;
			_body.applyImpulse(Vec2.get( (f * Math.random()), 0), Vec2.get(0, -20));
			setTimeout(hide, 1000);
		}
		
		
		private function squash():void {
			hp = 0;
			_body.allowRotation = true;
			container.layer2.removeChild(sprite);
			container.layer3.addChildAt(sprite, 0);
			
			//Collision.setFilter(_body, Collision.NULL_OBJECT, ~Collision.NULL_OBJECT);
			Collision.setFilter(_body, Collision.LUMBER_IGNORE, Collision.NULL_OBJECT);
			
			//TweenLite.to(sprite, 10, { y: sprite.y + 50, onComplete:remove, delay:0 } );
			
		
		}
		
		private function hide():void {
			
			Collision.setFilter(_body, Collision.LUMBER_IGNORE, ~Collision.LUMBER_IGNORE );
			TweenLite.to(sprite, 10, { y: sprite.y + 50, onComplete:remove, delay:3} );
			
		}
		
		private function remove():void {
			_body.space = null;
			container.layer2.removeChild(sprite);
		}
		
		override public function tick():void 
		{
			if (hp <= 0) return;			
			if (Math.abs(lj_pos.x - _body.position.x) < 10) return;
			
			var d:int = 1;
			if (lj_pos.x < _body.position.x) d = -1;
			
			_view.face(d);
			_body.velocity.x = 0;
			_body.applyImpulse(Vec2.get(d * speed, 0));
			
			if (health_bar != null) {
				health_bar.x = _body.position.x;
				health_bar.y = _body.position.y - sprite.height / 2 - 10;
			}
			
			
			
		}
		
		
		
		
		
		
	}

}