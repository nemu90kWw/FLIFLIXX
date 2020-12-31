
package fliflixx.object.maingame
{
	import fliflixx.object.maingame.CGameObject;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import common.Surface;
	import flash.geom.Point;
	import fliflixx.system.Database;
	
	public class CStatusBar extends CGameObject
	{
		private var bmp_minilogo:BitmapData = Database.getItem("BMP_MINILOGO");
		
		override public function initialize():void
		{
			registerObject("DEPTH_FRAME", "PRIO_FRAME");
			
			bmp = new BitmapData(640, 32, false);
			return;
		}
		
		override public function draw(screen:Surface):void
		{
			bmp.fillRect(new Rectangle(0, 0, 640, 32), 0x000000);
			
			bmp.copyPixels(bmp_minilogo, bmp_minilogo.rect, new Point(156, 3));
			
			func_text.draw("16px_y", bmp, "STAGE", 11, 4);
			func_text.draw("16px_y", bmp, "SCORE", 306, 4);
			func_text.draw("16px_y", bmp, "TIME", 493, 4);
			
			var temp:String;
			
			if(getStage() == 0) {
				temp = "Ex"+getArea();
			}
			else {
				temp = getStage()+"-"+getArea();
			}
			func_text.draw("16px", bmp, temp, 96, 4);
			
			temp = MathEx.addZero(getScore(), 6);
			func_text.draw("16px", bmp, temp, 390, 4);
			
			switch(getGameMode()) {
			case "SEQUENTIAL":
				var min:String = MathEx.addZero(Math.floor(getTime() / 60), 2);
				var sec:String = MathEx.addZero(Math.floor(getTime() % 60), 2);
				func_text.draw("16px", bmp, min, 559, 4);
				func_text.draw("16px", bmp, sec, 599, 4);
				func_text.draw("16px", bmp, "\'", 589, 4);
				break;
			case "SINGLE":
				var sec:String = MathEx.addZero(Math.floor(getTime()), 2);
				var dn:String  = MathEx.addZero(Math.floor(getTime()*100 % 100), 2);
				func_text.draw("16px", bmp, sec, 559, 4);
				func_text.draw("16px", bmp, dn,  599, 4);
				func_text.draw("16px", bmp, ".", 589, 4);
				break;
			}
			
			screen.buffer.copyPixels(bmp, bmp.rect, new Point(0, 0));
		}
	}
}
