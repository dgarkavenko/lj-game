package gameplay.contracts.tasks 
{
	import gameplay.contracts.Task;
	import utils.GlobalEvents;
	/**
	 * ...
	 * @author DG
	 */
	public class KillZombies extends Task
	{
		
		public function KillZombies(targets_:uint, typesWeapons:uint, howmuch_:int) 
		{
			targets = targets_;
			killedBy = typesWeapons;
			howMuch = howmuch_;
			event = GlobalEvents.ZOMBIE_KILLED;
		}
		
	}

}