
package fliflixx.object.common
{
	import fliflixx.object.CObject;
	import common.Mouse;
	import flash.display.BitmapData;
	
	public class CButton extends CObject
	{
		public var label:String = "";
		public var param:*;
		
		private var currentframe:String = "UP";
		
		public var defx:Number = 0;
		public var defy:Number = 0;
		public var width:Number = 0;
		public var height:Number = 0;
		
		public var press:Boolean = false;
		public var down:Boolean = false;
		public var release:Boolean = false;
		public var decided:Boolean = false;
		
		public var operate:Boolean = true;
		
		public function CButton(font:String, label:String)
		{
			setLabel(font, label);
			return;
		}
		
		override public function initialize():void
		{
			defx = x;
			defy = y;
			
			registerObject("DEPTH_MESSAGE", "PRIO_SYSTEM");
			
			changeAction("act_main");
			return;
		}
		
		public function setLabel(font:String, label:String):void
		{
			this.label = label;
			
			width = func_text.getTextWidth(font, label);
			height = func_text.getTextHeight(font, label);
			
			bmp = new BitmapData(width, height, true, 0);
			
			func_text.draw(font, bmp, label, 0, 0);
			return;
		}
		
		public function hitTest(x:Number, y:Number):Boolean
		{
			var left:Number   = defx - width/2;
			var right:Number  = defx + width/2;
			var top:Number    = defy - height/2;
			var bottom:Number = defy + height/2;
			
			if(left < x && right > x && top < y && bottom > y) {
				return true;
			}
			else {
				return false;
			}
		}
		
		// --------------------------------//
		// メイン
		// --------------------------------//
		public function act_main():void
		{
			switch(currentframe) {
			case "UP": x = defx; y = defy; break;
			case "DOWN": x = defx+1; y = defy+1; break;
			case "OVER": x = defx-2; y = defy-2; break;
			}
			
			if(operate == true)
			{
				//当たり判定
				if(hitTest(Mouse.x, Mouse.y))
				{
					//押した
					if(Mouse.press) {
						down = true;
					}
					
					if(down == true)
					{
						//決定した
						if(Mouse.release)
						{
							decided = true;
							down = false;
							currentframe = "UP";
							return;
						}
						
						currentframe = "DOWN";
					}
					else {
						currentframe = "OVER";
					}
				}
				else {
					currentframe = "UP";
				}
				
				//離した
				if(Mouse.release) {
					down = false;
				}
			}
				
			return;
		}
	}
}
