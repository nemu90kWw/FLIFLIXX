
package fliflixx.scenes
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import fliflixx.object.common.*;
	import fliflixx.object.maingame.*;
	import fliflixx.system.Database;
	import fliflixx.system.Music;
	import fliflixx.system.PlayData;
	
	public class InitializeScene extends SceneBase
	{
		private var menu:CMenu;
		
		public function InitializeScene()
		{
			//func_bgm.setMasterVolume(0);
			//func_se.setMasterVolume(0);
			
			//テーブル作成
			var table_16px:String = ""
			+ " ABCDEFGHIJKLMNOPQRSTUVWXYZabcde"
			+ "fghijklmnopqrstuvwxyz0123456789_"
			+ "-=+\\|[{]};:'\",<.>/?!@#$%^&*()~←㍗";
			
			//通常テキスト
			func_text.addFont("16px", Database.getItem("BMP_16PXTEXT"),   table_16px, 16, 16);
			
			//横幅半分テキスト
			var tempbmp:BitmapData = new BitmapData(256, 48, true, 0);
			var matrix:Matrix = new Matrix();
			matrix.scale(0.5, 1);
			tempbmp.draw(Database.getItem("BMP_16PXTEXT"), matrix);
			func_text.addFont("8px", tempbmp, table_16px, 8, 16);
			
			//黄色テキスト
			var ybmp:BitmapData = Database.getItem("BMP_16PXTEXT").clone();
			ybmp.colorTransform(ybmp.rect, new ColorTransform(1, 1, 1, 1, -8-128, -56, -192-56, 0));
			ybmp.colorTransform(ybmp.rect, new ColorTransform(1, 1, 1, 1, 128, 56, 56, 0));
			func_text.addFont("16px_y", ybmp, table_16px, 16, 16);
			
			//changeAction("act_launchAS3");
			changeAction("act_choose");
			return;
		}
		
		// --------------------------------//
		// プレイするバージョンの選択
		// --------------------------------//
		public function act_choose():void
		{
			if(count == 0)
			{
				//メニュー作成
				menu = createObject(new CMenu());
				menu.addItem("16px", "PLAY NEW VERSION", 320, 150);
				menu.addItem("16px", "PLAY OLD VERSION", 320, 250);
				
				cursor._visible = true;
			}
			
			//決定
			if(menu.isDecided() == true)
			{
				switch(menu.getSelectedItem().label) {
				case "PLAY NEW VERSION": changeAction_fadeout("act_launchAS3"); break;
				case "PLAY OLD VERSION": changeAction_fadeout("act_launchAS1"); break;
				}
			}
		}
		
		public function act_launchAS1():void
		{
			if(count == 0)
			{
				cursor.parent.removeChild(cursor);
				fliflixx.launchAS1();
			}
		}
		
		override public function draw():void 
		{
			screen.clear(0x008000);
			super.draw();
		}
		
		// --------------------------------//
		// 読み込み
		// --------------------------------//
		public function act_launchAS3():void
		{
			//ループポイントの設定
			Music.registerSound(Database.getItem("BGM_STAGE1"), "BGM_STAGE1", 91.5, -90.1);
			Music.registerSound(Database.getItem("BGM_STAGE1_FC"), "BGM_STAGE1_FC", 94.2, -93.3);
			Music.registerSound(Database.getItem("BGM_STAGE2"), "BGM_STAGE2", 19.5, -18.5);
			Music.registerSound(Database.getItem("BGM_STAGE2_FC"), "BGM_STAGE2_FC", 19.5, -19.2);
			Music.registerSound(Database.getItem("BGM_STAGE3"), "BGM_STAGE3", 38.3, -37.1);
			Music.registerSound(Database.getItem("BGM_STAGE3_FC"), "BGM_STAGE3_FC", 39.2, -38.4);
			Music.registerSound(Database.getItem("BGM_GAMEOVER"), "BGM_GAMEOVER", Infinity, 0);
			Music.registerSound(Database.getItem("BGM_GAMEOVER_FC"), "BGM_GAMEOVER_FC", Infinity, 0);
			Music.registerSound(Database.getItem("BGM_RANKING"), "BGM_RANKING", 37.6, -37);
			Music.registerSound(Database.getItem("BGM_RANKING_FC"), "BGM_RANKING_FC", 39.2, -38.4);
			Music.registerSound(Database.getItem("BGM_ALLCLEAR"), "BGM_ALLCLEAR", 39, -38.4);
			Music.registerSound(Database.getItem("BGM_ALLCLEAR_FC"), "BGM_ALLCLEAR_FC", Infinity, 0);
			
			// オブジェクトのBMP作成
			var objlist:Array = [
				CEbifly,
				CMogler,
				CFrame,
				RankingScene,
				AllClearScene
			];
			
			for each(var cls:* in objlist) {
				cls.standbyGraphics();
			}
			
			var ranking:* = PlayData.ranking;
			if(ranking.isEmpty() == true)
			{
				ranking.initialize();
				ranking.saveData();
			}
			else {
				ranking.loadData();
			}
			
			if(ranking.isError() == true)
			{
				ranking.initialize();
				ranking.saveData();
			}
			
			var records:* = PlayData.records;
			if(records.isEmpty() == true)
			{
				records.initialize();
				records.saveData();
			}
			else {
				records.loadData();
			}
			
			if(records.isError() == true)
			{
				records.initialize();
				records.saveData();
			}
			
			var option:* = PlayData.option;
			if(option.isEmpty() == true)
			{
				option.initialize();
				option.saveData();
			}
			else {
				option.loadData();
			}
			
			if(option.isError() == true)
			{
				option.initialize();
				option.saveData();
			}
			
			changeScene(new TitleScene());
		}
	}
}
