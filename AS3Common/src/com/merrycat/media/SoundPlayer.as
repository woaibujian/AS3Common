package com.merrycat.media
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * @author merrycat
	 * 音频播放器
	 * 
	 * @see PlayerBase
	 */
	public class SoundPlayer extends PlayerBase
	{
		private var sound:Sound;
		private static var soundChannel:SoundChannel = new SoundChannel();
		private var soundPosition:int = 0;

		public function SoundPlayer()
		{
			sound = new Sound();
		}
		
		private function soundStatusHandler(e:Event):void 
		{
			switch (e.type) {
				case Event.SOUND_COMPLETE:
					
					if(autoReplay)
					{
						replay();
					}
					
					setStatus( MediaStatusType.PLAY_COMP );
					break;
				case Event.ID3:
//					trace("file = " + url + ", metadata: songName=" + sound.id3.songName  + " artist=" + sound.id3.artist );
					
					duration = Math.round( sound.length / 1000 ); 
					
					dispatchEvent( new PlayerEvent( PlayerEvent.UPDATE_STATUS, MediaStatusType.ID3 ));
					
					setStatus( MediaStatusType.PLAY_START );
					
					break;
				case IOErrorEvent.IO_ERROR:
//					setStatus(SoundPlayer.PLAY_STREAM_NOT_FOUND);
					break;
            }
        }
		
		private function setStatus( status:String ):void 
		{
			switch( status ) 
			{
				case MediaStatusType.PLAY_START:
					startProgressInterval();
					break;
				case MediaStatusType.PLAY_STOP:
					stopProgressInterval();
					break;
			}
			
			this.dispatchEvent( new PlayerEvent( PlayerEvent.UPDATE_STATUS, status ) );
        }
		
		override public function play(url:String, autoReplay:Boolean = true, bufferTime:int = 5):void
		{
			this.url = url;
			
			this.autoReplay = autoReplay;
			
			bufferTime = 5;
			
//			paused = false;
			
			soundChannel && soundChannel.stop();
			
			sound = new Sound(new URLRequest(url), new SoundLoaderContext( bufferTime ) );
			sound.addEventListener( Event.ID3, soundStatusHandler );
			sound.addEventListener( IOErrorEvent.IO_ERROR, soundStatusHandler );
			
			soundChannel = sound.play();
			soundChannel.addEventListener( Event.SOUND_COMPLETE, soundStatusHandler );
			setStatus( MediaStatusType.PLAY_START );
		}
		
		private function replay():void
		{
			soundChannel = sound.play();
			soundChannel.addEventListener( Event.SOUND_COMPLETE, soundStatusHandler );
			volume = volume;
			
			setStatus( MediaStatusType.PLAY_START );
		}
		
		override public function pause():void
		{
			soundPosition = soundChannel.position;
			soundChannel.stop();
			
			paused = true;
			
			setStatus( MediaStatusType.PLAY_PAUSE );
		}
		
		override public function resume():void
		{
			if(paused)
			{
				soundChannel = sound.play(soundPosition);
				soundChannel.addEventListener( Event.SOUND_COMPLETE, soundStatusHandler );
				
				paused = false;
				
				volume = volume;
				
				setStatus( MediaStatusType.PLAY_RESUME );
			}
		}
		
		override public function stop():void 
		{
			if(sound.bytesLoaded != sound.bytesTotal)
			{
				sound.close();
			}
			soundChannel.stop();
			soundChannel = new SoundChannel();
			soundPosition = 0;
			
			setStatus( MediaStatusType.PLAY_STOP );
		}
		
		override public function seek(num:Number):void
		{
			soundChannel.stop();
			soundChannel = sound.play(num * 1000);
			progressInterval();
		}
		
		override protected function progressInterval():void 
		{
			bytesLoaded = sound.bytesLoaded;
			bytesTotal = sound.bytesTotal;
			time = soundChannel.position/1000;
			downPct = sound.bytesTotal == 0 ? 0 : sound.bytesLoaded / sound.bytesTotal;
			duration = (sound.length / downPct)/1000;
			playPct = duration == 0 ? 0 : time / duration;
			
			this.dispatchEvent( new PlayerEvent( PlayerEvent.UPDATE_STATUS, MediaStatusType.PROGRESS ) ); 
		}
		
		override public function set volume(num:Number):void
		{
			super.volume = num;
			
			var transform:SoundTransform = soundChannel.soundTransform;
			transform.volume = num;
			soundChannel.soundTransform = transform;
		}
		
		override public function destory():void 
		{
			soundChannel && soundChannel.stop();
			if( progressIntervalID && !progressIntervalID.destroyed ) progressIntervalID.destroy();
		}
	}
}