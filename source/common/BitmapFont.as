package common
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class BitmapFont
	{
		private var chip:Object = new Object();
		private var width:int;
		private var height:int;
		private var bmp:BitmapData;
		
		public function BitmapFont(bmp:BitmapData, texttable:String, width:int, height:int)
		{
			this.bmp = bmp;
			this.width = width;
			this.height = height;
			
			var num_x:int = bmp.width/width;
			var num_y:int = bmp.height/height;
			
			for(var i:int = 0; i < texttable.length; i++)
			{
				chip[texttable.charAt(i)] = new Rectangle(width*(i % num_x), height*(Math.floor(i / num_x)), width, height);
			}
		}
		
		// --------------------------------//
		// 文字列描画
		// --------------------------------//
		public function draw(surface:BitmapData, txt:String, x:Number, y:Number):void
		{
			var px:Number = x;
			
			for(var i:int = 0; i < txt.length; i++)
			{
				var char:String = txt.charAt(i);
				if(char == "\n")
				{
					y += height;
					x = px;
				}
				else
				{
					surface.copyPixels(bmp, chip[char], new Point(x, y));
					x += width;
				}
			}
			
			return;
		}
		
		// --------------------------------//
		// 文字列の幅を取得
		// --------------------------------//
		public function getTextWidth(txt:String):int
		{
			var size:int = 0;
			var max:int = 0;
			
			for(var i:int = 0; i < txt.length; i++)
			{
				var char:String = txt.charAt(i);
				if(char == "\n")
				{
					max = size;
					size = 0;
				}
				else
				{
					size += width;
				}
			}
			
			return Math.max(size, max);
		}
		
		// --------------------------------//
		// 文字列の高さを取得
		// --------------------------------//
		public function getTextHeight(txt:String):int
		{
			var size:int = height;
			
			for(var i:int = 0; i < txt.length; i++)
			{
				var char:String = txt.charAt(i);
				if(char == "\n")
				{
					size += height;
				}
			}
			
			return size;
		}
	}
}