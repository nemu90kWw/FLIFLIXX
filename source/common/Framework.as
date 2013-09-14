package common
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.utils.getTimer;
	import flash.ui.ContextMenu;
	
	import flash.ui.ContextMenuItem;
	import flash.events.ContextMenuEvent;
	import flash.geom.Rectangle;
	
	public class Framework
	{
		public var screen:Screen;
		
		private var root:Sprite;
		private var stage:Stage;
		private var fps:Number;
		private var mainloop:Function;
		
		public function Framework(sprite:Sprite, func:Function, width:uint, height:uint)
		{
			root = sprite;
			stage = sprite.stage;
			fps = stage.frameRate;
			mainloop = func;
			
			//stage.quality = StageQuality.LOW;
			stage.stageFocusRect = false;
			
			AppInfo.registerMainSprite(root);
			
			//入力
			//Key.setListener(root);
			Mouse.setListener(stage);
			
			//画面
			screen = new Screen(root, new BitmapData(width, height, false, 0x000000));
			
			root.contextMenu = new ContextMenu();
			root.contextMenu.hideBuiltInItems();
			
			if(AppInfo.isVersion(9,0,60))
			{
				var item:ContextMenuItem = new ContextMenuItem("フルスクリーン");
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fullScreen);
				root.contextMenu.customItems.push(item);
			}
			
			root.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			return;
		}
		
		private function fullScreen(event:ContextMenuEvent):void
		{
			stage.fullScreenSourceRect = screen.buffer.rect;
			stage.displayState = "fullScreen";
		}
		
		// --------------------------------//
		// メインループ
		// --------------------------------//
		private var timer:Number = 0;
		private function onEnterFrame(event:Event):void
		{
			if(AppInfo.frameSkip == true)
			{
				for(; timer < getTimer(); timer += 1000 / fps) {
					main();
				}
			}
			else {
				if(timer < getTimer())
				{
					timer += 1000 / fps;
					main();
				}
			}
			
			if(getTimer() - timer > 200) {
				timer = getTimer();
			}
			
			return;
		}
		
		private function main():void
		{
			Mouse.main();
			
			screen.buffer.lock();
			mainloop();
			screen.buffer.unlock();
			
			func_bgm.main();
			func_se.main();
		}
	}
}