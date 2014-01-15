package gameplay.contracts.imp 
{
	import gameplay.contracts.BaseContract;
	import gameplay.contracts.tasks.KillZombies;
	import gameplay.KilledBy;
	import gameplay.ZombieTypes;
	/**
	 * ...
	 * @author DG
	 */
	public class WeCanKillEm extends BaseContract
	{
		
		public function WeCanKillEm() 
		{
			term = 0;
			title = "If they bleed, we can kill em";
			isAchievement = true;			
			tasks.push(new KillZombies(ZombieTypes.SPITTER|ZombieTypes.STALKER, KilledBy.ANY, 100));
			
		}
		
	}

}