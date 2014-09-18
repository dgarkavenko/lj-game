package gameplay.contracts.imp 
{
	import gameplay.contracts.BaseContract;
	/**
	 * ...
	 * @author DG
	 */
	public class TheDebt extends BaseContract
	{
		
		public function TheDebt() 
		{
			term = 0;
			title = "The Debt.";
			dsc = "Dear mr. Lumberjack";
			isAchievement = true;			
			tasks.push(new Purchase(KilledBy.SHOTGUN, 1));
		}
		
	}

}