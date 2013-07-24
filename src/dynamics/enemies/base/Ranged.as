package dynamics.enemies.base 
{
	import dynamics.enemies.ai.Schedule;
	import dynamics.enemies.Dummy;
	import dynamics.enemies.Projectile;
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
		
		protected var projetile:Projectile;
		
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
		
	}

}