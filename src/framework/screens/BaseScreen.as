package framework.screens {
import flash.display.Sprite;
import flash.events.Event;

/**
 * ...
 * @author JuzTosS
 */
public class BaseScreen extends Sprite {

	public function BaseScreen() {
		super();
	}
	
	protected function background(clr:uint):Sprite {
		
		var bg:Sprite = new Sprite();
			with (bg) {
			
				graphics.beginFill(clr);
				graphics.drawRect(0, 0, Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT);
				graphics.endFill();
			}
			
			addChild(bg);	
			
			return bg;
	}

	public function show():void {
		onStartShowing();
		this.alpha = 0;
		addEventListener(Event.ENTER_FRAME, showStep);
		dispatchEvent(new ScreenEvent(ScreenEvent.SHOW_COMPLETE));
		
		
		if (stage) focus();
		else addEventListener(Event.ADDED_TO_STAGE, focus);
		
	}
	
	private function focus():void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, focus);		
		stage.focus = this;
		
	}

	public function hide():void {
		
		onStartHiding();
		
		this.alpha = 1;
		addEventListener(Event.ENTER_FRAME, hideStep);
		dispatchEvent(new ScreenEvent(ScreenEvent.HIDE_COMPLETE));
		
		
	}
	
	protected function onHidden():void 
	{
		
	}
	
	protected function onReady():void
	{
		
	}
	
	protected function onStartHiding():void {
		
	}
	
	protected function onStartShowing():void {
		
	}

	private function hideStep(e:Event):void {
		this.alpha -= .1;
		if (this.alpha <= 0) {
			onHidden();
			this.alpha = 0;
			removeEventListener(Event.ENTER_FRAME, hideStep);
			dispatchEvent(new ScreenEvent(ScreenEvent.HIDE_COMPLETE));
		}
	}

	private function showStep(e:Event):void {
		this.alpha += .1;
		if (this.alpha >= 1) {
			this.alpha = 1;
			onReady();
			removeEventListener(Event.ENTER_FRAME, showStep);
			dispatchEvent(new ScreenEvent(ScreenEvent.SHOW_COMPLETE));
		}
	}


	public function init(...args):void {
		//must be overriden;
	}
}

}