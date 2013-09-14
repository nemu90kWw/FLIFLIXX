
package common
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SoundEffect
	{
		private var selist:Object = new Object;
		
		private var mastervolume:Number = 100;
		private var volume:Number = 100;
		
		private var transform:SoundTransform = new SoundTransform();
		
		// --------------------------------//
		// 登録
		// --------------------------------//
		public function addSound(name:String, sndobj:Sound):void
		{
			selist[name] = new Object();
			selist[name].sndobj = sndobj;
			selist[name].playflag = false;
			
			for each(var se:Object in selist)
			{
				se.sndch = new SoundChannel();
			}
			return;
		}
		
		// --------------------------------//
		// 再生
		// --------------------------------//
		public function play(name:String):void
		{
			if(selist[name] == undefined) {return;}
			
			selist[name].playflag = true;
			return;
		}
		
		public function stop():void
		{
			for each(var se:Object in selist)
			{
				se.sndch.stop();
			}
			return;
		}
		
		// --------------------------------//
		// メインループ
		// --------------------------------//
		public function main():void
		{
			for each(var se:Object in selist)
			{
				if(se.playflag == true)
				{
					//se.sndch.stop();
					se.sndch = se.sndobj.play(0, 0, transform);
					se.playflag = false;
				}
				
				//ボリューム計算
				transform.volume = (mastervolume / (100 / volume))/100;
			}
			
			return;
		}
		
		// --------------------------------//
		// ボリュームの設定
		// --------------------------------//
		public function setVolume(num:Number):void
		{
			volume = num;
		}
		
		public function setMasterVolume(num:Number):void
		{
			mastervolume = num;
		}
	}
}
