package dynamics.enemies.base 
{
	import dynamics.enemies.ai.Schedule;
	import dynamics.enemies.base.Dummy;

	
	/**
	 * ...
	 * @author dg
	 */
	public class Ranged extends Standart
	{
		protected var rangedAttackCooldown:int = 0;
		protected var rangedAttackCooldownSize:int;
		protected var rangedAttack:Schedule;
		protected var rangedAttackRange:int;
		
		
		public function Ranged(alias:String) 
		{
			super(alias);
			
			rangedAttack = new Schedule("RangeAttack");
			rangedAttack.addFewTasks([ onInitRangedAttack, onRangedAttack, onEndRangedAttack ]);
			rangedAttack.addFewInterrupts([CONDITION_CAN_MELEE_ATTACK]);
		}
		
		override protected function setParameters():void {
			super.setParameters();
			rangedAttackCooldownSize = 75;
		}
		
		
		protected function onInitRangedAttack():Boolean 
		{
			return true;
		}
		
		protected function onRangedAttack():Boolean 
		{
			return true;
		}
		
		protected function onEndRangedAttack():Boolean 
		{
			return true;
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