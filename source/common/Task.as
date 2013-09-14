package common
{
	public class Task
	{
		public var count:int = 0;
		public var actfunc_ref:String = "act_stop";
		
		// --------------------------------//
		// 状態遷移
		// --------------------------------//
		public function main():void
		{
			this[actfunc_ref]();
			count++;
			return;
		}
		
		public function act_stop():void
		{
			return;
		}
		
		public function changeAction(funcname:String):void
		{
			//初期化
			count = 0;
			
			//登録
			actfunc_ref = funcname;
			
			//初期化処理があるので一回実行しておく
			main();
			
			return;
		}
	}
}