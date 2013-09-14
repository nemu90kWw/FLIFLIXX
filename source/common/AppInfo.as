package common
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.Capabilities;
	
	public class AppInfo
	{
		private static var root:Sprite;
		private static var stage:Stage;
		
		public static function registerMainSprite(sprite:Sprite):void
		{
			root = sprite;
			stage = sprite.stage;
			return;
		}
		
		// --------------------------------//
		// バージョンチェック
		// --------------------------------//
		public static function isVersion(major:int, minor:int = 0, build:int = 0, revision:int = 0):Boolean
		{
			var currentver:Array = Capabilities.version.split(/[ ,]/);
			var checkver:Array = ["", major, minor, build, revision];
			
			for (var i:int = 1; i < checkver.length; i++)
			{
				if (currentver[i] > checkver[i]) {return true;}
				if (currentver[i] < checkver[i]) {return false;}
			}
			return true;
		}
		
		// --------------------------------//
		// プロパティ
		// --------------------------------//
		public static function set frameRate(num:Number):void {stage.frameRate = num;}
		public static function get frameRate():Number {return stage.frameRate;}
		
		public static var frameSkip:Boolean = false;
	}
}