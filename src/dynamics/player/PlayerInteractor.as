package dynamics.player 
{
	import adobe.utils.CustomActions;
	import dynamics.actions.ActionTypes;
	import dynamics.Collision;
	import dynamics.GameCb;
	import dynamics.Walker;
	import flash.utils.Dictionary;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Interactor;
	/**
	 * ...
	 * @author DG
	 */
	public class PlayerInteractor 
	{
		
		protected var _area:Body;
		private var _subject:*;
		private var _subject_position:Vec2;
		private var _subject_int:Interactor;
		
		private var _offset:Vec2 = new Vec2(0, 0);
		protected var INTERACTIVEAREA:CbType = new CbType();				
		
		//private static var areas_n_reach:Dictionary = new Dictionary();
		private static var interactors:Vector.<Interactor>	
		private var id:String = "";
		
		private var enter:InteractionListener;
		private var leave:InteractionListener;
		
		private var int_in_focus:Interactor;
		
		
		protected var actual:Boolean = false;
		
		public function PlayerInteractor() 
		{			
			if (!enter || !leave) {
				enter =  new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, INTERACTIVEAREA, GameCb.PLAYER_INTERACTIVE, onEnter);
				leave = new InteractionListener(CbEvent.END, InteractionType.SENSOR, INTERACTIVEAREA, GameCb.PLAYER_INTERACTIVE, onLeave);
				enter.space = leave.space = GameWorld.space;
			}
			
		}	
		
		public function setup(subj:*, area:Body, offset:Vec2):void 
		{
			
			if (_area) _area.space = null;
			
			_area = area;
			_area.shapes.at(0).sensorEnabled = true;			
			_area.cbTypes.add(INTERACTIVEAREA);		
			_area.type = BodyType.DYNAMIC
			_area.allowMovement = false;
			
			_subject = subj;
			_subject_int = _subject.getPhysics();
			_subject_position = _subject_int.castBody.position;
			
			_offset = offset;			
			interactors = new Vector.<Interactor>();			
			
		}
		
		protected function onEnter(cb:InteractionCallback):void 
		{			
			//if (cb.int2 == _subject_int) return;				
			interactors.push(cb.int2);
			updateFocus();			
			actual = false;
			trace("+");				
		}	
		
		protected function onLeave(cb:InteractionCallback):void 
		{			
			var index:int = interactors.indexOf(cb.int2);		
			interactors.splice(index, 1);
			
			updateFocus();
			
			actual = false;			
			trace("-");
		}
		
		private function updateFocus():void 
		{
			if (interactors.length == 0 && int_in_focus != null) {
				int_in_focus.userData.onLeaveFocus();
				int_in_focus = null;
				return;
			}
			
			var probable_focuse:Interactor;
			var min_distance:Number = 999999999;
			
			for each (var cbint:Interactor in interactors) 
			{
				var pos:Vec2 = cbint.castBody.position;
				var distance:Number = Vec2.distance(pos, _subject_position);
				
				if (distance < min_distance) {
					min_distance = distance;
					probable_focuse = cbint; 
				}
			}
			
			if (probable_focuse != null) {
				
				if (int_in_focus != null) int_in_focus.userData.onLeaveFocus();
				
				int_in_focus = probable_focuse;
				int_in_focus.userData.onFocus();
			}
		}
		
		public function getFocus():Interactor {
			return int_in_focus;
		}
		
		
		public function hasInteractiveObjects():Boolean {
			return interactors.length > 0;
		}		
		
		/**
		 * Пока работает некорректно
		 */
		public function get is_actual():Boolean {
			return actual;
		}		
		
		public function update():void {			
			_area.position = _subject_position.add(_offset.mul(_subject.facing));
		}		
		
		static public function remove(interactor:Interactor):void 
		{
			for each (var vec:Vector.<Interactor> in interactors) 
			{
				var index:int = vec.indexOf(interactor);
				if (index != -1) {
					vec.splice(index, 1);						
				}
			}
		}		
		
		
		
		
		
	}

}