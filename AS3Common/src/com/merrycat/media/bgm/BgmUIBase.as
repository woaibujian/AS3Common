package com.merrycat.media.bgm 
{
	import org.osflash.signals.Signal;

	import com.merrycat.ViewBase;

	import flash.display.Sprite;

	/**
	 * @author merrycat
	 * 背景音乐UI基类
	 */
	public class BgmUIBase extends ViewBase
	{
		private var _bgmSignal : Signal;

		public function BgmUIBase(asset : Sprite = null)
		{
			super(asset);
			
			_bgmSignal = new Signal();
		}

		public function get bgmSignal() : Signal 
		{
			return _bgmSignal;
		}

		public function pause() : void 
		{
		}

		public function resume() : void 
		{
		}
	}
}
