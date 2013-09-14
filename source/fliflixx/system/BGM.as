
package fliflixx.system
{
	import flash.net.LocalConnection;
	import fliflixx.system.PlayData;
	
	public class BGM
	{
		private var lc:LocalConnection = new LocalConnection();
		private var playflag:Boolean = false;
		
		// 関数を包含
		public function main():void {
			if(playflag == true) {lc.send("swf8connector", "main");}
		}
		public function stop():void {
			playflag = false;
			lc.send("swf8connector", "stop");
		}
		
		public function fadeout():void {lc.send("swf8connector", "fadeout");}
		public function setVolume(num:Number):void       {lc.send("swf8connector", "setVolume", num);}
		public function setMasterVolume(num:Number):void {lc.send("swf8connector", "setMasterVolume", num);}
		
		// --------------------------------//
		// 曲の再生
		// --------------------------------//
		public function play(name:String):void
		{
			playflag = true;
			
			if(PlayData.option.data.bgmtype == "FAMICOM")
			{
				name += "_FC";
			}
			
			//曲名を渡す
			lc.send("swf8connector", "attachSound", name);

			switch (name)
			{
			// めろぱ
			case "BGM_STAGE1" :
				lc.send("swf8connector", "play", 91.5, -90.1);
				break;
			case "BGM_STAGE1_FC" :
				lc.send("swf8connector", "play", 94.2, -93.3);
				break;
			// CLAUDETTE
			case "BGM_STAGE2" :
				lc.send("swf8connector", "play", 19.5, -18.5);
				break;
			case "BGM_STAGE2_FC" :
				lc.send("swf8connector", "play", 19.5, -19.2);
				break;
			// よそよそ
			case "BGM_STAGE3" :
				lc.send("swf8connector", "play", 38.3, -37.1);
				break;
			case "BGM_STAGE3_FC" :
				lc.send("swf8connector", "play", 39.2, -38.4);
				break;
			// ゲームオーバー
			case "BGM_GAMEOVER" :
			case "BGM_GAMEOVER_FC" :
				lc.send("swf8connector", "play", Number.POSITIVE_INFINITY, 0);
				break;
			// 秒速60ドットのランクイン
			case "BGM_RANKING" :
				lc.send("swf8connector", "play", 37.6, -37);
				break;
			case "BGM_RANKING_FC" :
				lc.send("swf8connector", "play", 39, -38.4);
				break;
			// オールクリア
			case "BGM_ALLCLEAR" :
			case "BGM_ALLCLEAR_FC" :
				lc.send("swf8connector", "play", Number.POSITIVE_INFINITY, 0);
				break;
			}
			return;
		}
	}
}
