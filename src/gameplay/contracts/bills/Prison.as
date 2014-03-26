package gameplay.contracts.bills 
{
	/**
	 * ...
	 * @author DG
	 */
	public class Prison extends Bill
	{
		
		public function Prison() 
		{
			name = "Ransom out of Prison";
			cost = getRandomCost(30, 70);
		}
		
	}

}