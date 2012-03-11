package com.merrycat.media
{
	import org.casalib.time.EnterFrame;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Administrator
	 */
	public class TimelineVideoPlayer
	{
		private var _videoTimeline : MovieClip;
		
		/**
		 * 是否自动播放
		 */
		private var _autoReplay : Boolean;
		
		public var onStartCall : Function;
		public var onCompleteCall : Function;
		public var onProgressCall : Function;
		
		public var paused : Boolean;
		private var _parent : Sprite;
		private var VidClass : Class;
		private var _videoWrapper : Sprite;
		
		public function TimelineVideoPlayer(className:String, parent:Sprite)
		{
			VidClass = getDefinitionByName(className) as Class;
			_parent = parent;
			createVid();
//			_videoTimeline = videoTimeline; 
		}

		private function createVid() : void
		{
			_videoWrapper = new Sprite();
			_parent.addChild(_videoWrapper);
			_videoTimeline = new VidClass();
			_videoTimeline.gotoAndStop(1);
//			_videoTimeline.stop();
			_videoWrapper.addChild(_videoTimeline);
		}
		
		public function play(autoReplay:Boolean = true):void 
		{
			this.autoReplay = autoReplay;
			
			_videoTimeline.gotoAndPlay(2);
			EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, onEF);
			onStartCall && onStartCall.apply();
			
//			_mFreeTogo = new MFreeTogo(_videoTimeline);
//			_mFreeTogo.onAniStart = onStartCall;
//			_mFreeTogo.goto(_videoTimeline.totalFrames.toString(), onVideoComplete, onVideoProgess);
		}
		
		private function onEF(e : Event) : void 
		{
			onVideoProgess();
		}

		private function onVideoProgess() : void
		{
			if(_videoTimeline.currentFrame < _videoTimeline.totalFrames)
			{
				onProgressCall && onProgressCall.apply();
			}else
			{
				onVideoComplete();
			}
		}

		private function onVideoComplete() : void
		{
			if(autoReplay)
			{
				_videoTimeline.gotoAndPlay(2);
//				_mFreeTogo.goto(_videoTimeline.totalFrames.toString(), onVideoComplete);
			}else
			{
				EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEF);
				_videoTimeline.stop();
			}
			
			onCompleteCall && onCompleteCall.apply();
		}
		
		public function stop() : void
		{
//			_mFreeTogo.stop();
			EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEF);
			_videoTimeline.gotoAndStop(1);
			
			_parent.removeChild(_videoWrapper);
			onCompleteCall && onCompleteCall.apply();
		}
		
		public function pause() : void
		{
//			_mFreeTogo.pause();	
			EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEF);
			_videoTimeline.stop();
			paused = true;
			
			onCompleteCall && onCompleteCall.apply(null, [true]);
		}
		
		public function resume() : void
		{
			EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, onEF);
			createVid();
			_videoTimeline.play();
//			_mFreeTogo.resume();	
			paused = false;
		}

		public function destory() : void
		{
			onCompleteCall = null;
			onStartCall = null;
			onProgressCall = null;
			stop();
		}

		
		public function set autoReplay(value:Boolean):void
		{
			_autoReplay = value;
		}
		
		public function get autoReplay():Boolean
		{
			return _autoReplay;
		}
		
		public function set videoTimeline(value:MovieClip):void
		{
			_videoTimeline = value;
		}
		
		public function get videoTimeline():MovieClip
		{
			return _videoTimeline;
		}
	}
}
