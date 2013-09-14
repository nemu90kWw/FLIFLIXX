package common
{
	import flash.net.SharedObject;
	
	public class LocalDataManager
	{
		private var so:SharedObject;
		private var data:Object = new Object();
		private var def:Object = new Object();
		private var reflist:Array = new Array();
		
		public function LocalDataManager(name:String)
		{
			so = SharedObject.getLocal(name);
			
			data = so.data;
			
			for( var i:int = 0; i < data.len; i++ ) {
				reflist[data.name[i]] = i;
			}
			
			//データが無い
			if(data.len == undefined) {
				initialize();
			}
		}
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function initialize():void
		{
			data.name = new Array();	//領域名
			data.type = new Array();	//データの種類
			data.data = new Array();	//データ
			
			data.len = 0;	//データの数
			data.pass = 0;	//認証用パスワード
			
			reflist = new Array();
			
			return;
		}
		
		// --------------------------------//
		// エラーチェック
		// --------------------------------//
		public function isError():Boolean
		{
			var temp:uint = 0;
			
			for( var i:int = 0; i < data.len; i++ )
			{
				//改造されてないかチェック
				if(data.type[i]=="num")
				{
					//数値
					temp ^= data.data[i];
				}
				else if(data.type[i]=="str")
				{
					//文字列
					for( var k:int = 0; k < data.data[i].length; k++ ) {
						temp ^= data.data[i].charCodeAt(k);
					}
				}
			}
			
			if( data.pass != temp ) {
				return true;
			}
			
			return false;
		}
		
		// --------------------------------//
		// デフォルト値の読み書き
		// --------------------------------//
		public function setDefault(name:String, dat:*):void
		{
			def[name] = dat;
			return;
		}
		
		public function getDefault(name:String):*
		{
			return def[name];
		}
		
		// --------------------------------//
		// データの保存
		// --------------------------------//
		public function saveData(name:String, dat:*):void
		{
			if(reflist[name] == undefined)
			{
				data.name[data.len] = name;
				reflist[name] = data.len;
	
				data.len++;
			}
			
			var ref:String = reflist[name];
			
			//認証値を戻す
			if( data.data[ref] != undefined )
			{
				if( data.type[ref] == "str" )
				{
					for( var k:int = 0; k < data.data[ref].length; k++ ) {
						data.pass ^= data.data[ref].charCodeAt(k);
					}
				}
				else if( data.type[ref] == "num" )
				{
					data.pass ^= data.data[ref];
				}
			}
			
			//文字列
			if( typeof(dat) == "string" )
			{
				data.type[ref] = "str";
				data.data[ref] = dat;
				
				for( var k:int = 0; k < dat.length; k++ ) {
					data.pass ^= dat.charCodeAt(k);
				}
				return;
			}
			
			//数値
			if( typeof(dat) == "number" )
			{
				data.type[ref] = "num";
				data.data[ref] = dat;
	
				data.pass ^= data.data[ref];
				return;
			}
			
			//その他はそのまま格納
			data.type[ref] = "etc";
			data.data[ref] = dat;
			
			return;
		}
	
		// --------------------------------//
		// データの読み込み
		// --------------------------------//
		public function loadData(name:String):*
		{
			if(reflist[name] == undefined)
			{
				if(def[name] == undefined)
				{
					return undefined;
				}
				return def[name];
			}
			
			var ref:String = reflist[name];
			
			return data.data[ref];
		}
	
		// --------------------------------//
		// 未使用かどうか
		// --------------------------------//
		public function isEmpty():Boolean
		{
			if(data.len==0) {
				return true;
			}
			else {
				return false;
			}
		}
	}
}