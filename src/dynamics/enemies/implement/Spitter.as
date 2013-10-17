package dynamics.enemies.implement 
{
	import dynamics.actions.ActionTypes;
	import dynamics.actions.IAction;
	import dynamics.BaseSpriteControl;
	import dynamics.Collision;
	import dynamics.enemies.base.Ranged;
	import dynamics.enemies.base.Dummy;
	import dynamics.enemies.implement.spitter.GooProjectile;

	import dynamics.GameCb;
	import dynamics.interactions.IInteractive;
	import dynamics.Walker;
	import flash.display.MovieClip;
	import flash.events.Event;
	import gui.Bars.HealthBarCache;
	import gui.Bars.SimpleBar;
	import nape.geom.Vec2;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import utils.SimpleCache;

	
	/**
	 * ...
	 * @author DG
	 */
	public class Spitter extends Ranged
	{
		
		private var sprite:MovieClip;
		
		private var max_hp:int = 50;
		
		
		private static var lj_pos:Vec2;
		
		private var ite:int = 0;
	
		
		
		public function Spitter() 
		{			
			super("spitter");
			
			sprite = new MovieClip();			
			sprite = _view.sprite;	
			lj_pos = GameWorld.lumberbody.position;
			
		}
		
		
		
		
		override protected function getConditions():void 
		{
			
			_conditions.clear();
			
			var distance:Number = Vec2.distance(_body.position, lj_pos);
			
			
			
			var dir:Boolean = (_facing == 1 && _body.position.x < lj_pos.x) || (_facing == -1 && _body.position.x > lj_pos.x);
			
			//if ( distance < meleeRange && meleeAttackCooldown <= 0) _conditions.set(CONDITION_CAN_MELEE_ATTACK);
			if ( distance < 200 && dir) _conditions.set(CONDITION_CAN_RANGED_ATTACK);		
			if (distance < 270) _conditions.set(CONDITION_SEE_ENEMY);
			
			_conditions.set(CONDITION_CAN_STAND);
			_conditions.set(CONDITION_CAN_WALK);
			
			
		}
		
		
		
		override protected function onInitRangedAttack():Boolean
		{		
			view.melee();
			sprite.mc.addEventListener("onAttack", launchProjectile);			
			return true;
		}
		
		private function launchProjectile(e:Event = null):void 
		{
			
			var d:int = 1;
			if (lj_pos.x < _body.position.x) d = -1;
			
			facing = d;
			
			
			
			
			sprite.mc.removeEventListener("onAttack", launchProjectile);
			
			var p:GooProjectile = GooProjectile.cache.getInstance() as GooProjectile;	
			
			
			var rot:Number = Math.PI / 2 - Math.PI / 2 * d;			
			
			
			p.add(rot);			
			p.getBody().position = _body.position.add(Vec2.get(10 * d, - 15));
			p.getBody().velocity.setxy(2.7 * Vec2.distance(_body.position, lj_pos), 0);
			p.getBody().velocity.angle = rot;
			
			
			
		}
		
		override protected function onRangedAttack():Boolean 
		{
			
			return (sprite.mc.currentFrame == sprite.mc.totalFrames) ? true : false;
			
		}
		
		override protected function onEndRangedAttack():Boolean 
		{			
			rangedAttackCooldown = 120;			
			view.idle();
			return true;
		}
		
		override protected function onEndMeleeAttack():Boolean 
		{
			return true;
		}
		
		override protected function onMeleeAttack():Boolean 
		{
			return true;
		}
		
		
		override protected function onInitStand():Boolean
		{
			view.idle();
			_interval = rangedAttackCooldown <= 0 ? 25 + Math.random() * 25 : rangedAttackCooldown;
			return true;
		}
		
		
		
		override protected function onInitMeleeAttack():Boolean
		{
			view.melee();
			
			return true;
		}
		
		/**
		 * Процесс действия ожидания.
		 */
		override protected function onStand():Boolean
		{
			_interval--;
			if (_interval <= 0)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * Инициализация действия движения.
		 */
		override protected function onInitMove():Boolean
		{
			
			var f:int = (Math.random() + 0.5);
			f = f == 0? f = -1 : f = 1;
			
			facing = f;
			
			view.walk();		
			_interval =  25 + Math.random() * 25;
			
			return true;
		}
		
		/**
		 * Процесс действия движения.
		 */
		override protected function onMove():Boolean
		{
			_body.velocity.x = 0;
			_body.applyImpulse(Vec2.get(_facing * movementSpeed, 0));
	
			
			_interval--;
			if (_interval <= 0)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * Инициализация действия преследования.
		 */
		override protected function onInitPursuit():Boolean
		{
			
			view.walk();
			return true;
		}
		
		/**
		 * Процесс действия преследования.
		 */
		override protected function onPursuit():Boolean
		{
			var d:int = 1;
			if (lj_pos.x < _body.position.x) d = -1;			
			facing = d;
			
			_body.velocity.x = 0;
			_body.applyImpulse(Vec2.get(d * movementSpeed, 0));			
			
			return false;
		}
		
		override public function tick():void {
			super.tick();
			if (currentHP <= 0) return;
			
			if (++ite >= 10) {
				
				getConditions();			
				if (_currentShedule != null && _currentShedule.isCompleted(_conditions))
				{
					selectNewSchedule();
				}
				
				ite = 0;
				
			}
			
			if (rangedAttackCooldown > 0) rangedAttackCooldown--;
			
			
			
			if (_currentShedule != null) {
				_currentShedule.update();
			}
			
		}
		
	}

}