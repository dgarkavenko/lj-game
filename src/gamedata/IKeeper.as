package gamedata 
{
	
	/**
	 * ...
	 * @author DG
	 */
	public interface IKeeper
	{
		
		/**
		 * Собирает объект для локально хранения
		 * 
		 */
		function pack():Object;
		
		/**
		 * Занимается разбором данных из локального сохранения
		 * 
		 */
		function extract(load_data:Object):void
		
		/**
		 * 
		 */
		function get name():String
				
	}
	
}