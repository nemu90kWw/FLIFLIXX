
package fliflixx.scenes
{
	import fliflixx.system.PlayData;
	
	public class InitializeScene extends SceneBase
	{
		public function InitializeScene()
		{
			//func_bgm.setMasterVolume(0);
			//func_se.setMasterVolume(0);
			
			changeAction("act_load");
			return;
		}
		
		// --------------------------------//
		// 記録読み込み
		// --------------------------------//
		public function act_load():void
		{
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
			
			cursor._visible = true;
			changeScene(new TitleScene());
		}
	}
}
