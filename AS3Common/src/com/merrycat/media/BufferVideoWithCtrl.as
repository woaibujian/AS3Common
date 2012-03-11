package com.merrycat.media
{
	import com.greensock.TweenLite;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	/**
	 * @author:		Merrycat
	 * @version:	2010-12-6	����01:59:42
	 */
	public class BufferVideoWithCtrl extends BufferVideo
	{
		public var ctrlUI:MovieClip;
		public var ctrlUIClass : Class;
		private const CTRL_LABEL_PLAY:String = "PLAY";
		private const CTRL_LABEL_PAUSE:String = "PAUSE";
		
		public var onPauseCall : Function;
		
		public function BufferVideoWithCtrl(url : String, vid : Video, ctrlUIClass:Class, smoothing:Boolean = true, replay:Boolean = false)
		{
			this.ctrlUIClass = ctrlUIClass;
			super(url, vid, true, smoothing, replay);
		}
		
		override public function play(bufferTime:int = 5) : void
		{
			super.play(bufferTime);
			
			ctrlUI = new ctrlUIClass();
			ctrlUI.gotoAndStop(CTRL_LABEL_PAUSE);
			ctrlUI.buttonMode = true;
			ctrlUI.addEventListener(MouseEvent.CLICK, onCtrlUIClick);
			ctrlUI.addEventListener(MouseEvent.MOUSE_OVER, onCtrlUIOver);
			ctrlUI.graphics.beginFill(0, 0.2);
			ctrlUI.graphics.drawRect(-vid.width / 2, -vid.height / 2, vid.width, vid.height);
			ctrlUI.graphics.endFill();
			ctrlUI.x = vid.x + vid.width / 2;
			ctrlUI.y = vid.y + vid.height / 2;
			ctrlUI.alpha = 0;
			ctrlUI.mouseChildren = false;
			vid.parent.addChild(ctrlUI);
		}

		private function onCtrlUIOver(e : MouseEvent) : void
		{
			ctrlUI.addEventListener(MouseEvent.MOUSE_OUT, onCtrlUIOut);
			ctrlUI.removeEventListener(MouseEvent.MOUSE_OVER, onCtrlUIOver);
			TweenLite.to(ctrlUI, 0.5, {alpha:1});
		}

		private function onCtrlUIOut(e : MouseEvent) : void
		{
			ctrlUI.removeEventListener(MouseEvent.MOUSE_OUT, onCtrlUIOut);
			ctrlUI.addEventListener(MouseEvent.MOUSE_OVER, onCtrlUIOver);
			TweenLite.to(ctrlUI, 0.5, {alpha:0});
		}
		
		override public function destory(e : Event = null) : void
		{
			super.destory(e);
			ctrlUI.removeEventListener(MouseEvent.CLICK, onCtrlUIClick);
			ctrlUI.removeEventListener(MouseEvent.MOUSE_OVER, onCtrlUIOver);
			ctrlUI.removeEventListener(MouseEvent.MOUSE_OUT, onCtrlUIOut);
			ctrlUI.parent.removeChild(ctrlUI);
		}
		
		private function onCtrlUIClick(e : MouseEvent) : void
		{
			if(vp.paused)
			{
				vp.resume();
				ctrlUI.gotoAndStop(CTRL_LABEL_PAUSE);
			}else
			{
				vp.pause();
				onPauseCall && onPauseCall();
				ctrlUI.gotoAndStop(CTRL_LABEL_PLAY);
			}
		}

	}
}
