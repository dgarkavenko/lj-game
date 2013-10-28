package dynamics 
{

	import Bmp.Chops;
	import Bmp.tree14;
	import Bmp.tree18;
	import Bmp.tree28;
	import Bmp.tree8;
	import BMP.treetop14;
	import Bmp.treetop18;
	import Bmp.treetop28;
	import Bmp.treetop8;
	import com.greensock.TweenLite;
	import dynamics.actions.ActionTypes;
	import dynamics.actions.IAction;
	import dynamics.actions.TreeHitAction;
	import dynamics.interactions.IInteractive;
	import dynamics.tree.TreeBulletCollider;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import gamedata.DataSources;
	import gamedata.LumberKeeper;
	import gameplay.TreeHandler;
	import gameplay.world.Ground;
	import gui.PopText;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.dynamics.InteractionGroup;
	import nape.geom.GeomPolyList;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import utils.VisualAlignment;

	/**
	 * ...
	 * @author DG
	 */
	public class Tree extends WorldObject implements IInteractive
	{
		
		//private static const TREE_MATERIAL:Material = new Material(.8, .5, .6, 5, .01);
		
		private static const TREE_MATERIAL:Material = new Material(.7, .5, .6, 2, .005);	
		
		//private static const TREE_MATERIAL:Material = { elasticity: 0.4 dynamicFriction: 0.2 staticFriction: 0.38 density: 0.7 rollingFriction: 0.005 }

		private static const CHOPS:BitmapData = new Chops();
		private var sprite:Sprite;
		private var trunk_bmp:Bitmap;
		private var _body:Body;
		
		private var hp_updates:Array = [];
		private var visual_stages:int = 0;
		private var current_visual_step:int = 0;
		
		private var H:int;
		private var W:int;
		protected var MAX_HP:Number = 0;
		protected var HP:Number = 0;
		
		private var L2R:Number = 0;
		private var CUT_A:int = 12 + Math.random() * 9;
		private var CUT_B:int = CUT_A + 4 + Math.random() * 3;
		private var CUT_C:int = CUT_B + 5 + Math.random() * 3;	
		
		private var cvs:Object = { "-1":0, "1":0 };
		
		private var trunk:Body;
		private var stump:Body;
		private var couldBeCutByGun:Boolean = false;
		
		private var bCollider:TreeBulletCollider ;
		private var treetop:BitmapData;
		private var ttop:Bitmap;
		
		
		public function Tree(x:int, h:int, w:int) 
		{	
			
			
			
			W = w;
			
			
			if (W > 14) {
				H = h;
				
			}else if (W == 14) {
				
				H = h > 200 ? 200 + Math.random() * 25 : h;
				
			}else {
				H = h > 125 ? 125 + Math.random() * 15 : h;
			}
			
			_body = build(new Vec2(x, Game.SCREEN_HEIGHT - Ground.HEIGHT + 6 - H), [Polygon.rect(0, 0, W, H)], TREE_MATERIAL);
			_body.type = BodyType.STATIC;			
			_body.cbTypes.add(GameCb.INTERACTIVE);
			_body.cbTypes.add(GameCb.TREE);
			
			
			//Встречается только с лучом
			Collision.setFilter(_body, Collision.LUMBER_IGNORE, Collision.LUMBER_RAY);
			
			_body.userData.interact = interact;
			
			attachBitmap();	
			
			MAX_HP = HP = W * 2;
			
			var multiplier:Number = MAX_HP / visual_stages;
			for (var i:int = 0; i < visual_stages; i++) 
			{
				hp_updates.push(MAX_HP - multiplier * i);
			}
		}

		
		private function attachBitmap():void 
		{
			
			var bdata:BitmapData;
			treetop;
			
			var ttop_x_offset:int = 1;
			
			switch (W) 
			{
				case 28:
					bdata = new tree28();
					treetop = new treetop28();
					visual_stages = 7 + 1;
				break;
				case 18:
					bdata = new tree18();
					treetop = new treetop18();
					visual_stages = 5 + 1;
				break;
				case 14:
					bdata = new tree14();
					visual_stages = 4 + 1;
					treetop = new treetop14();
				break;
				case 8:
					bdata = new tree8();
					visual_stages = 3 + 1;
					treetop = new treetop8();
					
				break;
				
			}
			
			trunk_bmp = new Bitmap(new BitmapData(W, H, true, 0x0));
			
			var ite:int = H / bdata.height;			
			
			for (var i:int = 0; i < ite; i++) 
			{
				var mt:Matrix = new Matrix(1, 0, 0, 1, 0, bdata.height * (ite - i));			
				trunk_bmp.bitmapData.draw(bdata, mt);
			}	
			
			sprite = new Sprite();
			sprite.addChild(trunk_bmp);
			
			ttop = new Bitmap(treetop);
			ttop.x = ttop_x_offset - ttop.width / 2 + W/2;
			sprite.addChild(ttop);
			
			
			
			
			_body.userData.graphic = sprite;
			_body.userData.graphicOffset = new Vec2( -W / 2 + .5,  - H / 2);
			VisualAlignment.apply(_body);
			
			
			
			var index:int = Math.random() > 0.4999 ? -1 : 1;
			
			container.layer3.addChildAt(sprite, 0);	
			
			
			
			
		}
		
		public function interact(action:IAction):void {
			
			
			// УБРАТЬ ЭТУ ПРОВЕРКУ
			if (action == null) return;
			if (HP <= 0) return;
			switch (action.type) 
			{
				case ActionTypes.CHOP_ACTION:
					chopActionHandler(action.params.power * action.params.tree_dmg, action.params.facing);
				break;
				default: return;
			}
		}
				
		private function chopActionHandler(power:Number, facing:int):void 
		{
			
			$VFX.sawdust.at(_body.position.x - W/2 * facing + L2R / MAX_HP * W/2, _body.position.y + H/2 - CUT_B, -facing, power * 2.5);
			
			if (power < 1.5) return;
			HP -= power;		
			L2R += facing * power;
			visualUpdate(facing);			
			
			
			
			if (HP <= 0) {
				
				L2R = L2R < -MAX_HP? -MAX_HP : L2R;
				L2R = L2R > MAX_HP? MAX_HP : L2R;	
				
				
				cut();			
				
				DataSources.lumberkeeper.score++;
				
				//$AE.did(AchievementEngine.TREE_DOWN);				
				//DataSources.lumberkeeper.save();				
			}else if (bCollider == null) {
				bCollider = new TreeBulletCollider();
				bCollider.add(this, _body.position.x, _body.position.y + H / 2 - CUT_B);	
			}
		}
		
	
		
		private function visualUpdate(facing:int):void 
		{
			for (var k:int = 1; k < hp_updates.length; k++) 
			{
				if ( HP < hp_updates[k] ) {					
					current_visual_step = k - 1;					
				}
			}
			
			if (HP < 0) current_visual_step++;
			
			cvs[facing] = current_visual_step - cvs[-facing];
			
			
			
			var w:int = CHOPS.width / 9;
			var h:int = CHOPS.height;
			
			for (var i:int = 0; i < h; i++) 
			{
				
				for (var j:int = cvs[facing] * w; j < cvs[facing] * w + w ; j++) 
				{
					
					var clr:uint = CHOPS.getPixel32(j, i)
					if ( clr == 0xff000000) break; 
					else {
						if (facing == 1) {
							trunk_bmp.bitmapData.setPixel32(j - cvs[facing] * w, H - CUT_B - i + h/2, clr)
						}else {
							trunk_bmp.bitmapData.setPixel32( W - (j - cvs[facing] * w), H - CUT_B - i + h/2, clr)
						}
						
					}
				}
			}
			
			
		}
		
		public function cut():void {
			
			
			
			var CUT_X:Number = L2R / MAX_HP * W / 2;			
			var LX:int = W/2 - CUT_X < 1? 0 : 1;
			var RX:int = W/2 + CUT_X < 1? 0 : 1;			
			
			var gpl:GeomPolyList = new GeomPolyList();			
			var upperVerts:Array = [new Vec2( -W / 2, -H / 2), new Vec2(W / 2, -H / 2), 
									new Vec2(W / 2, H / 2 - CUT_C), new Vec2(CUT_X + LX, H/2 - CUT_B), new Vec2(CUT_X - RX, H/2 - CUT_B), new Vec2( -W / 2, H / 2 - CUT_C)];
			
			var lowerVerts:Array = [new Vec2( -W / 2, H / 2 - CUT_A), new Vec2(CUT_X - RX, H/2 - CUT_B), new Vec2(CUT_X + LX, H/2 - CUT_B), new Vec2(W / 2, H / 2 - CUT_A), 
									new Vec2(W / 2, H / 2), new Vec2( -W / 2, H / 2)];			
			
			trunk = build(_body.position, [upperVerts], TREE_MATERIAL);	
			stump = build(_body.position, [lowerVerts], TREE_MATERIAL);	
			stump.type = BodyType.STATIC;			
			
			//Не пользоваться кэшем, если будут хуевые коллизии
			stump.group = trunk.group = Collision.groups.getInstance() as InteractionGroup;				
			trunk.group.group = stump.group.group = Collision.rootgroup;			
			Collision.setFilter(stump, Collision.LUMBER_IGNORE);
			
			//Графика для ствола
			
			var trunksprite:Sprite = new Sprite();
			
			var bdata:BitmapData = new BitmapData(W, H - CUT_B, true, 0x0);
			bdata.draw(trunk_bmp.bitmapData);			
			
			trunksprite.addChild(new Bitmap(bdata));
			trunksprite.addChild(ttop);
			
			trunk.userData.graphic = trunksprite;
			trunk.userData.graphicOffset = new Vec2( -W / 2, -(H - CUT_B) / 2);	
			trunk.cbTypes.add(GameCb.TRUNK);				
			
			container.layer2.addChild(trunk.userData.graphic);	
						

			
			//Графика для пня
			bdata = new BitmapData(W, CUT_B, true, 0x0);
			bdata.copyPixels(trunk_bmp.bitmapData, new Rectangle(0, H - CUT_B, W, CUT_B), new Point(0, 0));			
			stump.userData.graphicOffset = new Vec2(-W / 2, -CUT_B / 2 - 1);
			stump.userData.graphic = new Bitmap(bdata);			
			container.layer3.addChildAt(stump.userData.graphic, container.layer3.getChildIndex(sprite));
			VisualAlignment.apply(stump);
			
			trunk.userData.stump = stump;
			TreeHandler.inst.addTrunk(trunk);
			
			parentalDestruction();	
		}
		
		
		
		private function parentalDestruction():void 
		{			
			
			
			//GRAPHICS
			while (sprite.numChildren > 0) {
				sprite.removeChildAt(0);
			}
			container.layer3.removeChild(sprite);			
			sprite = null;
			trunk_bmp = null;
			
			
			//PHYS
			_body.space = null;			
			_body = null;			
			
			hp_updates.length = 0;
			cvs = null;
			if (bCollider != null) {
				bCollider.remove();
				bCollider = null;
			}
			
		}
		
		
		/*private function onTreeFall_old(cb:InteractionCallback):void {
			
			var trunk:Body = cb.int1.castBody;
			var hit_object:Body = cb.int2.castBody;
			
			var hide:Function = function():void {					
				if (trunk.cbTypes.has(GameCb.TRUNK)) trunk.cbTypes.remove(GameCb.TRUNK);								
				Collision.setFilter(trunk, Collision.LUMBER_IGNORE);
				//container.setChildIndex(trunk.graphic, 30);
			}
			
			var impulse:int = trunk.totalImpulse(hit_object).xy().length
			
			if (hit_object.cbTypes.has(GameCb.GROUND)) {
				camera.wiggle(trunk.mass / 20, trunk.mass / 10, trunk.mass / 2, .5);
				setTimeout(hide, 1000);
			}else if (impulse > 300) {
				
				var tree_hit:TreeHitAction = new TreeHitAction();
				tree_hit.params.power = impulse;
				tree_hit.params.x = cb.arbiters.at(0).collisionArbiter.contacts.at(0).position.x;
				tree_hit.params.y = cb.arbiters.at(0).collisionArbiter.contacts.at(0).position.y;
				
				container.setChildIndex(trunk.userData.graphic, container.numChildren - 1);				
				hit_object.userData.interact(tree_hit);	
				setTimeout(hide, 1400);
				
			}else {
				//hide();
			}			
		}*/
		
		
		/*private function graphicUpdate(body:Body = null):void {
			
			var graphic:Bitmap;
			graphic = body.userData.graphic;
			
			graphic.x = body.worldCOM.x; 
			graphic.y = body.worldCOM.y;
			if ("offset_x" in body.userData) graphic.x += body.userData.offset_x * Math.cos(body.rotation) - body.userData.offset_y * Math.sin(body.rotation);
			if ("offset_y" in body.userData) graphic.y += body.userData.offset_x * Math.sin(body.rotation) + body.userData.offset_y * Math.cos(body.rotation);
			
			body.userData.graphic.rotation = body.rotation * 180 / Math.PI;
			
			
		}*/
		
		
	}

}