package dynamics.tree
{
	import dynamics.actions.ActionTypes;
	import dynamics.actions.ChopAction;
	import dynamics.actions.GunshotAction;
	import dynamics.actions.IAction;
	import dynamics.Collision;
	import dynamics.GameCb;
	import dynamics.interactions.IInteractive;
	import dynamics.Tree;
	import dynamics.WorldObject;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	
	/**
	 * ...
	 * @author DG
	 */
	public class TreeBulletCollider extends WorldObject implements IInteractive
	{
		
		private var _body:Body;
		private var _tree:Tree;
		
		public function TreeBulletCollider()
		{
			_body = build(Vec2.get(0, 0), [[10, Vec2.get(0, 0)]]);
			_body.space = null;
			_body.type = BodyType.STATIC;
			_body.shapes.at(0).sensorEnabled = true;
			_body.cbTypes.add(GameCb.INTERACTIVE);
			
			Collision.setFilter(_body, Collision.DUMMIES);
			_body.userData.interact = interact;
		}
		
		public function add(tree:Tree, x:int, y:int):void
		{
			_tree = tree;
			_body.position.setxy(x, y);
			_body.space = space;
			
		
		}
		
		/* INTERFACE dynamics.interactions.IInteractive */
		
		public function interact(action:IAction):void
		{
			if (action.type == ActionTypes.GUNSHOT_ACTION) {
				
				var cutaction:ChopAction = new ChopAction();
				cutaction._params.facing = action.params.facing;
				cutaction._params.tree_dmg = action.params.power;
				cutaction._params.power = 0.25;
				_tree.interact(cutaction);
				/*var shot:GunshotAction = action as GunshotAction;
				$VFX.sawdust.at(action.params.x, action.params.y, -action.params.facing, action.params.power * 4);
				
				trace("hit");*/
				
				
			}else {
				_tree.interact(action);
			}
			
			
			
		}
		
		public function remove():void 
		{
			_body.space = null;
		}
	
	}

}