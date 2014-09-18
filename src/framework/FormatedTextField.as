package framework 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author DG
	 */
	public class FormatedTextField extends TextField
	{
		
		public static const HEADER:int = 24;
		
		
		public static var NOKIA_WHITE:TextFormat = new TextFormat("nokia", 14, 0xffffff);
		
		public function FormatedTextField(size_:int = 0, color_:uint = 0xffffff, center:Boolean = false) 
		{
			
			
			
			super();
			embedFonts = true;			
			defaultTextFormat = size_ == 0 ? NOKIA_WHITE : new TextFormat("nokia", size_, color_, null,null,null,null,null, center? "center" : null);			
			selectable = false;
			multiline = true;
			wordWrap = true;
			
			
		}
		
	}

}