package dynamics.interactive 
{
	import dynamics.actions.IAction;
	import dynamics.Collision;
	import dynamics.GameCb;
	import dynamics.interactions.IInteractive;
	import dynamics.interactions.IPlayerInteractive;
	import dynamics.interactions.PlayerInteractiveObject;
	import dynamics.WorldObject;
	import flash.display.MovieClip;
	import framework.input.Controls;
	import framework.input.Input;
	import gamedata.achievement.AchievementEngine;
	import gameplay.Goal;
	import gameplay.GoalTracker;
	import gameplay.world.Ground;
	import gui.Bars.SimpleBar;
	import hud.ArrowPointer_mc;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import utils.VisualAlignment;
	import visual.Boat_mc;
	/**
	 * ...
	 * @author DG
	 */
	public class Boat extends PlayerInteractiveObject
	{
		
		private var _body:Body;
		private var _sprite:MovieClip;
		
		private var _repairment:Number = 0;
		private var progress_bar:SimpleBar = new SimpleBar(100, 5, 0xffffff, false);
		
		private var engine:Engine;
		
		private var req:String = "";
		
		
		
		public function Boat() 
		{
			
			type = TYPE_BOAT;
			
			var verts:Array = [Vec2.get(0,0), Vec2.get(200,10), Vec2.get(200,30), Vec2.get(0,30)];
			_body = build(Vec2.get(400, 300), [verts], Material.wood(), Boat_mc);
			_body.userData.graphicOffset = new Vec2( -101.5, -26);
			_sprite = _body.userData.graphic;
			_sprite.stop();			
			
			//_body.type = BodyType.STATIC;
			//VisualAlignment.apply(_body);
			
			Collision.setFilter(_body, Collision.LUMBER_IGNORE, ~Collision.LUMBER_IGNORE);		
			
			applySuperPreferences(_body);
			
			
			GoalTracker.inst.addGoal(new Goal(this, isBuilt, "Build a boat"));
			GoalTracker.inst.addGoal(new Goal(this, hasEngine, "Find an enginge"));
			
		}
		
		override public function onUse(params:Object):void 
		{			
			if (_repairment < 100) {
				
				_repairment += .675;
				_sprite.gotoAndStop(Math.round(_repairment * 0.28));		
				
				if (_repairment >= 100) {
					GoalTracker.inst.updateGoals();
					req = TYPE_ENGINE;
				}				
			}else if ("luggage" in params && params.luggage.type == req) {
				
				_sprite.gotoAndStop(45);	
				engine = params.luggage;
				engine.goal.onComplete = ready2go;
				
				GameWorld.lumberjack.luggage = null;
				
				GoalTracker.inst.updateGoals();
				
				
			}else if (engine != null) {
				
				engine.onUse(params);
				
			}
		}
		
		private function ready2go():void 
		{
			_sprite.gotoAndPlay(50);
			Collision.setFilter(_body, 1);
		}
		
		override public function getPhysics():Body {
			return _body;
		}
		
		override public function requires(type:String):Boolean {
			
			
			if (engine == null) {
				if (type == req) return true;
				else return false;
			}else {
				
				return engine.requires(type);
				
			}
			
			
		}
		
		
		public function isBuilt():Number {
			return _repairment/100
		}
		public function hasEngine():Number {
			return engine == null? 0 : 1;
		}
		
		
		
		
	}

}