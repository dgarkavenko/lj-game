package gameplay.contracts.bills 
{
	/**
	 * ...
	 * @author DG
	 */
	public class Parking extends Bill
	{
		
		public function Parking() 
		{
			name = "Parking tickets";
			cost = getRandomCost(6, 30);
		}
		
	}

}