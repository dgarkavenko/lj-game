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
	import gameplay.SkillList;

	import gameplay.world.Light;
	import gameplay.world.TimeManager;
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
		
		private var recoil:Number = 0;
		private var gundata:GunData;
		
		private var tracing:Sprite = new Sprite();	
		private var g:Graphics = tracing.graphics;
		
		private var cooldown_timer:Timer = new Timer(100, 1);			
		
		private var rayResultList:RayResultList = new RayResultList();
		
		private var spinner:Spinner = new Spinner();
		
		//Skills
		public var skill_dispersion:Number;
		private var reload_m:Number = 1;
		
		
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
		
		override public function pull():WeaponData {
		
			return gundata;
		}
		
		public function force_reload():void {
			
			gundata.reload_counter = gundata.reload_time;				
			addSpinner();
		}
		
		override public function tick():void {
			
			if (recoil > 0) {
				recoil -= gundata.recoilReduction;				
			}
			
			if (keys.justPressed("R")) {				
				if (gundata.ammo_current < gundata.ammo_max) force_reload();
			}
			
			passive();			
			
			if(gundata.ammo_current == 0 && gundata.reload_counter == 0) {
				
				force_reload();
				
			}			
			
			if (!mouse.pressed()) return;	
			
			if (cooldown_timer.running && !SkillList.isLearned(SkillList.QUICK_FINGERS)) return;
				
				
			if (mouse.justPressed()) {
				if (SkillList.isLearned(SkillList.AMMUNITION_WITHIN) || !cooldown_timer.running) act();
			}else {
				if (cooldown_timer.running) return;
				if (gundata.mode == AUTO) act();			
			
			}
				
			
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
			var y:Number = pivot.y - 10;			
			var a:Number = Math.atan2(mouse.relativeY - y, mouse.relativeX - x);	
			
			
			
			
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
			if (gundata.reload_counter <= 0) gundata.ammo_current--;
			else GameWorld.lumberjack.hp.decrease(gundata.damage_min / 5);
			
			// 8 и 27 — половина ширины и высоты физ тела.
			// 5.5 — половина координаты спрайта, в котором ганпоинт
			var x:Number = pivot.x + carrier.facing *(carrier_view.gunpoint.x - 8 - .5);
			var y:Number = pivot.y + carrier_view.gunpoint.y - 33 + 5.5;
			
			$VFX.dust.shot(x + 5 * carrier.facing, y - 2);
			
			//var x:Number = pivot.x + carrier.facing *(carrier_view.gunpoint.x);
			//var y:Number = pivot.y + carrier_view.gunpoint.y;
			
			ray.origin.setxy(x, y);
			
			
			
			var l:Light = new Light("gun");
			l.x = pivot.x + carrier.facing *(carrier_view.gunpoint.x);
			l.y = y;
			l.bitmap = new L01();			
			TimeManager.addLight(l);
			
			var a:Number = Math.atan2(mouse.relativeY - y, mouse.relativeX - x);
			var da:Number;
						
			carrier_view.shot();
			clear_visual();
			
				
			if (gundata.fragments > 1) {
				
				
				var temp_result:RayResult;
				
				for (var i:int = 0; i < gundata.fragments; i++) 
				{
					
					da = a + (gundata.dispersion + recoil)* (2 * Math.random() - 1)
					ray.direction = Vec2.fromPolar(ray.maxDistance, da);
					
					if (SkillList.isLearned(SkillList.SHORTY)) {
						rayResultList = space.rayMultiCast(ray, false, BULLET_RAY_FILTER);
					}
					else {
						rayResultList.clear();
						rayResult = space.rayCast(ray, false, BULLET_RAY_FILTER);
						if (rayResult != null) rayResultList.add(rayResult);
					}
					
					
					var dist:int = 0;					
					for (var j:int = 0; j < rayResultList.length; j++) 
					{
						temp_result = rayResultList.at(j);						
						if (temp_result) {
							
							var power:Number = gundata.damage_min + (gundata.damage_max - gundata.damage_min) * Math.random();
							power = power / (1 + j / 2);
							
							//1: 1 power
							//2: 0.66 power
							//3: 0.5 power
							//4: 0.4 power
							//5: 0.33 power
							
							power -= temp_result.distance / 75;							
							
							//QUESTION Show every shot?
							if (power > 0) dist = temp_result.distance;
							
							interact(ray.at(temp_result.distance), temp_result.shape.body, power / (1 + j));
						}
					}				
					
					draw_visual(dist);
					
				}
				
			}else {
			
				da = a + (gundata.dispersion + recoil) * (2 * Math.random() - 1);
				ray.direction = Vec2.fromPolar(ray.maxDistance, da);			
				
				rayResult = space.rayCast(ray, false, BULLET_RAY_FILTER);					
				if (rayResult) {
					interact(ray.at(rayResult.distance), rayResult.shape.body, gundata.damage_min + (gundata.damage_max - gundata.damage_min) * Math.random());
				}			
				
				draw_visual(rayResult != null? rayResult.distance : -1);
				
			}
			
			if (!SkillList.isLearned(SkillList.AUTOGUNS)) {
				recoil += gundata.recoilPerShoot;
				if (recoil > 0.08) recoil = 0.08;
			}		
			
			fade_visual();
			
			
		}
		
		private function interact(at:Vec2, subj:Body, power:Number):void 
		{
			_action.params.power = power > 0 ? power : 0;
			_action.params.facing = carrier.facing
			_action.params.x = at.x
			_action.params.y = at.y;
			_action.params.force = gundata.force;
			subj.userData.interact(_action);
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
		
		private function draw_visual(resultDistance:Number = -1):void 
		{
			
			var origin:Vec2 = ray.at(50);
			var hit:Vec2;
			
			if (resultDistance > 0) hit = ray.at(resultDistance + Math.random() * 10);
			else hit = ray.at(ray.maxDistance);
			
			
			g.lineStyle(1, 0xffffff, 1);
			g.moveTo(origin.x, origin.y);
			g.lineTo(hit.x, hit.y);
			
		}		
		
		override protected function gatherAction():void {	
			
			gundata.ammo_current--;
						
		}
		
		override public function init():void {
			ray.maxDistance = Game.SCREEN_WIDTH * 3 / 4;
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
			recoil = 0;
		}
		
		override public function updateParams():void 
		{
			//skill_dispersion = SkillList.dispersion;
			
		}
		
		
		
	}

}