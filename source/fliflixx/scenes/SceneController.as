
package fliflixx.scenes
{
	import flash.geom.Transform;
	import common.Screen;
	import fliflixx.object.CObject;
	
	public class SceneController
	{
		private var currentscene:SceneBase 
		private var screen:Screen;
		private var scenestack:Array = new Array();
		
		public function SceneController(screen:Screen)
		{
			this.screen = screen;
			SceneBase.screen = screen;
			SceneBase.sc = this;
		}
		
		public function addScene(scene:SceneBase):void
		{
			currentscene = scene;
			return;
		}
		
		public function main():void
		{
			currentscene.main();
			return;
		}
		
		public function draw():void
		{
			currentscene.draw();
			return;
		}
	}
}
