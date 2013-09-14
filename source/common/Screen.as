package common
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	
	public class Screen
	{
		public var buffer:BitmapData;
		private var dispobj:Shape;
		
		public function Screen(target:Sprite, bmp:BitmapData)
		{
			dispobj = new Shape();
			buffer  = bmp;
			
			target.addChild(dispobj);
			dispobj.graphics.beginBitmapFill(bmp);
			dispobj.graphics.drawRect(0, 0, bmp.width, bmp.height);
			
			return;
		}
		
		public function setScale(x:Number, y:Number):void
		{
			dispobj.scaleX = x;
			dispobj.scaleY = y;
		}
		
		public function clear(color:uint = 0):void
		{
			buffer.fillRect(buffer.rect, color);
		}
		
		public function setColor(
		  ra:Number, ga:Number, ba:Number, aa:Number,
		  rb:Number, gb:Number, bb:Number, ab:Number):void
		{
			dispobj.transform.colorTransform = new ColorTransform(ra, ga, ba, aa, rb, gb, bb, ab);
			return;
		}
	}
}