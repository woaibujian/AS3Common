package com.merrycat.media
{
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * @author merrycat
	 * 视频播放器
	 * 
	 * @see PlayerBase
	 */
	public class VideoPlayer extends PlayerBase
	{
		private var _videoWidth:int = 0;
		private var _videoHeight:int = 0;
		
		private var netConnection:NetConnection;
		public var netStream:NetStream;
		
		private var _video : Video;
		
		public var autoFit:Boolean = true;
		
		public var currCuepoint:Object;
		
		/**
		 * 构造函数
		 * 
		 * @param	video		Video对象
		 * @param	autoFit		自动将视频的尺寸设置为播放文件的原标签尺寸
		 */
		public function VideoPlayer( video : Video, autoFit:Boolean = true )
		{
			super();
			
			this.autoFit = autoFit;
			
			_video = video;
//			_video.smoothing = true;
			
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            netConnection.connect(null);
		}
		
		/**
		 * 构造函数
		 * 
		 * @return					视频的实际设置宽度（播放后获得原标签后的实际设置尺寸）
		 */
		public function get videoWidth():int 
		{
			return _video.videoWidth;
		}
		
		/**
		 * 构造函数
		 * 
		 * @return					视频的实际设置高度（播放后获得原标签后的实际设置尺寸）
		 */
		public function get videoHeight():int 
		{
			return _video.videoHeight;
		}
		
		override public function set bufferTime(num:Number):void 
		{
            super.bufferTime = num;
			netStream.bufferTime = bufferTime;
        }

		override public function set volume(num:Number):void
		{
			super.volume = volume;
			var st:SoundTransform = new SoundTransform(num);
			netStream.soundTransform = st;
		}
		
		private function netStatusHandler(event:NetStatusEvent):void 
		{
			switch (event.info.code) {
                case "NetStream.Play.Start":
					setStatus( MediaStatusType.PLAY_START );
                    break;
				case "NetStream.Play.Stop":
					if(autoReplay)
					{
						replay();
					}else
					{
						if( progressIntervalID && !progressIntervalID.destroyed ) progressIntervalID.destroy();
					}
					
					setStatus( MediaStatusType.PLAY_COMP );
				
                    break;
                case "NetStream.Play.StreamNotFound":
//					setStatus(VideoPlayer.PLAY_STREAM_NOT_FOUND);
                    break;
				case "NetStream.Seek.Notify":
//					setStatus(VideoPlayer.SEEK_NOTIFY);
                    break;
				case "NetStream.Buffer.Full":
					setStatus( MediaStatusType.BUFFER_FULL );
					
                    break;
				case "NetStream.Buffer.Empty":
					setStatus( MediaStatusType.BUFFER_EMPTY );
                    break;
            }
        }
		
		private function onMetaData(info:Object):void 
		{
			duration = info.duration;
			
			_videoWidth = _video.width;
			_videoHeight = _video.height;
			
			if( autoFit )
			{
				_video.width = info.width;
				_video.height = info.height;
			}
			
//			trace("file = " + url + ", metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			
			this.dispatchEvent( new PlayerEvent( PlayerEvent.UPDATE_STATUS, MediaStatusType.METADATA ) );
			
    	}
		
    	private function onCuePoint(info:Object):void 
    	{
//        	trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
			currCuepoint = info;
//			trace(info.parameters.wd)
			this.dispatchEvent( new PlayerEvent( PlayerEvent.UPDATE_STATUS, MediaStatusType.CUEPOINT ) );
    	}
		
		private function setStatus(str:String):void 
		{
			switch( str ) 
			{
				case MediaStatusType.PLAY_START:
					startProgressInterval();
					break;
				case MediaStatusType.PLAY_STOP:
					stopProgressInterval();
					break;
			}
			
			this.dispatchEvent( new PlayerEvent ( PlayerEvent.UPDATE_STATUS, str ) );
        }
		
		override public function play(url:String, autoReplay:Boolean = true, bufferTime:int = 5):void 
		{
			_video.visible = true;

			this.url = url;
			
			this.autoReplay = autoReplay;
			
			netStream = new NetStream(netConnection);
            netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			netStream.client = {"onMetaData":onMetaData, "onCuePoint":onCuePoint};
			netStream.bufferTime = bufferTime;
			this.bufferTime = bufferTime;
			
            _video.attachNetStream(netStream); 
            
			netStream.play( url );
		}
		
		private function replay():void
		{
			netStream.play( url );
		}
		
		override public function pause():void
		{
			setStatus( MediaStatusType.PLAY_PAUSE );
			paused = true;
			netStream.pause();
		}
		
		override public function resume():void
		{
			if(paused)
			{
				setStatus(MediaStatusType.PLAY_RESUME);
				paused = false;
				netStream.resume();
			}
		}
		
		public function togglePause():void
		{
			netStream.togglePause();
		}
		
		override public function stop():void 
		{
			netStream.close();
			_video.clear();
			_video.visible = false;
			
			setStatus( MediaStatusType.PLAY_STOP );
		}
		
		override public function seek(num:Number):void
		{
			netStream.seek(num);
			progressInterval();
		}

		override protected function progressInterval():void 
		{
			bytesLoaded = netStream.bytesLoaded;
			bytesTotal = netStream.bytesTotal;
			time = netStream.time;
			downPct = netStream.bytesTotal == 0 ? 0 : netStream.bytesLoaded / netStream.bytesTotal;
			playPct = duration == 0 ? 0 : netStream.time / duration;
			
			if( captions )
			{
				var havCaption:Boolean = false;
				for( var i : int = 0; i < captions.length ; i++ )
				{
					var cvo:CaptionVO = captions[ i ] as CaptionVO;
					if( cvo.startSec < time && cvo.endSec > time )
					{
						caption = cvo.caption;
						havCaption = true;
					}
				}
				
				if( !havCaption ) caption = "";
			}
			
			this.dispatchEvent( new PlayerEvent( PlayerEvent.UPDATE_STATUS, MediaStatusType.PROGRESS ) );
		}
		
		override public function destory():void 
		{
			netStream.close();
			if( progressIntervalID && !progressIntervalID.destroyed ) progressIntervalID.destroy();
		}
	}
}