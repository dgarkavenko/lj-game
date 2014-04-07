package gameplay.contracts.bills 
{
	/**
	 * ...
	 * @author DG
	 */
	public class Housemaid extends Bill
	{
		
		public function Housemaid() 
		{
			name = "Housemaid services";
			cost = getRandomCost(5, 15);
		}
		
	}

}