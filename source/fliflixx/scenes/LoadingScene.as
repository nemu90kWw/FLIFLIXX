package fliflixx.scenes
{
	import common.MultiLoader;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import fliflixx.object.common.*;
	import fliflixx.object.maingame.*;
	import fliflixx.system.Database;
	import fliflixx.system.Music;
	
	public class LoadingScene extends SceneBase
	{
		private var loader:MultiLoader = new MultiLoader();
		private var itemlist:Array = new Array();
		
		public function LoadingScene():void
		{
			//読み込みテーブル
			itemlist.push({type:"BITMAP", name:"BMP_16PXTEXT", url:"graphic/text_16x16.png"});
			itemlist.push({type:"BITMAP", name:"BMP_TITLELOGO", url:"graphic/titlelogo.png"});
			itemlist.push({type:"BITMAP", name:"BMP_MINILOGO", url:"graphic/minilogo.png"});
			itemlist.push({type:"BGM", name:"BGM_STAGE1", url:"bgm/ELMB_Stage1.mp3"});
			itemlist.push({type:"BGM", name:"BGM_STAGE2", url:"bgm/ELMB_Stage2.mp3"});
			itemlist.push({type:"BGM", name:"BGM_STAGE3", url:"bgm/ELMB_Stage3.mp3"});
			itemlist.push({type:"BGM", name:"BGM_ALLCLEAR", url:"bgm/ELMB_Clear.mp3"});
			itemlist.push({type:"BGM", name:"BGM_RANKING", url:"bgm/ELMB_Ranking.mp3"});
			itemlist.push({type:"BGM", name:"BGM_GAMEOVER", url:"bgm/ELMB_GameOver.mp3"});
			itemlist.push({type:"BGM", name:"BGM_STAGE1_FC", url:"bgm/NES_Stage1.mp3"});
			itemlist.push({type:"BGM", name:"BGM_STAGE2_FC", url:"bgm/NES_Stage2.mp3"});
			itemlist.push({type:"BGM", name:"BGM_STAGE3_FC", url:"bgm/NES_Stage3.mp3"});
			itemlist.push({type:"BGM", name:"BGM_ALLCLEAR_FC", url:"bgm/NES_Clear.mp3"});
			itemlist.push({type:"BGM", name:"BGM_RANKING_FC", url:"bgm/NES_Ranking.mp3"});
			itemlist.push({type:"BGM", name:"BGM_GAMEOVER_FC", url:"bgm/NES_GameOver.mp3"});
			itemlist.push({type:"SOUND", name:"SE_EXPLOSION", url:"se/sqbomb.mp3"});
			itemlist.push({type:"SOUND", name:"SE_HIT", url:"se/fx4.mp3"});
			itemlist.push({type:"SOUND", name:"SE_SMOKE", url:"se/sqsmoke.mp3"});
			itemlist.push({type:"XML", name:"XML_STAGEDATA", url:"stagedata.xml"});
			
			for each(var item:Object in itemlist) {
				loader.load(item.type, item.name, item.url);
			}
			
			changeAction("act_loading");
			return;
		}
		
		// --------------------------------//
		// 各種データ読み込み
		// --------------------------------//
		private var item:Object = null;
		
		public function act_loading():void
		{
			if(loader.isError()) {
				throw("file not found: "+loader.getErrorFiles());
			}
				
			if(loader.isComplete())
			{
				for each(var item:* in itemlist)
				{
					switch(item.type)
					{
					default: Database.addItem(item.name, loader.getContent(item.name)); break;
					case "SOUND": func_se.addSound(item.name, loader.getContent(item.name)); break;
					}
				}
				
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
				
				changeAction("act_gotomaingame");
			}
		}
		
		// --------------------------------//
		// シーン変更
		// --------------------------------//
		public function act_gotomaingame():void
		{
			changeScene(new InitializeScene());
		}
	}
}