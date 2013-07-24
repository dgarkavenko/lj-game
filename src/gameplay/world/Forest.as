package gameplay.world 
{
	import dynamics.GameCb;
	import dynamics.Tree;
	import flash.display.Sprite;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.space.Space;
	/**
	 * ...
	 * @author DG
	 */
	public class Forest 
	{
		public static var TREEWIDTH_TEMP:Array = [8, 14, 18, 28];		
		
		public static var tree_hit_listener:InteractionListener;
		
		
		public static function grow(space:Space, container:Sprite, x_start:int, x_end:int, amount:int):void {
			
			if (x_end <= x_start) return

			
			var forest_width:int = x_end - x_start;
			
			
			for (var i:int = 0; i < amount; i++) 
			{								
				
				var width:int = TREEWIDTH_TEMP[Math.floor(Math.random() * TREEWIDTH_TEMP.length)];
				var dx:int = (x_start + forest_width / amount * i);		
				var noise:int = Math.random() * 20 - 10;
				
				new Tree(dx + noise, Math.random() * 10 * width + 200, width);				
				
			}
		}
		
	}

}