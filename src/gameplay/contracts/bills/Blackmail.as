package gameplay.contracts.bills 
{
	/**
	 * ...
	 * @author DG
	 */
	public class Blackmail extends Bill
	{
		
		public function Blackmail() 
		{
			name = "Blackmailer's demand";
			cost = getRandomCost(30, 90);
		}
		
	}

}