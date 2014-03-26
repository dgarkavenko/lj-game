package gameplay.contracts.bills 
{
	/**
	 * ...
	 * @author DG
	 */
	public class Ransom extends Bill
	{
		
		public function Ransom() 
		{
			name = "Ransom";
			cost = getRandomCost(70, 400);
		}
		
	}

}