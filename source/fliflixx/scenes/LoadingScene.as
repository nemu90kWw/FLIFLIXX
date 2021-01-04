package fliflixx.scenes
{
	import common.MultiLoader;
	import fliflixx.system.Database;
	
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