package fliflixx.system
{
	public class Database
	{
		private static var data:Object = new Object();
		
		public static function addItem(name:String, item:*):void
		{
			data[name] = item;
			return;
		}
		
		public static function getItem(name:String):*
		{
			return data[name];
		}
	}
}