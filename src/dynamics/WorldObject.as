package dynamics 
{
	import flash.display.Sprite;
	import framework.SpriteContainer;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Interactor;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	/**
	 * Класс для, который должны расширят все объекты в мире. Имеет удобные функции создания простых тел и ссылки на DisplayContainer и Space
	 * @author DG
	 */
	public class WorldObject 
	{
		
		protected var space:Space = GameWorld.space;
		protected var container:SpriteContainer = GameWorld.container;
			
		
		public function WorldObject() 
		{
			
		}
		
		public function build(position:Vec2, shapes:Array, material:Material = null, graphics:Class = null):Body {
			
			var body:Body = new Body(BodyType.DYNAMIC, position);
			for each (var verts:Array in shapes) 
			{
				if (verts.length == 2) body.shapes.add(new Circle(verts[0], verts[1], material));
				else body.shapes.add(new Polygon(verts, material));			
			}
			
			body.space = space;		
			
			if (graphics){
				body.userData.graphic = new graphics();
				container.layer2.addChild(body.userData.graphic);
			}
			
			
			body.align();
			
			return body;
			
		}
		
		/**
		 * For override
		 * @return
		 */
		public function getPhysics():Body 
		{
			return null;
		}
		
	}

}