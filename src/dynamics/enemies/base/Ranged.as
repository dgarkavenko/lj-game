package dynamics.enemies.base 
{
	import dynamics.enemies.ai.Schedule;
	import dynamics.enemies.base.Dummy;
	import flash.events.Event;
	import framework.screens.GameScreen;
	import gui.PopText;
	import nape.geom.Vec2;

	
	/**
	 * ...
	 * @author dg
	 */
	public class Ranged extends Standart
	{
		protected var rangedAttackCooldown:int = 0;
		protected var rangedAttackCooldownSize:int = 120;
		protected var rangedAttack:Schedule;
		protected var rangedAttackRange:int = 150;
		
		protected var numberOfProjectiles:int = 1 + Math.random() * 3;
		protected var initalnumberOfProjectiles:int;
		
		public function Ranged(alias:String) 
		{
			super(alias);
			
			rangedAttack = new Schedule("RangeAttack");
			rangedAttack.addFewTasks([ onInitRangedAttack, onRangedAttack, onEndRangedAttack ]);
			rangedAttack.addFewInterrupts([CONDITION_CAN_MELEE_ATTACK]);
		}
		
		override protected function reset():void{
			super.reset();
			numberOfProjectiles = initalnumberOfProjectiles;
		}
		
		override protected function getConditions():void 
		{
			
			_conditions.clear();
			
			var distance:Number = Vec2.distance(_body.position, daddy.lumbervec);			
			
			
			var viewDirTowardsLj:Boolean = (_facing == 1 && _body.position.x < daddy.lumbervec.x) || (_facing == -1 && _body.position.x > daddy.lumbervec.x);
			
			if ( distance < meleeAttackRange && viewDirTowardsLj) {
				_conditions.set(CONDITION_CAN_MELEE_ATTACK);
				_conditions.set(CONDITION_CAN_RANGED_ATTACK);	
				_conditions.set(CONDITION_SEE_ENEMY);
			}else if ( distance < rangedAttackRange && viewDirTowardsLj && numberOfProjectiles > 0 && distance > meleeAttackRange * 2 ) {
				_conditions.set(CONDITION_CAN_RANGED_ATTACK);	
				_conditions.set(CONDITION_SEE_ENEMY);
			}else if ((distance < viewRange && viewDirTowardsLj) || worried || distance < senceRange) {
				_conditions.set(CONDITION_SEE_ENEMY);
			}
			
			_conditions.set(CONDITION_CAN_STAND);
			_conditions.set(CONDITION_CAN_WALK);
			
			
		}
		
		override protected function setParameters(ref:Object):void {
			super.setParameters(ref);
			rangedAttackCooldownSize = ref.rangedAttackCooldown * 30;
			rangedAttackRange = ref.rangedAttackRange;
			initalnumberOfProjectiles = numberOfProjectiles = ref.ammoCount;
		}
		
		
		protected function onInitRangedAttack():Boolean
		{		
			_view.ranged();
			_view.sprite.mc.addEventListener("onAttack", launchProjectile);			
			return true;
		}
		
		protected function launchProjectile(e:Event = null):void 
		{			
			_view.sprite.mc.removeEventListener("onAttack", launchProjectile);			
			numberOfProjectiles--;
			if (numberOfProjectiles == 0) PopText.at("OUT OF AMMO", _body.position.x, _body.position.y - 20, 0xffffff);
		}
		
		protected function onRangedAttack():Boolean 
		{
			
			return (_view.sprite.mc.currentFrame == _view.sprite.mc.totalFrames) ? true : false;
			
		}
		
		protected function onEndRangedAttack():Boolean 
		{			
			rangedAttackCooldown = rangedAttackCooldownSize;			
			_view.idle();
			return true;
		}		
		
		
		override protected function onInitStand():Boolean
		{
			_view.idle();
			_interval = rangedAttackCooldown <= 0 ? 25 + Math.random() * 25 : rangedAttackCooldown;
			return true;
		}	
		
		
		override public function tick():void {
			super.tick();
			if (rangedAttackCooldown > 0) rangedAttackCooldown--;		
			
		}
		
		override protected function selectNewSchedule():void 
		{
			switch (_state) 
			{
				case STATE_STAND:
					if (_conditions.contains(CONDITION_CAN_MELEE_ATTACK)) {
						
						_state = STATE_MELEE;
						_currentShedule = meleeAttack;
						
					}else if (_conditions.contains(CONDITION_CAN_RANGED_ATTACK)) {
						
						if ( rangedAttackCooldown > 0) {
							_state = STATE_STAND;
							_currentShedule = stand;
							
						}else {							
							_state = STATE_RANGED;
							_currentShedule = rangedAttack;
						}
						
						
					}else if (_conditions.contains(CONDITION_SEE_ENEMY)) {
						
						_state = STATE_PURSUIT;
						_currentShedule = pursuit;
						
					}else if (_conditions.contains(CONDITION_CAN_WALK)) {
						_state = STATE_WALK;
						_currentShedule = move;
					}
				break;
				
				case STATE_WALK:				
				case STATE_PURSUIT:				
				case STATE_RANGED:				
				case STATE_MELEE:
					
					if (_conditions.contains(CONDITION_CAN_MELEE_ATTACK))
					{
						_currentShedule = meleeAttack;
						_state = STATE_MELEE;
					}
					else if (_conditions.contains(CONDITION_CAN_RANGED_ATTACK))
					{
						if ( rangedAttackCooldown > 0) {
							_state = STATE_STAND;
							_currentShedule = stand;
							
						}else {							
							_state = STATE_RANGED;
							_currentShedule = rangedAttack;
						}
						
					}else if (_conditions.contains(CONDITION_SEE_ENEMY)) {
						
						_currentShedule = pursuit;
						_state = STATE_PURSUIT;
						
					}				
					else
					{
						_currentShedule = stand;
						_state = STATE_STAND;
					}
					
				break;	
				
			}
			
			_currentShedule.reset();
		}
		
	}

}