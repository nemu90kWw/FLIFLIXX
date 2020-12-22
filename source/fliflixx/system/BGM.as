
package fliflixx.system
{
	import fliflixx.system.PlayData;
	
	public class BGM
	{
		public function stop():void {
			Music.stop();
		}
		
		// --------------------------------//
		// 曲の再生
		// --------------------------------//
		public function play(name:String):void
		{
			if(PlayData.option.data.bgmtype == "FAMICOM") {
				name += "_FC";
			}
			
			Music.play(name);
		}
	}
}
