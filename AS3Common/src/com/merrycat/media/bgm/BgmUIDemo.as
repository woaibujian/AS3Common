package com.merrycat.media.bgm 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Jan.Bu
	 */
	public class BgmUIDemo extends BgmUIBase 
	{
		public function BgmUIDemo(asset : Sprite = null)
		{
			super(asset);
			
			ui.stop();
			ui.buttonMode = true;
			ui.mouseChildren = false;
			ui.addEventListener(MouseEvent.CLICK, uiClicked);
		}

		private function uiClicked(e : MouseEvent) : void 
		{
			bgmSignal.dispatch();
		}

		public function get ui() : MovieClip 
		{
			return MovieClip(asset);
		}

		override public function pause() : void 
		{
			super.pause();
			
			ui.gotoAndStop("stop");
		}

		override public function resume() : void 
		{
			super.resume();
			
			ui.gotoAndStop("play");
		}
	}
}
