package common
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.events.IOErrorEvent;
	import flash.utils.Dictionary;
	import flash.net.URLLoaderDataFormat;
	
	public class MultiLoader
	{
		private var data:Object = new Object();
		
		private var urllist:Dictionary = new Dictionary();
		private var errorlist:Array = new Array();
		
		// --------------------------------//
		// 読み込み
		// --------------------------------//
		public function load(type:String, name:String, url:String):*
		{
			switch(type)
			{
			case "SWF"    : return loadSWF(name, url);
			case "BITMAP" : return loadBitmap(name, url);
			case "BGM"    : return loadSound(name, url);
			case "SOUND"  : return loadSound(name, url);
			case "XML"    : return loadXML(name, url);
			case "BINARY" : return loadBinary(name, url);
			}
		}
		
		public function loadSWF(name:String, url:String):Loader
		{
			data[name] = new Loader();
			data[name].load(new URLRequest(url));
			
			urllist[data[name].contentLoaderInfo] = url;
			data[name].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			return data[name];
		}
		
		public function loadBitmap(name:String, url:String):Loader
		{
			return loadSWF(name, url);
		}
		
		public function loadSound(name:String, url:String):Sound
		{
			data[name] = new Sound(new URLRequest(url));
			
			urllist[data[name]] = url;
			data[name].addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			return data[name];
		}
		
		public function loadXML(name:String, url:String):URLLoader
		{
			data[name] = new URLLoader(new URLRequest(url));
			
			urllist[data[name]] = url;
			data[name].addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			return data[name];
		}
		
		public function loadBinary(name:String, url:String):URLLoader
		{
			var loader:URLLoader = loadXML(name, url);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			return loader;
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			errorlist.push(urllist[e.currentTarget]);
		}
		
		// --------------------------------//
		// 取得
		// --------------------------------//
		public function getContent(name:String):*
		{
			var item:* = data[name];
			
			if(item is Loader)
			{
				if(item.content is Bitmap) {return item.content.bitmapData;}
				else {return item.content;}
			}
			if(item is Sound) {return item;}
			if(item is URLLoader) {return item.data;}
		}
		
		// --------------------------------//
		// 読み込み状態の確認
		// --------------------------------//
		public function isComplete():Boolean
		{
			for each(var item:* in data)
			{
				if(item is Loader) {
					if(item.content == null) {return false;}
				}
				if(item is URLLoader) {
					if(item.data == null) {return false;}
				}
				if(item is Sound) {
					if((item.bytesLoaded < item.bytesTotal) && (item.bytesTotal > 0)) {return false;}
				}
			}
			
			return true;
		}
		
		public function getBytesLoaded():int
		{
			var bytes:int;
			for each(var item:* in data)
			{
				if(item is Loader) {bytes += item.loadeeInfo.bytesLoaded;}
				if(item is Sound) {bytes += item.bytesLoaded;}
				if(item is URLLoader) {bytes += item.bytesLoaded;}
			}
			
			if(bytes == 0) {return -1;}
			else {return bytes;}
		}
		
		public function getBytesTotal():int
		{
			var bytes:int;
			for each(var item:* in data)
			{
				if(item is Loader) {bytes += item.loadeeInfo.bytesTotal;}
				if(item is Sound) {bytes += item.bytesTotal;}
				if(item is URLLoader) {bytes += item.bytesTotal;}
			}
			
			return bytes;
		}
		
		public function isError():Boolean
		{
			return errorlist.length != 0;
		}
		
		public function getErrorFiles():Array
		{
			return errorlist;
		}
	}
}