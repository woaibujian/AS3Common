package com.merrycat.media 
{
	import com.greensock.TweenLite;
	import com.merrycat.load.CircleLoadUI;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.media.Video;
	import org.casalib.util.StageReference;

	/**
	 * @author:		Merrycat
	 * @createDate:	2010-11-12	下午02:18:48
	 */
	public class BufferVideo 
	{
		public var vp : VideoPlayer;

		public var vid : Video;

		public var smoothing : Boolean = false;

		public var url : String;
		
		public var autoRemove : Boolean;

		private var _bufferUI : CircleLoadUI;

		public var onCompleteCall : Function;
		public var onCompleteCallParams : Array;
		
		public var onStartCall : Function;
		public var onStartCallParams : Array;
		
		public var onBufferFullCall : Function;
		public var onBufferFullCallParams : Array;
		
		public var onDestoryCall : Function;
		public var onDestoryCallParams : Array;
		
		public var loadingParent:DisplayObjectContainer;
		
		public var onProgressCall : Function;
		private var replay : Boolean;
		
		public var circleColor : uint = 0xFFFFFF;
		public var circleScale : Number = 1;
		private var _circleVisible : Boolean = true;

		public function BufferVideo(url : String, vid : Video, autoRemove:Boolean = true, smoothing:Boolean = true, replay:Boolean = false) 
		{
			this.url = url;
			this.vid = vid;
			this.autoRemove = autoRemove;
			this.smoothing = smoothing;
			this.replay = replay;
		}

		public function play(bufferTime:int = 5) : void 
		{
			if(!loadingParent)
			{
				loadingParent = StageReference.getStage();	
			}
			
			vp = new VideoPlayer(vid, false);
			vid.smoothing = smoothing;
			vid.addEventListener(Event.REMOVED_FROM_STAGE, destory);
			vp.play(url, replay, bufferTime);
			vp.addEventListener(PlayerEvent.UPDATE_STATUS, videoUpdateStatus);
		}
		
		public function set circleVisible(value:Boolean):void
		{
			_circleVisible = value;	
			if(_bufferUI)
				_bufferUI.dispUI.visible = _circleVisible;
		}

		public function destory(e:Event = null) : void 
		{
			vid.removeEventListener(Event.REMOVED_FROM_STAGE, destory);
			
			vp && vp.removeEventListener(PlayerEvent.UPDATE_STATUS, videoUpdateStatus);
			vp && vp.destory();
			
			onDestoryCall && onDestoryCall.apply(null, onDestoryCallParams);
			
			if(_bufferUI) 
			{
				 _bufferUI.remove();
				 _bufferUI = null;
			}
			
			if(!e && vid.parent)
			{
				vid.parent.removeChild(vid);
			}
		}
		
		private function videoUpdateStatus(e : PlayerEvent) : void 
		{
			switch(e.status)
			{
				case MediaStatusType.PLAY_RESUME:
					break;
				case MediaStatusType.PLAY_START:
				
					if(!_bufferUI)
					{
						_bufferUI = new CircleLoadUI(loadingParent, circleColor, true, circleScale);
						_bufferUI.dispUI.alpha = 0;
						circleVisible = _circleVisible;
						TweenLite.to(_bufferUI.dispUI, 0.5, {alpha:1});
						
						onStartCall && onStartCall.apply(null, onStartCallParams);
					}
					
					break;
					
				case MediaStatusType.PLAY_COMP:
				
					onCompleteCall && onCompleteCall.apply(null, onCompleteCallParams);
					
					if(!replay)
					{
						_bufferUI && TweenLite.to(_bufferUI.dispUI, 0.5, {alpha:0});
						
						if(_bufferUI) 
						{
							 _bufferUI.remove();
							 _bufferUI = null;
						}
						
						if(autoRemove)
						{
							destory();
						}
					}else
					{
						_bufferUI && TweenLite.to(_bufferUI.dispUI, 0.5, {alpha:0});
					}
					
					break;
					
				case MediaStatusType.BUFFER_EMPTY:
					_bufferUI && TweenLite.to(_bufferUI.dispUI, 0.5, {alpha:1});
					break;
					
				case MediaStatusType.BUFFER_FULL:
				
					_bufferUI && TweenLite.to(_bufferUI.dispUI, 0.5, {alpha:0});
					
					onBufferFullCall && onBufferFullCall.apply(null, onBufferFullCallParams);
					break;
					
				case MediaStatusType.PROGRESS:
				
					onProgressCall && onProgressCall();

					break;
			}
		}
	}
}
