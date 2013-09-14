
package fliflixx.system
{
	import common.LocalDataManager;
	
	public class Ranking
	{
		private const RANKING_MAX:uint = 10;
		private var func_ldm:LocalDataManager = new LocalDataManager("FLIFLIXX_RANKING");
		public var data:Array = new Array();
		
		public function Ranking()
		{
			data.score = new Array();
			data.name  = new Array();
			data.stage = new Array();
			data.date  = new Array();
			
			for(var i:int = 1; i <= RANKING_MAX; i++)
			{
				func_ldm.setDefault("score"+i, (2048>>i)*100);
				func_ldm.setDefault("name"+i, "nemu90kWw.");
				func_ldm.setDefault("stage"+i, " "+Math.max(6-i, 1)+"-"+Math.max(Math.min(256>>i, 10)%9, 1));
				
				func_ldm.setDefault("date"+i, "06/03/21");
			}
			func_ldm.setDefault("stage1", "clear");
		}
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function initialize():void
		{
			func_ldm.initialize();
			
			for(var i:int = 1; i <= RANKING_MAX; i++)
			{
				data.score[i] = func_ldm.getDefault("score"+i);
				data.name[i]  = func_ldm.getDefault("name"+i);
				data.stage[i] = func_ldm.getDefault("stage"+i);
				data.date[i]  = func_ldm.getDefault("date"+i);
			}
			
			return;
		}
		
		// --------------------------------//
		// 保存
		// --------------------------------//
		public function saveData():void
		{
			for(var i:int = 1; i <= RANKING_MAX; i++)
			{
				func_ldm.saveData("score"+i, data.score[i]);
				func_ldm.saveData("name"+i,  data.name[i]);
				func_ldm.saveData("stage"+i, data.stage[i]);
				func_ldm.saveData("date"+i,  data.date[i]);
			}
			
			return;
		}
		
		// --------------------------------//
		// ローカルデータから読み込み
		// --------------------------------//
		public function loadData():void
		{
			for(var i:int = 1; i <= RANKING_MAX; i++)
			{
				data.score[i] = func_ldm.loadData("score"+i);
				data.name[i]  = func_ldm.loadData("name"+i);
				data.stage[i] = func_ldm.loadData("stage"+i);
				data.date[i]  = func_ldm.loadData("date"+i);
			}
			
			return;
		}
		
		// --------------------------------//
		// 判定
		// --------------------------------//
		public function isRankIn(score:Number):*
		{
			for(var i:int = 1; i <= RANKING_MAX; i++)
			{
				if(data.score[i] < score)
				{
					return i;
				}
			}
			
			return false;
		}
		
		// --------------------------------//
		// 順位を下にずらす処理
		// --------------------------------//
		public function insert(rank:uint, score:uint, stage:uint, area:uint):void
		{
			for(var i:int = RANKING_MAX; i >= rank; i--)
			{
				if(i < RANKING_MAX)
				{
					data.score[i+1] = data.score[i];
					data.name[i+1]  = data.name[i];
					data.stage[i+1] = data.stage[i];
					data.date[i+1]  = data.date[i];
				}
				
				data.name[i] = "";
				data.score[i] = score;
				if(stage == 5) {data.stage[i] = "clear";}
				else {data.stage[i] = " "+stage+"-"+area;}
				data.date[i] = getTimeStamp();
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
			if(func_ldm.isError() == true)
			{
				return true;
			}
			
			var iserror:Boolean = false;
			
			//型チェック
			var datatype:String;
			for(var j:* in data)
			{
				for(var i:int = 1; i <= RANKING_MAX; i++)
				{
					switch(j)
					{
					case "score":
						datatype = "number";
						break;
					case "name":
					case "stage":
					case "date":
						datatype = "string";
						break;
					}
					if(typeof(data[j][i]) != datatype)
					{
						iserror = true;
					}
				}
			}
			
			return iserror;
		}
		
		// --------------------------------//
		// タイムスタンプ
		// --------------------------------//
		public function getTimeStamp():String
		{
			var date:Date = new Date();
			var temp:Array = new Array();
			var txt:String = "";
			
			temp.push((date.getFullYear()%100).toString());
			temp.push((date.getMonth()+1).toString());
			temp.push(date.getDate().toString());
			
			for(var i:int = 0; i < temp.length; i++)
			{
				if(i > 0) {txt+="/";}
				if(temp[i].length == 1) {txt += "0";}
				txt += temp[i];
			}
			
			return txt;
		}
	}
}
