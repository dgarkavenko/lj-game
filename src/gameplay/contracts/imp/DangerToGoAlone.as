package gameplay.contracts.imp 
{
	import gameplay.contracts.BaseContract;
	import gameplay.contracts.tasks.Purchase;
	import gameplay.KilledBy;
	/**
	 * ...
	 * @author DG
	 */
	public class DangerToGoAlone extends BaseContract
	{
		
		public function DangerToGoAlone()  
		{
			term = 0;
			title = "It's danger to go alone";
			dsc = "Take that discount coupon and purchase a shotgun";
			isAchievement = true;			
			tasks.push(new Purchase(KilledBy.SHOTGUN, 1));
		}
		
	}

}