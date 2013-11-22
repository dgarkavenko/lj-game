package dynamics.interactive 
{
	import dynamics.Collision;
	import dynamics.interactions.PlayerInteractiveObject;
	import dynamics.player.Lumberjack;
	import flash.display.MovieClip;
	import framework.input.Controls;
	import gameplay.Goal;
	import gameplay.GoalTracker;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import visual.Engine_mc;
	/**
	 * ...
	 * @author DG
	 */
	public class Engine extends PlayerInteractiveObject
	{
		
		private var tank:Number = 0;
		private var _body:Body;
		private var _sprite:MovieClip;
		
		public var goal:Goal;
		
		public function Engine() 
		{
			
			type = TYPE_ENGINE;
			
			var verts:Array = [Vec2.get(-19,-10), Vec2.get(6,-20), Vec2.get(21.5,-7), Vec2.get(7,15)];
			_body = build(Vec2.get(900, 300), [verts], Material.wood(), Engine_mc);			
			_sprite = _body.userData.graphic;
			
			_body.userData.graphicOffset = new Vec2(-2, 5);
			
			//_body.type = BodyType.STATIC;
			//VisualAlignment.apply(_body);
			
			
			applySuperPreferences(_body);			
			Collision.setFilter(_body, Collision.LUMBER_IGNORE);	
			
			goal = new Goal(this, isFull, "Find a gas");
			GoalTracker.inst.addGoal(goal);
			
			
		}
		
		override public function onUse(params:Object):void 
		{		
			if (Controls.keys.justPressed("E")) {
			if (GoalTracker.inst.currentGoalIndex < 2)
			{
				var lj:Lumberjack = params.parent;			
						
					
					if (lj.luggage == this) {
						
						_body.space = space;
						container.layer2.addChild(_body.userData.graphic);
						_body.position = lj.getBody().position;
						
						_body.velocity = lj.getBody().velocity;
						_body.applyImpulse(Vec2.get(lj.facing * 10, -10));
						
						lj.luggage = null;
						
					}else if(lj.luggage == null) {
						lj.luggage = this;
						
						container.layer2.removeChild(_body.userData.graphic);
						_body.space = null;
						
					}
					
				
			}else if ("luggage" in params && params.luggage.type == TYPE_GAS_CAN){
				
				tank += 0.34;
				if (tank >= 1) {
					tank = 1;
					GoalTracker.inst.updateGoals();
				}
			}
			}
			
			
		}
		
		override public function getPhysics():Body {
			return _body;
		}
		
		override public function requires(type:String):Boolean {
			
			if (type == TYPE_GAS_CAN && GoalTracker.inst.currentGoalIndex > 1) return true;
			else return false;
		}
		
		
		public function isFull():Number {			
			
			return tank;			
		}
		
		
		
	}

}