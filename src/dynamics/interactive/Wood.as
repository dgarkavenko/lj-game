package dynamics.interactive 
{
	import dynamics.Collision;
	import dynamics.interactions.PlayerInteractiveObject;
	import dynamics.player.Lumberjack;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import framework.input.Controls;
	import gameplay.TreeHandler;
	import gui.PopText;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import visual.Wood_bitmap;
	/**
	 * ...
	 * @author DG
	 */
	public class Wood extends PlayerInteractiveObject
	{
		
		private var _body:Body;
		private var _sprite:Bitmap;
		public var value:int;
		
		public function Wood() 
		{
			type = TYPE_WOOD;
			
			_body = build(Vec2.get(750, 150), [Polygon.rect(0, 0, 28, 10)], Material.wood());
			_body.space = null;
			
			applySuperPreferences(_body);
			
			_sprite = new Bitmap(new Wood_bitmap());
			_body.userData.graphic = _sprite;
			_body.userData.graphicOffset = new Vec2( -14, -10);	
			
			Collision.setFilter(_body, Collision.LUMBER_IGNORE, Collision.NULL_OBJECT);	
			
			
		}	
		
		public override function add(position:Vec2):void {
			_body.space = space;
			_body.position = position;
			container.layer2.addChild(_sprite);
		}
		
		public override function remove():void {
			_body.space = null;
			container.layer2.removeChild(_sprite);
		}
		
		override public function destroy():void {
			remove();
			TreeHandler.inst.woodCache.setInstance(this);
		}
		
		override public function getBody():Body {
			return _body;
		}	
		
		public function spawnImpulse():void {
			_body.applyImpulse(Vec2.get( -25 + Math.random() * 50, -60));
		}
		
		override public function drop(carry:Body, dir:int):void {
			
			add(carry.position);			
			_body.velocity = carry.velocity.mul(.5);
			_body.applyImpulse(Vec2.get(dir * 10, -10));					
			
		}
		
		public function pick():void {			
			remove();
		}
		
		override public function onFocus():void 
		{
			super.onFocus();
			label.x = _body.position.x;
			label.y = _body.position.y - 15;
			
		}
		
		override public function onUse(params:Object):void 
		{		
			if (Controls.keys.justPressed("E")) {	
			
				var lj:Lumberjack = params.parent;	
				
				if (lj.luggage == null) {
					
					lj.pick(this);
					remove();
					
				}else if (lj.luggage.type == TYPE_WOOD) {
					
					var w:Wood = lj.luggage as Wood;
					
					//TODO CARRY SKILL?
					if (w.value + value < 12) {
						w.value += value;			
						remove();
					}else {
						PopText.at("Can't carry anymore", _body.position.x, _body.position.y, 0xfef0d3);
					}
				
				}
			}
		}
		
		override public function requires(type:uint):Boolean {
			return true;
		}
		
	}

}