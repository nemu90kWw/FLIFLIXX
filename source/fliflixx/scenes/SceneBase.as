
package fliflixx.scenes
{
	import common.Screen;
	import fliflixx.scenes.SceneController;
	import common.Task;
	import fliflixx.system.ObjectManager;
	import fliflixx.object.CObject;
	
	public class SceneBase extends Task
	{
		private var fadeout_nextaction:String;
		
		public static var screen:Screen;
		public static var sc:SceneController;
		
		public var func_obj:ObjectManager = new ObjectManager(screen);
		
		public function act_fadeout():void
		{
			if(count == 42)
			{
				screen.setColor(1, 1, 1, 1, 0, 0, 0, 0);
				screen.buffer.fillRect(screen.buffer.rect, 0);
				
				changeAction(fadeout_nextaction);
				return;
			}
			screen.setColor(1-count/30, 1-count/30, 1-count/30, 1, 0, 0, 0, 0);
			
			return;
		}
		
		public function changeAction_fadeout(func:String):void
		{
			changeAction("act_fadeout");
			fadeout_nextaction = func;
			
			return;
		}

		public function changeScene(scene:SceneBase):void
		{
			sc.addScene(scene);
			return;
		}
		
		public function createObject(instance:*):*
		{
			instance.scene = this;
			instance.initialize();
			return instance;
		}
		
		// --------------------------------//
		// 共通関数
		// --------------------------------//
		override public function main():void
		{
			func_obj.run();
			
			this[actfunc_ref]();
			count++;
			
			return;
		}
		
		public function draw():void
		{
			func_obj.draw();
			return;
		}
	}
}
