package gameplay.contracts.bills 
{
	import gameplay.world.TimeManager;
	/**
	 * ...
	 * @author DG
	 */
	public class Bill 
	{
		public var name:String = "";
		public var startDate:int = 0;
		public var term:int = 0;
		public var cost:int = 1000;
		
		public function Bill() 
		{
			
		}
		
		public function onNotPaid():void {
			trace("Fail, reason: " + name); 
		}
		
		public function getRandomCost(a:int, b:int):int {
			
			var a:int = a * 2 + Math.random() * (b - 1) * 2;
			return a * 50;
		}
		
		public function timeLeft():int {			
			return startDate + term - GameWorld.time.time;
		}	
		
		public function expired():Boolean 
		{
			return GameWorld.time.time > startDate + term;
		}
		
		public function getCostString():String 
		{
			var price:String = cost.toString();
			if (price.length > 3) {
				var index:int = price.length - 3;
				price = price.slice(0, index) + "," + price.slice(index);
			}	
			
			return price;
		}
		
		public function getTimeLeft():String 
		{
			var timestring:String = "Today!";
			
			switch (timeLeft()) 
			{
				case 0:
					timestring = "Today!";
				break;
				case 1:
					timestring = "1 Day Left";
				break;
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:
					timestring = timeLeft() + " Days Left";
				break;
				case 7:
					timestring = "1 Week Left";
				break;
				default:
					timestring = "2 Weeks Left";
			}
			
			return timestring;
		}
		
	
		
	}

}