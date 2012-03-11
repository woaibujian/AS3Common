package com.merrycat.utils 
{
	import com.merrycat.ViewBase;

	import flash.events.Event;

	import org.casalib.time.EnterFrame;

	import flash.display.MovieClip;

	/**
	 * @author:		Merrycat
	 * @version:	2010-11-26	下午06:40:44
	 * MoveClip功能附加类
	 */
	public class MMovieClip extends ViewBase
	{
		private var _onEndCall : Function;
		
		public function MMovieClip(asset : MovieClip) 
		{
			super(asset);
		}
		
		/**
		 * 影片剪辑播放到最后一帧时调用函数
		 * @param value 			函数
		 */
		public function set onClipEndCall(value:Function):void
		{
			_onEndCall = value;
			EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, onEf);
		}
		
		/**
		 * 停止移动到最后一帧调用函数侦听
		 */
		public function stopListenClipEnd() : void 
		{
			EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEf);
		}
		
		private function onEf(e : Event) : void 
		{
			if(MovieClip(asset).currentFrame == MovieClip(asset).totalFrames)
			{
				EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEf);
				_onEndCall();
			}
		}

		override public function destory(e : Event = null) : void 
		{
			super.destory(e);
			
			EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEf);
		}
	}
}
