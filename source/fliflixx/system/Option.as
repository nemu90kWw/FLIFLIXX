
package fliflixx.system
{
	import common.LocalDataManager;
	
	public class Option
	{
		private var func_ldm:LocalDataManager = new LocalDataManager("FLIFLIXX_AS3_OPTION");
		public var data:Array = new Array();
		
		public function Option()
		{
			func_ldm.setDefault("bgmtype", "ORIGINAL");
		}
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function initialize():void
		{
			func_ldm.initialize();
			data.bgmtype = func_ldm.getDefault("bgmtype");
			return;
		}
		
		// --------------------------------//
		// 保存
		// --------------------------------//
		public function saveData():void
		{
			func_ldm.saveData("bgmtype", data.bgmtype);
			return;
		}
		
		// --------------------------------//
		// ローカルデータから読み込み
		// --------------------------------//
		public function loadData():void
		{
			data.bgmtype  = func_ldm.loadData("bgmtype");
			return;
		}
		
		// --------------------------------//
		// 未使用かどうか
		// --------------------------------//
		public function isEmpty():Boolean
		{
			return func_ldm.isEmpty();
		}
		
		// --------------------------------//
		// エラーチェック
		// --------------------------------//
		public function isError():Boolean
		{
			if(func_ldm.isError() == true)
			{
				return true;
			}
			
			var iserror:Boolean = false;
			
			//型チェック
			var datatype:String;
			for(var i:* in data)
			{
				switch(i)
				{
				case "bgmtype":
					datatype = "string";
					break;
				}
				if(typeof(data[i]) != datatype)
				{
					iserror = true;
				}
			}
			
			return iserror;
		}
	}
}
