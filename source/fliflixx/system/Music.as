package fliflixx.system 
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	public class Music
	{
		private static const BUFFER_SIZE:int = 8192;
		private static const SAMPLING_RATE:int = 44100;
		
		private static var stream:Sound = null;
		private static var sound:Sound = null;
		private static var position:Number;
		private static var active:Boolean = true;
		
		private static var marker:Number = 0;
		private static var span:Number = 0;
		private static var buffer:ByteArray = null;
		
		private static var currentMusic:String = null;
		private static var volumes:VolumeContainer = new VolumeContainer();

		public static function get masterVolume():Number { return volumes.masterVolume; }
		public static function set masterVolume(value:Number):void {volumes.masterVolume = value; }
		public static function get volume():Number { return volumes.volume; }
		public static function set volume(value:Number):void {volumes.volume = value; }
		
		private static var isFadeOut:Boolean = false;
		
		private static var list:Object = {};
		
		public static function registerSound(sound:Sound, name:String, marker:Number, span:Number):void
		{
			list[name] = {
				sound : sound,
				marker : marker,
				span : span
			}
		}
		
		public static function play(name:String, offset:Number = 0):void
		{
			if(list.hasOwnProperty(name) == false) {
				throw new ArgumentError(name + "は登録されていない音楽名です");
			}
			
			// 同じ曲は無視する。再生し直す場合は明示的にストップすること
			if(currentMusic == name) { return; }
			
			if(stream != null) {
				stop();
			}
			
			// 曲データの設定
			currentMusic = name;
			sound = list[name].sound;
			marker = list[name].marker;
			span = list[name].span;
			
			// 再生位置をサンプル数に変換
			position = Math.round(offset * SAMPLING_RATE);
			marker = Math.round(marker * SAMPLING_RATE);
			span = Math.round(span * SAMPLING_RATE);
			
			// ボリュームの初期化
			volumes.fadeOutVolume = 1;
			isFadeOut = false;
			
			// 再生開始
			attachStream();
		}
		
		public static function main():void
		{
			if(isFadeOut == true)
			{
				volumes.fadeOutVolume /= 1.02;
			}
		}
		
		
		public static function stop():void
		{
			detachStream();
			currentMusic = null;
		}
		
		public static function fadeout():void
		{
			if(stream == null) {return;}
			
			isFadeOut = true;
			
			// 同じ曲を再生しなおせるようにする
			currentMusic = null;
		}
		
		private static function attachStream():void
		{
			stream = new Sound();
			
			if(active == true)
			{
				stream.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				volumes.channel = stream.play(0, 0, volumes.transform);
			}
		}
		
		private static function detachStream():void
		{
			if(stream == null) {return;}
			
			buffer = null;
			stream.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			
			volumes.channel.stop();
			stream = null;
		}
		
		private static function onSampleData(e:SampleDataEvent):void
		{
			if(buffer != null)
			{
				// 予め重複部分のデコーダを走らせる
				var temp:ByteArray = new ByteArray();
				sound.extract(temp, BUFFER_SIZE, position);
				
				// クリックノイズの除去
				crossFade(buffer, temp, 64);
				temp.clear();
				
				e.data.writeBytes(buffer);
				buffer.clear();
				buffer = null;
			}
			else {
				sound.extract(e.data, BUFFER_SIZE, position);
			}
			position += BUFFER_SIZE;
			
			// ループ
			if(position >= marker)
			{
				// 移動先のデコード結果に欠損が生じやすいため事前に同一部分のバッファを取得
				buffer = new ByteArray();
				sound.extract(buffer, BUFFER_SIZE, position);
				
				position += span;
			}
		}
		
		private static function crossFade(target:ByteArray, source:ByteArray, length:int):void
		{
			var l1:Number, l2:Number, r1:Number, r2:Number;
			var ratio:Number;
			
			source.position = source.length - length * 8;
			target.position = source.position;
			
			for (var i:int = 0; i < length; i++) 
			{
				ratio = i / length;
				
				l1 = target.readFloat();
				r1 = target.readFloat();
				l2 = source.readFloat();
				r2 = source.readFloat();
				
				target.position -= 8;
				target.writeFloat(l1 * (1 - ratio) + l2 * ratio);
				target.writeFloat(r1 * (1 - ratio) + r2 * ratio);
			}
		}
	}
}