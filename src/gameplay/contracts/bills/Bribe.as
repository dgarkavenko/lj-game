package gameplay.contracts.bills 
{
	/**
	 * ...
	 * @author DG
	 */
	public class Bribe extends Bill
	{
		
		public function Bribe() 
		{
			name = "Bribe To a Judge";
			cost = getRandomCost(20, 50);			
		}
		
		
		
	}

}