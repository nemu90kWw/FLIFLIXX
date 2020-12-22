package fliflixx.system 
{
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class VolumeContainer
	{
		public var transform:SoundTransform;
		public var channel:SoundChannel;
		
		private var _masterVolume:Number = 1;
		public function get masterVolume():Number { return _masterVolume; }
		public function set masterVolume(value:Number):void { _masterVolume = value; updateVolume(); }
		
		private var _volume:Number = 1;
		public function get volume():Number { return _volume; }
		public function set volume(value:Number):void { _volume = value; updateVolume(); }
		
		private var _fadeOutVolume:Number = 1;
		public function get fadeOutVolume():Number { return _fadeOutVolume; }
		public function set fadeOutVolume(value:Number):void { _fadeOutVolume = value; updateVolume(); }
		
		private var _deactiveFadeVolume:Number = 1;
		public function get deactiveFadeVolume():Number { return _deactiveFadeVolume; }
		public function set deactiveFadeVolume(value:Number):void { _deactiveFadeVolume = value; updateVolume(); }
		
		public function VolumeContainer() 
		{
			transform = new SoundTransform(1, 0);
			channel = null;
			
			_masterVolume = 1;
			_volume = 1;
			
			_fadeOutVolume = 1;
			_deactiveFadeVolume = 1;
		}
		
		private function updateVolume():void	
		{
			transform.volume = _masterVolume * _volume * _fadeOutVolume * _deactiveFadeVolume;
			if(channel != null) {
				channel.soundTransform = transform;
			}
		}
	}
}