package
{
	import common.Framework;
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindowDisplayState;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.FullScreenEvent;
	import flash.events.InvokeEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	import fliflixx.scenes.InitializeScene;
	import fliflixx.scenes.SceneController;
	import fliflixx.system.Menu;
	import fliflixx.system.ObjectManager;
	
	public class fliflixx extends Sprite
	{
		[Embed(source = "fliflixx.swf")]
		private static var SourceSWF:Class;
		private static var target:Sprite;
		
		private static var framework:Framework;
		private var scenecontroller:SceneController;
		
		private var menu:Menu;
		private var focusRect:Sprite;
		
		public function fliflixx()
		{
			target = this;
			
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		public static function launchAS1():void
		{
			framework.abort();
			
			target.stage.frameRate = 20;
			target.addChild(new SourceSWF());
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			focusRect = new Sprite();
			focusRect.graphics.beginFill(0, 1);
			focusRect.graphics.drawRect(0, 0, 640, 400);
			addChild(focusRect);
			
			menu = new Menu(stage.nativeWindow, this);
			menu.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			
			stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, onDisplayStateChanging);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.stageWidth = 640 / stage.contentsScaleFactor;
			stage.stageHeight = 400 / stage.contentsScaleFactor;
			scaleX = scaleY = 1 / stage.contentsScaleFactor;
			
			// センタリングして表示
			stage.nativeWindow.x = (Screen.mainScreen.visibleBounds.width - stage.nativeWindow.width) / 2;
			stage.nativeWindow.y = (Screen.mainScreen.visibleBounds.height - stage.nativeWindow.height) / 2;
			stage.nativeWindow.visible = true;
			
			framework = new Framework(this, main, 640, 400);
			
			//先
			ObjectManager.addPriority("PRIO_SYSTEM");
			ObjectManager.addPriority("PRIO_ENEMY");
			ObjectManager.addPriority("PRIO_BLOCK");
			ObjectManager.addPriority("PRIO_MISSILE");
			ObjectManager.addPriority("PRIO_FRAME");
			ObjectManager.addPriority("PRIO_EFFECT");
			//後
			
			//奥
			ObjectManager.addDepth("DEPTH_FRAME");
			ObjectManager.addDepth("DEPTH_ERASE");
			ObjectManager.addDepth("DEPTH_ENEMY");
			ObjectManager.addDepth("DEPTH_MISSILE");
			ObjectManager.addDepth("DEPTH_BLOCK");
			ObjectManager.addDepth("DEPTH_EFFECT");
			ObjectManager.addDepth("DEPTH_MESSAGE");
			//手前
			
			addChild(cursor);
			
			scenecontroller = new SceneController(framework.screen);
			scenecontroller.addScene(new InitializeScene());
			return;
		}
		
		private function main():void
		{
			scenecontroller.main();
			scenecontroller.draw();
			return;
		}
		
		private function onDisplayStateChanging(e:NativeWindowDisplayStateEvent):void 
		{
			// 最大化の代わりにフルスクリーンにする
			if (e.afterDisplayState == NativeWindowDisplayState.MAXIMIZED)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				e.preventDefault();
			}
		}
		
		private function onFullScreen(e:FullScreenEvent):void 
		{
			if (e.fullScreen == true) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			if (e.fullScreen == false) {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
	}
}
