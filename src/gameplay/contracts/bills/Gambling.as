package gameplay.contracts.bills 
{
	/**
	 * ...
	 * @author DG
	 */
	public class Gambling extends Bill
	{
		
		public function Gambling() 
		{
			name = "The Gambling-debt";
			cost = getRandomCost(10, 100);
		}
		
	}

}