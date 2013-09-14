
package fliflixx.system
{
	import common.LocalDataManager;
	
	public class BestRecords
	{
		private var func_ldm:LocalDataManager = new LocalDataManager("FLIFLIXX_RECORD");
		public var data:Array = new Array();
		
		public function BestRecords()
		{
			data.record = new Array();
			
			for(var i:int = 0; i <= 4; i++)
			{
				data.record[i] = new Array();
				
				for(var j:int = 1; j <= 8; j++) {
					func_ldm.setDefault("record"+i+"-"+j, 99.99);
				}
			}
		}
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function initialize():void
		{
			func_ldm.initialize();
			
			for(var i:int = 0; i <= 4; i++) {
				for(var j:int = 1; j <= 8; j++) {
					data.record[i][j] = func_ldm.getDefault("record"+i+"-"+j);
				}
			}
			
			return;
		}
		
		// --------------------------------//
		// 保存
		// --------------------------------//
		public function saveData():void
		{
			for(var i:int = 0; i <= 4; i++) {
				for(var j:int = 1; j <= 8; j++) {
					func_ldm.saveData("record"+i+"-"+j, data.record[i][j]);
				}
			}
			
			return;
		}
		
		// --------------------------------//
		// ローカルデータから読み込み
		// --------------------------------//
		public function loadData():void
		{
			for(var i:int = 0; i <= 4; i++) {
				for(var j:int = 1; j <= 8; j++) {
					data.record[i][j] = func_ldm.loadData("record"+i+"-"+j);
				}
			}
			
			return;
		}
		
		// --------------------------------//
		// 判定
		// --------------------------------//
		public function isBest(stage:int, area:int, time:Number):Boolean
		{
			if(data.record[stage][area] > time) {
				return true
			}
			else {
				return false;
			}
		}
		
		public function entry(stage:int, area:int, time:Number):void
		{
			if(data.record[stage][area] > time) {
				data.record[stage][area] = time;
			}
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
			return func_ldm.isError();
		}
	}
}
