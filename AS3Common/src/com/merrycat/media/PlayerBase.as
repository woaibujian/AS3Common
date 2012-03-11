package com.merrycat.media
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	import org.casalib.time.Interval;
	
	/**
	 * @author merrycat
	 * 播放器基类，由视频、音频播放器继承
	 */
	internal class PlayerBase extends EventDispatcher
	{
		/**
		 * 播放文件地址
		 */
		private var _url:String;
		
		/**
		 * 播放文件时长 单位秒
		 */
		private var _duration:Number = 0;
		
		/**
		 * 当前播放头位置 单位秒
		 */
		private var _time:Number = 0;
		
		/**
		 * 已加载的字节数
		 */
		private var _bytesLoaded:int = 0;
		
		/**
		 * 文件总共的字节数
		 */
		private var _bytesTotal:int = 0;
		
		/**
		 * 下载比例百分比
		 */
		private var _downPct:Number = 0;
		
		/**
		 * 播放比例百分比
		 */
		private var _playPct:Number = 0;
		
		/**
		 * 缓冲秒数
		 */
		private var _bufferTime:Number;
		
		/**
		 * 声音大小
		 */
		private var _volume:Number = 1;
		
		/**
		 * 当前字幕
		 */
		public var caption:String;
		
		/**
		 * 所有字幕，CaptionVO
		 */
		public var captions:Array;
		
		protected var progressIntervalID : Interval;
		
		/**
		 * 是否自动播放
		 */
		private var _autoReplay : Boolean;
		
		/**
		 * 是否在暂停状态
		 */
		private var _paused : Boolean;
		
		public function get url():String 
		{
            return _url;
        }
        
		public function set url( s : String ):void 
		{
            _url = s;
        }
		
		public function get duration():Number 
		{
            return _duration;
        }
        
		public function set duration( n : Number ):void 
		{
            _duration = n;
        }
		
		public function get time():Number 
		{
            return _time;
        }
        
        public function set time( n : Number ):void 
		{
            _time = n;
        }
		
		public function get bytesLoaded():Number 
		{
            return _bytesLoaded;
        }
        
		public function set bytesLoaded( n : Number ):void 
		{
            _bytesLoaded = n;
        }
		
		public function get bytesTotal():Number 
		{
            return _bytesTotal;
        }
        
		public function set bytesTotal( n : Number ):void 
		{
            _bytesTotal = n;
        }
        
		public function get downPct():Number 
		{
            return _downPct;
        }
        
		public function set downPct( n : Number ):void 
		{
            _downPct = n;
        }
        
		public function get playPct():Number 
		{
            return _playPct;
        }
        
		public function set playPct( n : Number ):void 
		{
            _playPct = n;
        }
        
        public function get bufferTime():Number 
		{
            return _bufferTime;
        }
		
		public function set bufferTime(num:Number):void 
		{
            _bufferTime = num;
        }

		public function get volume():Number
		{
			return _volume;
		}
		
		public function set volume(num:Number):void
		{
			_volume = num;
		}
		
		public function get autoReplay():Boolean
		{
			return _autoReplay;
		}
		
		public function set autoReplay(b:Boolean):void
		{
			_autoReplay = b;
		}
		
		public function get paused():Boolean
		{
			return _paused;
		}
		
		public function set paused(b:Boolean):void
		{
			_paused = b;
		}
		
		protected function startProgressInterval():void 
		{
			stopProgressInterval();
			progressIntervalID = Interval.setInterval( progressInterval, 20 );
			progressIntervalID.start();
		}
		
		protected function stopProgressInterval():void 
		{
			if( progressIntervalID )
			{
				progressIntervalID.destroy();
				progressInterval();
			}
		}
		
		protected function progressInterval():void
		{
			throw new IllegalOperationError( "Abstract method: must be overridden in a subclass" );
		}
		
		/**
		 * 更改音乐
		 * 
		 * @param	url				路径
		 * @param	autoReplay		自动开始
		 */
		public function play( url : String, autoReplay:Boolean = true, bufferTime:int = 5 ):void
		{
			throw new IllegalOperationError( "Abstract method: must be overridden in a subclass" );
		}
		
		/**
		 * 暂停
		 */
		public function pause():void
		{
			throw new IllegalOperationError( "Abstract method: must be overridden in a subclass" );
		}
		
		/**
		 * 继续
		 */
		public function resume():void
		{
			throw new IllegalOperationError( "Abstract method: must be overridden in a subclass" );
		}
		
		/**
		 * 停止
		 */
		public function stop():void
		{
			throw new IllegalOperationError( "Abstract method: must be overridden in a subclass" );
		}
		
		/**
		 * 跳至
		 * 
		 * @param	n				播放头位置 单位秒
		 */
		public function seek( n : Number ):void
		{
			throw new IllegalOperationError( "Abstract method: must be overridden in a subclass" );
		}
		
		public function destory():void
		{
			throw new IllegalOperationError( "Abstract method: must be overridden in a subclass" );
		}
	}
}