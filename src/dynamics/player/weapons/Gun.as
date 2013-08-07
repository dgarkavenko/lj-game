package dynamics.player.weapons 
{
	import com.greensock.TweenLite;
	import dynamics.actions.GunshotAction;
	import dynamics.Collision;
	import dynamics.GameCb;
	import dynamics.player.Hands;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import framework.input.Controls;
	import framework.input.Mouse;
	import framework.PhysDebug;
	import gameplay.player.SkillList;
	import gameplay.world.Light;
	import gameplay.world.WorldTime;
	import hud.Spinner;
	import nape.geom.Ray;
	import nape.geom.RayResult;
	import nape.geom.RayResultIterator;
	import nape.geom.RayResultList;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import utils.BodyCache;
	import visual.L01;
	
	/**
	 * ...
	 * @author DG
	 */
	public class Gun extends Hands
	{
		
		
		public static const SEMI:uint = 0;
		public static const AUTO:uint = 1;	
		
		
		
		
		private var gundata:GunData;
		
		private var tracing:Sprite = new Sprite();	
		private var g:Graphics = tracing.graphics;
		
		private var cooldown_timer:Timer = new Timer(100, 1);			
		
		private var rayResultList:RayResultList = new RayResultList();
		
		private var spinner:Spinner = new Spinner();
		
		//Skills
		private var skill_dispersion:Number;
		private var reload_m:Number;
		
		
		public function Gun() 
		{
			weaponType = WeaponData.TYPE_GUN;
			_action = new GunshotAction();
			GameWorld.container.layer2.addChild(tracing);
			
		}
		
		override public function kill():void {
			
			if (gundata.reload_counter > 0) {				
				gundata.reload_counter = gundata.reload_time;
				hideSpinner();
			}			
			
		}
		
		public function force_reload():void {
			
			gundata.reload_counter = gundata.reload_time * reload_m;				
			addSpinner();
		}
		
		override public function tick():void {
			
			//trace(reload);
			
			if (Controls.keys.justPressed("R")) {				
				if (gundata.ammo_current < gundata.ammo_max) force_reload();
			}
			
			passive();			
			
			if(gundata.ammo_current == 0 && gundata.reload_counter == 0) {
				
				force_reload();
				
			}			
			
			if (!Controls.mouse.pressed() || cooldown_timer.running || gundata.reload_counter > 0) return;
			
			if ((gundata.mode == SEMI && Controls.mouse.justPressed()) || gundata.mode == AUTO) act();			
			
		}	
		
		private function addSpinner():void{			
			if (!carrier_view.sprite.contains(spinner)) carrier_view.sprite.addChild(spinner);
		}
		
		
		private function hideSpinner(e:TimerEvent = null):void {			
			if (carrier_view.sprite.contains(spinner)) carrier_view.sprite.removeChild(spinner);			
		}
		
		private function passive():void 
		{
			
			if (gundata.reload_counter > 0) {
				
				gundata.reload_counter--;
				if (gundata.reload_counter <= 0) {
					hideSpinner();
					gundata.ammo_current = gundata.ammo_max;
				}
			}			
			
			var x:Number = pivot.x;
			var y:Number = pivot.y - 15;			
			var a:Number = Math.atan2(Controls.mouse.relativeY - y, Controls.mouse.relativeX - x);	
			
			
			
			
			//carrier.view.rotation(Math.abs(rad_195(a)));
			
			
			carrier.view.bruteRotation(Math.abs(rad_180(a)));
		
			
		}
		
		private function rad_195(radian:Number):int {
			var r:int = (97.5 + radian * 195 / Math.PI);
			return r > 195? r - 195 : r;
		}
		
		private function rad_180(radian:Number):int {
			var degree:int = (90 + radian * 180 / Math.PI);		
			return degree > 180? degree - 360 :  degree;
		}
		
		private function rad_1(radian:Number):Number {
			var degree:Number = (.5 + radian / Math.PI);	
			return degree > 1? degree - 2 : degree;
		}
		
		private function act():void 
		{
			cooldown_timer.reset();
			cooldown_timer.start();
			
			var subj:Body;
			
			// 8 и 27 — половина ширины и высоты физ тела.
			// 5.5 — половина координаты спрайта, в котором ганпоинт
			var x:Number = pivot.x + carrier.facing *(carrier_view.gunpoint.x - 8 - .5);
			var y:Number = pivot.y + carrier_view.gunpoint.y - 33 + 5.5;
			ray.origin.setxy(x, y);
			
			
			
			var l:Light = new Light("gun");
			l.x = pivot.x + carrier.facing *(carrier_view.gunpoint.x);
			l.y = y;
			l.bitmap = new L01();			
			WorldTime.addLight(l);
			
			var a:Number = Math.atan2(Controls.mouse.relativeY - y, Controls.mouse.relativeX - x);
			var da:Number = a -skill_dispersion + 2 * Math.random() * skill_dispersion;
			ray.direction = Vec2.fromPolar(ray.maxDistance, da);
			
			carrier_view.shot();
			
			rayResult = space.rayCast(ray, false, BULLET_RAY_FILTER);
			rayResultList.clear();
			rayResultList.add(rayResult);
			
			clear_visual();
			draw_visual(rayResult);
			fade_visual();
			
			if (gundata.fragments > 1) {
				
				var additional_result:RayResult;
				
				for (var i:int = 0; i < gundata.fragments - 1; i++) 
				{
					da = a -gundata.dispersion + 2 * Math.random() * (gundata.dispersion);
					ray.direction = Vec2.fromPolar(ray.maxDistance, da);
					additional_result = space.rayCast(ray, false, BULLET_RAY_FILTER);
					
					rayResultList.add(additional_result);
					draw_visual(additional_result);
				}
			}
			
			gatherAction();
			
			
			
			if (rayResultList.length == 0) {			
				return;
			}
			else
			{				
				
				var ite:RayResultIterator = rayResultList.iterator();
				
				while (ite.hasNext()) 
				{
					var result:RayResult = ite.next();
					if (result == null) continue;
					
					subj = result.shape.body;
					if (subj != null && subj.cbTypes.has(GameCb.INTERACTIVE)) subj.userData.interact(_action);
				}	
				
			}
		}
		
		private function fade_visual():void 
		{
			tracing.alpha = .7;
			TweenLite.to(tracing, .25, {alpha:0} );
		}
		
		private function clear_visual():void 
		{
			g.clear();
		}
		
		private function draw_visual(result:RayResult):void 
		{
			
			var origin:Vec2 = ray.at(50);
			var hit:Vec2;
			
			if (result) hit = ray.at(result.distance + Math.random() * 10);
			else hit = ray.at(ray.maxDistance);
			
			
			g.lineStyle(1, 0xffffff, 1);
			g.moveTo(origin.x, origin.y);
			g.lineTo(hit.x, hit.y);
			
		}		
		
		override protected function gatherAction():void {	
			
			gundata.ammo_current--;
			trace(gundata.ammo_current);
			var hit:Vec2;			
			
			if (rayResult) hit = ray.at(rayResult.distance);
			else hit = ray.at(ray.maxDistance);			
			
			_action.params.power = gundata.damage_min + (gundata.damage_max - gundata.damage_min) * Math.random();
			_action.params.facing = carrier.facing
			_action.params.x = hit.x
			_action.params.y = hit.y;				
		}
		
		override public function init():void {
			ray.maxDistance = Game.SCREEN_WIDTH;
			updateParams();
			
		}
		
		override public function select(new_wd:WeaponData):void 
		{			
			if (gundata != null && gundata.reload_counter > 0) {
				gundata.reload_counter = 0;
				hideSpinner();
			}
			
			gundata = new_wd as GunData;
			cooldown_timer.delay = gundata.rate;
		}
		
		override public function updateParams():void 
		{
			skill_dispersion = SkillList.dispersion;
			reload_m = SkillList.reload_m;
		}
		
		
		
	}

}