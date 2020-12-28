package
{
	import flash.desktop.NativeApplication;
	import flash.display.Screen;
	import flash.display.Sprite;
	import common.Framework;
	import flash.events.InvokeEvent;
	import fliflixx.scenes.SceneController;
	import fliflixx.system.ObjectManager;
	import fliflixx.scenes.LoadingScene;
	
	public class fliflixx extends Sprite
	{
		private var framework:Framework;
		private var scenecontroller:SceneController;
		
		public function fliflixx()
		{
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
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
			scenecontroller.addScene(new LoadingScene());
			return;
		}
		
		private function main():void
		{
			scenecontroller.main();
			scenecontroller.draw();
			return;
		}
	}
}
