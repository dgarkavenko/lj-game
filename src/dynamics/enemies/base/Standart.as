package dynamics.enemies.base 
{
	import dynamics.enemies.ai.Schedule;
	import dynamics.enemies.base.Dummy;
	import flash.events.Event;
	import gameplay.DeathReason;
	import gui.PopText;
	import nape.geom.Vec2;
	/**
	 * ...
	 * @author dg
	 */
	public class Standart extends Dummy
	{
		
		protected var meleeAttack:Schedule;
		protected var pursuit:Schedule;	
		
		protected var meleeAttackRange:int = 35;		
		protected var meleeAttackCooldownSize:int = 10;
		protected var meleeAttackDamage:int;
			
		protected var meleeAttackCooldown:int = 0;
		
		
		public function Standart(alias:String) 
		{
			super(alias);
			
			meleeAttack = new Schedule("Melee");
			meleeAttack.addFewTasks([ onInitMeleeAttack, onMeleeAttack, onEndMeleeAttack ]);
			
			pursuit = new Schedule("Pursuit");
			pursuit.addFewTasks([ onInitPursuit, onPursuit ]);
			pursuit.addFewInterrupts([CONDITION_CAN_RANGED_ATTACK, CONDITION_CAN_MELEE_ATTACK]);
		}
		
		override protected function setParameters(ref:Object):void {
			super.setParameters(ref);		
			meleeAttackRange = ref.meleeAttackRange;
			meleeAttackCooldownSize = ref.meleeAttackCooldown * 30;
			meleeAttackDamage = ref.meleeAttackDamage;
		}
		
		override public function tick():void
		{
			super.tick();
		}
		
		protected function onInitMeleeAttack():Boolean
		{
			worried = true;
			_view.melee();	
			_view.sprite.mc.addEventListener("onAttack", onAttackAnimation);					
			return true;
		}
		
		private function onAttackAnimation(e:Event):void 
		{
			
			var viewDirTowardsLj:Boolean = (_facing == 1 && _body.position.x < daddy.lumbervec.x) || (_facing == -1 && _body.position.x > daddy.lumbervec.x);
			if (Vec2.distance(daddy.lumbervec, _body.position) <= meleeAttackRange && viewDirTowardsLj) {
				GameWorld.lumberjack.bite(facing);
				switch(alias) {
					case "spitter":
						GameWorld.lumberjack.lastDamage = DeathReason.ZOMBIE_SPITTER;
					break;
					
					case "stalker":
					GameWorld.lumberjack.lastDamage = DeathReason.ZOMBIE_STALKER;
					break;
				default:
					GameWorld.lumberjack.lastDamage = DeathReason.ZOMBIE;
				}
			}
			
			_view.sprite.mc.removeEventListener("onAttack", onAttackAnimation);		
		}
		
		protected function onMeleeAttack():Boolean 
		{
			return (_view.sprite.mc.currentFrame == _view.sprite.mc.totalFrames) ? true : false;
		}
		
		protected function onEndMeleeAttack():Boolean 
		{
			meleeAttackCooldown = meleeAttackCooldownSize;			
			_view.idle();
			return true;
		}		
		
		/**
		 * Инициализация действия преследования.
		 */
		protected function onInitPursuit():Boolean
		{				
			if(!worried) worried = true;				
			return true;
		}
		
		
		
		/**
		 * Процесс действия преследования.
		 */
		protected function onPursuit():Boolean
		{
			
			var d:int = 1;
			
			if (daddy.lumbervec.x < _body.position.x) d = -1;			
			facing = d;			
			_body.velocity.x = 0;
			
			if (Vec2.distance(_body.position, daddy.lumbervec) > meleeAttackRange) {				
				_body.applyImpulse(Vec2.get(d * movementSpeed, 0));
				_view.walk();
			}					
			
			return false;
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
						
						/*if ( rangedAttackCooldown > 0) {
							_state = STATE_STAND;
							_currentShedule = stand;
							
						}else {							
							_state = STATE_RANGED;
							_currentShedule = rangedAttack;
						}*/
						
						
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
					else if (_conditions.contains(CONDITION_SEE_ENEMY)) {
						
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