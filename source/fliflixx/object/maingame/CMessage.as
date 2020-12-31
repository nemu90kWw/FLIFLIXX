package fliflixx.object.maingame
{
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import fliflixx.asset.ExplosionAsset;
	import fliflixx.asset.GameOverMessageAsset;
	import fliflixx.asset.MissMessageAsset;
	import fliflixx.asset.SmokeAsset;
	import fliflixx.asset.StageClearBestRecordMessageAsset;
	import fliflixx.asset.StageClearNoMissMessageAsset;
	import fliflixx.asset.StageCoearMessageAsset;
	import fliflixx.object.maingame.CGameObject;
	import common.Surface;
	import flash.geom.Rectangle;
	import fliflixx.object.maingame.CBlock;
	
	public class CMessage extends CGameObject
	{
		public static const CLEAR:String = "clear";
		public static const NOMISSCLEAR:String = "nomissclear";
		public static const BESTRECORD:String = "bestrecord";
		public static const MISS:String = "miss";
		public static const GAMEOVER:String = "gameover";
		
		private var asset:MovieClip;
		private var type:String;
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function CMessage(type:String)
		{
			this.type = type;
		}
		
		override public function initialize():void
		{
			registerObject("DEPTH_MESSAGE", "PRIO_EFFECT");
			
			switch(type)
			{
			case CLEAR:
				asset = new StageCoearMessageAsset();
				changeAction("act_clear");
				break;
			case NOMISSCLEAR:
				asset = new StageClearNoMissMessageAsset();
				changeAction("act_clear");
				break;
			case BESTRECORD:
				asset = new StageClearBestRecordMessageAsset();
				changeAction("act_clear");
				break;
			case MISS:
				asset = new MissMessageAsset();
				changeAction("act_miss");
				break;
			case GAMEOVER:
				asset = new GameOverMessageAsset();
				changeAction("act_gameover");
				break;
			}
			asset.stop();
			
			asset.x = 320;
			asset.y = 216;
			return;
		}

		// --------------------------------//
		// メイン
		// --------------------------------//
		public function act_clear():void
		{
			if(count == 3) {
				asset.gotoAndStop(2);
			}
			
			asset.y = 216 - Math.sin(Math.max(count - 3, 0) / 11.25) * 6.4;
			return;
		}
		
		public function act_miss():void
		{
			if(count == 3) {
				asset.gotoAndStop(2);
			}
			
			switch(count)
			{
			case 3: asset.y = 206; break;
			case 5: asset.y = 226; break;
			case 7: asset.y = 212; break;
			case 10: asset.y = 220; break;
			case 15: asset.y = 215; break;
			case 20: asset.y = 217; break;
			case 25: asset.y = 216; break;
			}
			return;
		}
		
		public function act_gameover():void
		{
			return;
		}
		
		// --------------------------------//
		// 描画
		// --------------------------------//
		override public function draw(screen:Surface):void
		{
			screen.buffer.draw(asset, asset.transform.matrix);
			return;
		}
	}
}