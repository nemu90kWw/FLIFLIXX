
package fliflixx.object.common
{
	import fliflixx.object.CObject;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import common.Surface;
	import flash.geom.Point;
	import fliflixx.system.Database;
	
	public class CFrame extends CObject
	{
		private static var cell:Object = new Object();
		
		public function CFrame(stage:int)
		{
			switch(stage)
			{
			default: bmp = cell.std; break;
			case 0: bmp = cell.ex; break;
			}
		}
		
		override public function initialize():void
		{
			registerObject("DEPTH_FRAME", "PRIO_FRAME");
			return;
		}
		
		public static function standbyGraphics():void
		{
			cell.std = new BitmapData(640, 400-32, false);
			cell.std.fillRect(new Rectangle(0, 0, 640, 400-32), 0xFFC060);
			cell.std.fillRect(new Rectangle(1, 1, 640-1, 400-32-1), 0x400020);
			cell.std.fillRect(new Rectangle(1, 1, 640-2, 400-32-2), 0xD04000);
			cell.std.fillRect(new Rectangle(15, 15, 640-32+2, 400-32-32+2), 0x400020);
			cell.std.fillRect(new Rectangle(16, 16, 640-32+1, 400-32-32+1), 0xFFC060);
			cell.std.fillRect(new Rectangle(16, 16, 640-32, 400-32-32), 0x188000);
			/*
			cell.std = new BitmapData(640, 400-32, true);
			cell.std.fillRect(new Rectangle(0, 0, 640, 400-32), 0xFFFF0040);
			cell.std.fillRect(new Rectangle(16, 16, 640-32, 400-32-32), 0x06000000);
			*/
			
			//エクストラステージ
			cell.ex = new BitmapData(640, 400-32, false);
			cell.ex.fillRect(new Rectangle(0, 0, 640, 400-32), 0xFFFFFF);
			cell.ex.fillRect(new Rectangle(1, 1, 640-1, 400-32-1), 0x504060);
			cell.ex.fillRect(new Rectangle(1, 1, 640-2, 400-32-2), 0x201828);
			cell.ex.fillRect(new Rectangle(15, 15, 640-32+2, 400-32-32+2), 0x504060);
			cell.ex.fillRect(new Rectangle(16, 16, 640-32+1, 400-32-32+1), 0xFFFFFF);
			cell.ex.fillRect(new Rectangle(16, 16, 640-32, 400-32-32), 0x600800);
			
			return;
		}
		
		override public function draw(screen:Surface):void
		{
			screen.buffer.copyPixels(bmp, bmp.rect, new Point(0, 32));
			return;
		}
	}
}
