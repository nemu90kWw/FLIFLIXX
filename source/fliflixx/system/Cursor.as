package fliflixx.system
{
	import flash.display.Sprite;
	import flash.events.Event;
	import common.Mouse;
	
	public class Cursor extends Sprite
	{
		private var prepos_x:Number = 0;
		private var prepos_y:Number = 0;
		private var sleeptimer:int = 0;
		private var scale:Number = 1;
		public var _visible:Boolean = false;
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function Cursor()
		{
			graphics.beginFill(0xFFFFFF);
			graphics.drawCircle(0, 0, 5);
			graphics.endFill();
			
			graphics.beginFill(0, 0);
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.drawCircle(0, 0, 16);
			graphics.lineStyle(1, 0xFFFFFF);
			graphics.drawCircle(0, 0, 8);
			graphics.endFill();
			
			visible = false;
			mouseEnabled = false;
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			return;
		}
		
		// --------------------------------//
		// メイン
		// --------------------------------//
		private function onEnterFrame(event:Event):void
		{
			var action:Boolean = true;
			
			prepos_x = x;
			prepos_y = y;
			x = Mouse.x;
			y = Mouse.y;
			
			if(Mouse.press) {
				scale = 1.1;
			}
			else if(Mouse.down) {
				scale = (scale*2 + 0.8) / 3;
			}
			else if(Mouse.release) {
				scale = 0.7;
			}
			else
			{
				scale = (scale*4 + 1) / 5;
				
				if(prepos_x == x && prepos_y == y) {
					action = false;
				}
			}
			
			if(action == false) {
				sleeptimer--;
			}
			else {
				sleeptimer = 180;
			}
			
			if(_visible == false || sleeptimer <= 0) {
				visible = false;
			}
			else if(_visible == true){
				visible = true;
			}
			
			scaleX = scale;
			scaleY = scale;
			return;
		}
	}
}