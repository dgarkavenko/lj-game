package gui.popups 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.setTimeout;
	import framework.FormatedTextField;
	import framework.screens.GameScreen;
	import gameplay.SkillList;
	/**
	 * ...
	 * @author DG
	 */
	public class PerkPopup extends Popup
	{
		private var tf:FormatedTextField;
		private var temp_ico:MovieClip;
		
		private var perks_to_show:Array = [];
		
		
		public function PerkPopup(alias:String = "") 		
		{
			var temp_mc:MovieClip = new MovieClip();
			temp_mc.graphics.beginFill(0x333333, 1);
			temp_mc.graphics.drawRoundRect(0, 20, Game.SCREEN_WIDTH - 40, Game.SCREEN_HEIGHT - 80, 30, 30);
			temp_mc.graphics.endFill();			
			addChild(temp_mc);
			
			
			
			AddTitle(temp_mc, "Perks");
			AddCloseButton(temp_mc);
			
			var i:int = 0;			
			var item:String		
			
			
		}
		
		
		
		override protected function animation_IN():void 
		{
			x = (Game.SCREEN_WIDTH - width) / 2;
			y = -height;
			TweenLite.to(this, 0.4, {y:10, ease:Cubic.easeOut} );
		}
		
		override protected function animation_OUT():void 
		{
			//Начинаем удалять сверху			
			TweenLite.to(this, 0.4, {y: -height, onComplete:GameScreen.POP.hide, onCompleteParams:[this], ease:Cubic.easeIn} );
		}
		
		override public function hide(e:* = null):void {
				
			super.hide();				
		}
		
		override public function destory(container:MovieClip):void 
		{
			for each (var pb:PerkButton in perks_to_show) 
			{
				removeChild(pb);
			}
			
			perks_to_show.length = 0;
			super.destory(container);
		}
		
		override public function build(container:MovieClip, params:Object = null):void 
		{
			super.build(container, params);
			
			var display:Array = [];
			
			for each (var skill:uint in SkillList.skills) 
			{
				if (SkillList.isLearned(skill)) continue;
				display.push(skill);
			}
			
			var i:int = SkillList.isLearned(SkillList.MORE_PERKS) ? 4 : 3;
			if (i > display.length) i = display.length;
						
			for (var j:int = 0; j < i; j++) 
			{
				var skill_index:uint = display.splice(Math.random() * display.length, 1);
				var pb:PerkButton = new PerkButton(SkillList.strings[skill_index], skill_index);
				pb.addEventListener(MouseEvent.CLICK, onPerkClick);				
				perks_to_show.push(pb);
				
				addChild(pb);
				pb.x = 100;
				pb.y = 100 + j * 30;
			}
			
		}
		
		private function onPerkClick(e:MouseEvent):void 
		{
			var p:PerkButton = e.currentTarget as PerkButton
			SkillList.learn((p).skill);
			p.text += " - learned";
			hide();
		}
		
	}
	

}