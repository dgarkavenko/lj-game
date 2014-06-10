package dynamics.player 
{
	import dynamics.actions.ChopAction;
	import dynamics.actions.IAction;
	import dynamics.Collision;
	import dynamics.player.weapons.GunData;
	import dynamics.player.weapons.WeaponData;
	import flash.display.MovieClip;
	import framework.input.Controls;
	import framework.input.Keyboard;
	import framework.input.Mouse;
	import gui.Bars.SimpleBar;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Ray;
	import nape.geom.RayResult;
	import nape.geom.RayResultList;
	import nape.geom.Vec2;
	import nape.space.Space;

	/**
	 * ...
	 * @author DG
	 */
	public class Hands 
	{
		
		protected var _action:IAction;				
		protected static var ray:Ray = new Ray(Vec2.get(0, 1), Vec2.get(0, 0));
		
		protected static var rayResult:RayResult;
		protected static var rayResultMulti:RayResultList;		
		
		protected var mouse:Mouse = Controls.mouse;
		protected var keys:Keyboard = Controls.keys;
		
		protected static var BULLET_RAY_FILTER:InteractionFilter = new InteractionFilter(Collision.LUMBER_RAY, Collision.DUMMIES);
		protected static var AXE_RAY_FILTER:InteractionFilter = new InteractionFilter(Collision.LUMBER_RAY, Collision.LUMBER_IGNORE | Collision.DUMMIES);
		
		protected static var space:Space = GameWorld.space;
		public static var carrier:Lumberjack;
		public static var carrier_view:Lumberskin;
		public static var pivot:Vec2;
		public var weaponType:int;
		
		public var alias:String = "pistol";
		
		protected var power_bar:SimpleBar = new SimpleBar(30, 5, 0xffffff, false);

		
		public function Hands() 
		{			
			
		}
		
		public function tick():void 
		{
			
		}
		
		//Изменить всю статику в соответствии с выбранным оружием
		public function init():void 
		{
			
		}
		
		public function kill():void 
		{
			
		}
		
		public function setProps(string:String):void {
			
		}
		
		public function select(new_wd:WeaponData):void 
		{
			
		}
		
		public function pull():WeaponData {
		
			return null;
		}
		
		
		public function updateParams():void 
		{
			
		}
		
		public function interrupt():void 
		{
			
		}
		
		
		public function get action():IAction 
		{	
			
			gatherAction();
			return _action;			
			
		}
		
		protected function gatherAction():void 
		{
			
		}
		
	}

}