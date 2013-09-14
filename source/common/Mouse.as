package common
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.ui.Mouse;
	
	public class Mouse
	{
		public static var x:Number = 0;
		public static var y:Number = 0;
		
		private static var isDown:Boolean = false;
		public static var down:Boolean = false;
		public static var press:Boolean = false;
		public static var release:Boolean = false;
		
		public static function setListener(stage:Stage):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private static function onMouseMove(event:Event):void
		{
			x = event.target.mouseX;
			y = event.target.mouseY;
			
			flash.ui.Mouse.hide();
		}
		
		private static function onMouseDown(event:Event):void
		{
			isDown = true;
		}
		
		private static function onMouseUp(event:Event):void
		{
			isDown = false;
		}
		
		public static function main():void
		{
			if(isDown == true)
			{
				if(down == false) {press = true;}
				             else {press = false;}
				
				down = true;
				release = false;
			}
			else
			{
				if(down == true) {release = true;}
				            else {release = false;}
				
				down = false;
				press = false;
			}
		}
	}
}
