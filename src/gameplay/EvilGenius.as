package gameplay 
{
	import com.greensock.core.SimpleTimeline;
	import dynamics.enemies.base.Dummy;
	import dynamics.enemies.implement.Crawler;
	import dynamics.enemies.implement.EffectiveManager;
	import dynamics.enemies.implement.Manager;
	import dynamics.enemies.implement.Spitter;
	import dynamics.enemies.implement.Stalker;
	import dynamics.player.Lumberjack;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import framework.SpriteContainer;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.space.Space;
	import utils.SimpleCache;
	/**
	 * ...
	 * @author DG
	 */
	public class EvilGenius 
	{
		
		private var spitters:SimpleCache = new SimpleCache(Spitter, 3);
		private var stalkers:SimpleCache = new SimpleCache(Stalker, 3);
		private var crawlers:SimpleCache = new SimpleCache(Crawler, 3);
		private var managers:SimpleCache = new SimpleCache(Manager, 5);
		
		private var cache:Dictionary = new Dictionary();
		
		private var space:Space;
		private var container:SpriteContainer;		
		private var lumberjack:Lumberjack;
		private var lumberbody:Body;
		public var lumbervec:Vec2;
		
		
		
		private var lj_initial_x_pos:int = -10000;
		private var distance_traveled_treshold:int = Game.SCREEN_WIDTH;
		private const ZOMBIES:Array = ["spitter" ,"stalker", "crawler", "manager"];
		
		public function EvilGenius(space_:Space, container_:SpriteContainer, lumberjack_:Lumberjack) {
			
			//thinkTimer.addEventListener(TimerEvent.TIMER, think);
			
			
			space = space_;
			container = container_;		
			
			lumberjack = lumberjack_;
			lumberbody = lumberjack.getBody();
			lumbervec = lumberbody.position;
			
			lj_initial_x_pos = lumberbody.position.x;
			
			cache["spitter"] = spitters;
			cache["stalker"] = stalkers;
			cache["crawler"] = crawlers;
			cache["manager"] = managers;
			
			
		}
		
		
		
		//private function think(e:TimerEvent):void 
		//{
			//if (lj_initial_x_pos == -10000) {
				//lj_initial_x_pos = lumbervec.x;
				//return;
			//}
			//
			//if (Math.abs(lj_initial_x_pos - lumbervec.x) > distance_traveled_treshold) {				
				//lj_initial_x_pos = -10000;	
				//trace("Prepare to die!");
				//spawnZombies(1 + Math.random() * 4 / (1 + GameWorld.zombies.length));			
			//}
			//
			//TODO Link an array?
			//for each (var z:Dummy in GameWorld.zombies ) 
			//{
				//if (Vec2.distance(z.getBody().position, lumbervec) > Game.SCREEN_WIDTH * 2) {
					//trace("This one gone too far");
					//z.remove();
					//spawnZombies(1);
					//
				//}
			//}
		//}
		
		private function spawnZombies(number:int):void 
		{
			for (var i:int = 0; i < number; i++) 
			{
				
				var z:Dummy = alive(Math.random() > 0.4999? "spitter" : "stalker");	
				var dir:int = Math.random() > 0.4999 ? 1 : -1;
				z.at(lumbervec.x + dir * (Game.SCREEN_HALF_WIDTH + 30 + Math.random() * 100), Game.SCREEN_HEIGHT - 100);	
				//TODO Random direction view and random states (aggresive or chilin)
			}		
		}
		
		public function returnToPool(z:Dummy):void {
			
			(cache[z.alias] as SimpleCache).setInstance(z);			
			
			var ln:int = GameWorld.zombies.length;
			
			for (var i:int = 0; i < ln; i++) 
			{
				if (GameWorld.zombies[i] == z) {
					GameWorld.zombies.splice(i, 1);
					break;
				}
			}
			
		}
		
		public function alive(a:String = "stalker"):Dummy {
			
			var z:Dummy = cache[a].getInstance() as Dummy;
			GameWorld.zombies.push(z);
			z.add();	
			z.daddy = this;
			return z;
			
		}
		
		public function clear():void {
			
			while (GameWorld.zombies.length > 0) {
				var z:Dummy = GameWorld.zombies.pop();
				z.destroy();						
				(cache[z.alias] as SimpleCache).setInstance(z);
			}
		
		}
		
		public function spawnAt(mpX:Number, mpY:Number, i:int):void 
		{
			if (i > ZOMBIES.length - 1) return;
			
			
			var a:String = ZOMBIES[i];			
			var z:Dummy = cache[a].getInstance() as Dummy;
			
			GameWorld.zombies.push(z);
			z.at(mpX, mpY);
			z.add();	
			z.daddy = this;
			
			
		}
		
		
	}

}