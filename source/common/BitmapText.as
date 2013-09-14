
package common
{
	import flash.display.BitmapData;
	import common.BitmapFont;
	
	public class BitmapText
	{
		private var fontlist:Object = new Object();
		
		// --------------------------------//
		// フォント追加
		// --------------------------------//
		public function addFont(name:String, bmp:BitmapData, texttable:String, width:int, height:int):void
		{
			fontlist[name] = new BitmapFont(bmp, texttable, width, height);
			return;
		}
		
		// --------------------------------//
		// 文字列描画
		// --------------------------------//
		public function draw(font:String, bmp:BitmapData, txt:String, x:Number, y:Number):void
		{
			fontlist[font].draw(bmp, txt, x, y);
			return;
		}
		
		// --------------------------------//
		// 描画する文字列のドット数取得
		// --------------------------------//
		public function getTextWidth(font:String, txt:String):int
		{
			return fontlist[font].getTextWidth(txt);
		}
		
		public function getTextHeight(font:String, txt:String):int
		{
			return fontlist[font].getTextHeight(txt);
		}
	}
}
