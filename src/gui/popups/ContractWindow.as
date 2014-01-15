package gui.popups 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import framework.FormatedTextField;
	import gameplay.contracts.BaseContract;
	import gameplay.contracts.Task;
	import gameplay.contracts.TaskType;
	/**
	 * ...
	 * @author DG
	 */
	public class ContractWindow extends Popup
	{
		
		
		private var cntr:BaseContract;
		
		private var contracts:Vector.<BaseContract>;
		
		private var info:Array = [];
		private var temp_mc:MovieClip;
		
		public function ContractWindow() 
		{
			temp_mc = new MovieClip();
			temp_mc.graphics.beginFill(0x333333, 1);
			temp_mc.graphics.drawRoundRect(150, 30, Game.SCREEN_WIDTH - 300, Game.SCREEN_HEIGHT - 50, 10, 10);
			temp_mc.graphics.endFill();			
			addChild(temp_mc);
			
			
			AddCloseButton(temp_mc, 460, 30);
			
			var next:FormatedTextField = new FormatedTextField();
			next.text = "[next]"; 
			temp_mc.addChild(next);
			next.addEventListener(MouseEvent.CLICK, onNext);
			
			next.y = 350;
			next.x = 400;
			
			
			var prev:FormatedTextField = new FormatedTextField();
			prev.text = "[prev]"; 
			temp_mc.addChild(prev);
			prev.addEventListener(MouseEvent.CLICK, onPrev);
			
			prev.y = 350;
			prev.x = 180;
			
		}
		
		private function onPrev(e:MouseEvent):void 
		{
			
			
			
			for (var i:int = 0; i < contracts.length; i++) 
			{
				if (contracts[i] == cntr) {
					cntr = i - 1 < 0 ? contracts[contracts.length -1] : contracts[i - 1];
					description();
					return;
				}
			}
		}
		
		private function onNext(e:MouseEvent):void 
		{
			
			
			
			for (var i:int = 0; i < contracts.length; i++) 
			{
				if (contracts[i] == cntr) {
					cntr = i + 1 < contracts.length ? contracts[i + 1] : contracts[0];
					description();
					return;
				}
			}
		}
		
		private function description():void {
			for each (var item:FormatedTextField in info) 
			{
				temp_mc.removeChild(item);				
			}
			info.length = 0;
			
			var dy:int = 0;
			
			var t:FormatedTextField = new FormatedTextField(20);
			t.x = 170;
			t.y = 50;
			t.width = 300;
			t.text = cntr.title;
			
			temp_mc.addChild(t)
			info.push(t);
			
			for each (var task:Task in cntr.tasks) 
			{
				t = new FormatedTextField();
				t.width = 300;
				t.x = 170;
				t.y = 140 + dy * 40;
				
				
				var action:String = task.event == TaskType.chopping ? "Chop" : "Kill";
				var how_much:String = task.howMuch.toString();
				t.text = "Task: " + action + " " + task.count + "/" + how_much;
				
				temp_mc.addChild(t);
				info.push(t);
				dy++;
			}
			
			t = new FormatedTextField();
			t.width = 300;
			temp_mc.addChild(t);
			info.push(t);
			t.x = 170;
			t.y = 140 + dy * 40;
			
			t.text = getTimeLeft();
			
			
			t = new FormatedTextField();
				t.width = 300;
				temp_mc.addChild(t);
				info.push(t);
				t.x = 170;
				t.y = 140 + (dy + 1) * 40;
			
			if (cntr.isAchievement) {
				t.text = "Reward: perk";
			}else {
				
				t.text = "Reward: " + cntr.reward_size;
			}
			
		}
		
		override public function build(container:MovieClip, params:Object = null):void 
		{
			contracts = params as Vector.<BaseContract>;			
			if (cntr == null) cntr = contracts[0];	
			description();
			super.build(container, null);
			
			
		}
		
		private function getTimeLeft():String 
		{
			if (cntr.term == 0) return "Unlimited";
			if (cntr.isAchievement) return "Complete in 1 day";
			
			var left:String = "Complete ";
			
				if (cntr.term > 0) {
					var ends:int = cntr.term + cntr.startsFrom;
					var time_left:int = ends - GameWorld.time.time;
					
				}
				if (time_left == 1) {
					left += ends % 2 != 0 ? "till dawn" : "till dusk"
				}
				else if (time_left == 2) {
					left += ends % 2 != 0 ? "till next dawn" : "till next dusk"
				}else if (time_left > 2 && time_left < 5) {
					left += "till tomorrow";
				}
				else if (time_left >= 5) {
					left += "in 2 days";
				}
			
			
			
			return left + " (" + cntr.term + ")";
		
		}
		
	}

}