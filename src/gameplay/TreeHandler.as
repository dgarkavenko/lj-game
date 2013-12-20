package gameplay 
{
	import com.greensock.TweenLite;
	import dynamics.actions.TreeHitAction;
	import dynamics.Collision;
	import dynamics.GameCb;
	import dynamics.interactive.Wood;
	import dynamics.Tree;
	import flash.display.Sprite;
	import gameplay.world.Forest;
	import nape.geom.Vec2;
	import nape.phys.Interactor;
	import nape.shape.Shape;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.phys.Body;
	import nape.space.Space;
	import utils.SimpleCache;
	/**
	 * ...
	 * @author DG
	 */
	public class TreeHandler 
	{
		
		private var trunks:Vector.<Body>;
		private var tree_hit_listener:InteractionListener;
		private var trees:Vector.<Tree> = new Vector.<Tree>();
		private var ln:int = 0;
		private var stumps:Vector.<Body>;
		
		static private var _inst:TreeHandler;
		
		
		//public var woodCache:SimpleCache = new SimpleCache(Wood, 5);
		
		public function grow(space:Space, container:Sprite, x_start:int, x_end:int, amount:int):void {			
			trees = Forest.grow(space, container, x_start, x_end, amount);
		}
		
		public function TreeHandler() 
		{
			trunks = new Vector.<Body>();
			stumps = new Vector.<Body>();
			tree_hit_listener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, GameCb.TRUNK, GameCb.GROUND.including(GameCb.INTERACTIVE), onTreeFall);
			tree_hit_listener.space = GameWorld.space;
			
		}
		
		static public function get inst():TreeHandler 
		{
			if (_inst == null) {
				_inst = new TreeHandler();
			}			
			return _inst;
		}
		
		public function addTrunk(b:Body):void {		
			
			b.userData.lifetime = 30 * 10;
			trunks.push(b);
			ln++;
			
		}
		
		
		public function tick():void {
			
			
			for (var i:int = 0; i < ln; i++) 
			{
				trunks[i].userData.lifetime--;
				
				if (trunks[i].userData.lifetime <= 0) {			
					
					onTrunkLifetimeExpired(trunks[i]);
					trunks.splice(i, 1);
					ln--;
					break;
				}
				
			}			
		}
		
		public function getNearestForegroundTreeX(x:int):int {
			
			var dx:int = 9999999;
			var probableX:int = x;
			
			
			for each (var tree:Tree in trees ) 
			{
				if (tree.isForeground != true) continue;
				
				var diff:int = Math.abs(tree.getBody().position.x - x);
				
				if (diff < dx) {
					probableX = tree.getBody().position.x;
					dx = diff;
				}
			}
			
			trace("GOING TO " + probableX);
			return probableX;
		}
		
		public function clear():void {
		
			for (var i:int = 0; i < ln; i++) 
			{
				var tr:Body = trunks[i];
				var st:Body = tr.userData.stump;
				
				
				Collision.groups.setInstance(tr.group);
				Collision.groups.setInstance(st.group);	
				
				TweenLite.killTweensOf(tr.userData.graphic);
				GameWorld.container.layer2.removeChild(tr.userData.graphic);
				GameWorld.container.layer3.removeChild(st.userData.graphic);
				tr.userData.graphic = st.userData.graphic = null;
				tr.space = st.space = null;
				tr = null;
				st = null;
			}
			
			for each (var stump:Body in stumps) 
			{
				GameWorld.container.layer3.removeChild(stump.userData.graphic);
				stump.userData.graphic = null;
				stump.space = null;
				stump = null;
			}
			
			stumps.length = trunks.length = 0;
			ln = 0;
			
			while (trees.length > 0) {
				trees[0].destroy();
			}
			
			
		}
		
		public function destroyTree(t:Tree):void {
			for (var i:int = 0; i < trees.length; i++) 
			{
				if (t == trees[i]) {
					trees.splice(i, 1);
					break;
				}
			}
		}
		
		private function onTrunkLifetimeExpired(trunk:Body):void 
		{				
			trace("TREE TRUNK LIFETIME EXPIRED"); 
			stumps.push(trunk.userData.stump);
			
			Collision.setFilter(trunk.userData.stump, Collision.LUMBER_IGNORE, ~Collision.TRUNK);
			
			
			
			if (trunk.cbTypes.has(GameCb.TRUNK)) trunk.cbTypes.remove(GameCb.TRUNK);								
			Collision.setFilter(trunk, Collision.LUMBER_IGNORE, ~Collision.LUMBER_IGNORE);
			TweenLite.to(trunk.userData.graphic, 6, { alpha:0, onComplete:fade, onCompleteParams:[trunk, trunk.userData.stump] } );		
			
		}			
		
		private function fade(trunk:Body, stump:Body):void {
			
			Collision.groups.setInstance(trunk.group);
			Collision.groups.setInstance(stump.group);				
			Collision.setFilter(stump, Collision.LUMBER_IGNORE, ~Collision.NULL_OBJECT);				
			GameWorld.container.layer2.removeChild(trunk.userData.graphic);
			trunk.space = null;
			
		}
		
		
		// TREE INTERACTION		
		private function onTreeFall(cb:InteractionCallback):void {
			
			var trunk:Body = cb.int1.castBody;			
			var hit_object:Interactor = cb.int2;				
		
			
			if (hit_object.cbTypes.has(GameCb.GROUND)) {
				
				GameWorld.camera.wiggle(trunk.mass / 10, trunk.mass / 5, trunk.mass / 1, .5);
				if (trunk.userData.lifetime > 60) trunk.userData.lifetime = 45;
				
				
				
			}else if (hit_object.cbTypes.has(GameCb.INTERACTIVE)) {
				
				var hit_body:Body = hit_object.castBody;				
				if (hit_body == null) hit_body = hit_object.castShape.body;			
				var impulse:int = trunk.totalImpulse(hit_body).xy().length
				
				var tree_hit:TreeHitAction = new TreeHitAction();
				tree_hit.params.power = impulse;
				tree_hit.params.x = cb.arbiters.at(0).collisionArbiter.contacts.at(0).position.x;
				tree_hit.params.y = cb.arbiters.at(0).collisionArbiter.contacts.at(0).position.y;				
				
				hit_body.userData.interact(tree_hit);
				
				if (trunk.userData.lifetime > 60 && impulse > 150) trunk.userData.lifetime = 60;
			}		
			
		}
		
		/*public function spawnWood(mass:int, at:Vec2):void {			
		
			var a:int = 1 + Math.sqrt(mass);
			var v:int = mass / a;
			
			var o:int = mass - v * a;
			
			for (var i:int = 0; i < a; i++) 
			{			
				var w:Wood = woodCache.getInstance() as Wood;
				w.add(at);
				w.value = v;
				
				if (o > 0) {
					w.value++;
					o--;
				}
				
				w.spawnImpulse();
				GameWorld.playerInteractors.push(w);				
				trace("WOOD WITH VALUE OF:" + w.value);				
			}			
		}*/
		
	}

}