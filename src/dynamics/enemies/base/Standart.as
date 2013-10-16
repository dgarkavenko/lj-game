package dynamics.enemies.base 
{
	import dynamics.enemies.ai.Schedule;
	import dynamics.enemies.base.Dummy;
	/**
	 * ...
	 * @author dg
	 */
	public class Standart extends Dummy
	{
		
		protected var meleeAttack:Schedule;
		protected var meleeAttackRange:int;		
		protected var meleeAttackCooldownSize:int;
		protected var meleeAttackDamage:int;
			
		protected var meleeAttackCooldown:int = 0;
		
		
		public function Standart(alias:String) 
		{
			super(alias);
			
			meleeAttack = new Schedule("Melee");
			meleeAttack.addFewTasks([ onInitMeleeAttack, onMeleeAttack, onEndMeleeAttack ]);
		}
		
		override protected function setParameters():void {
			super.setParameters();
			
			
		}
		
		protected function onInitMeleeAttack():Boolean 
		{
			return true;
		}
		
		protected function onEndMeleeAttack():Boolean 
		{
			return true;
		}
		
		protected function onMeleeAttack():Boolean 
		{
			trace("Melee Attack");
			return true;
		}
		
		
		
	}

}