package com.merrycat.media.bgm 
{
	import com.greensock.TweenMax;
	import com.merrycat.media.SoundPlayer;

	/**
	 * @author merrycat
	 * 背景音乐管理器，同时只播放一首背景乐，并有渐入、渐出柔和效果
	 */
	public class BgmPlayer 
	{
		private static var instance : BgmPlayer;
		private var _sp : SoundPlayer;
		private var _ui : BgmUIBase;
		private var _isReplay:Boolean = false;
		
		public function BgmPlayer( pw : PrivateClass ) : void
		{
			_sp = new SoundPlayer();
		}
		
		public function get sp():SoundPlayer
		{
			return _sp;
		}

		public static function getInstance() : BgmPlayer
		{
			if ( instance == null )
				instance = new BgmPlayer(new PrivateClass());
				
			return instance;
		}
		
		public function set ui(ui : BgmUIBase) : void 
		{
			_ui = ui;
			_ui.bgmSignal.add(changState);
		}

		private function changState() : void 
		{
			if(_sp.paused)
			{
				resume();	
			}
			else
			{
				pause();
			}
		}
		
		/**
		 * 播放音乐
		 * 
		 * @param	url			音乐路径
		 */
		public function play(url : String, isReplay:Boolean = true) : void 
		{
			_isReplay = isReplay;
			_sp.play(url, _isReplay);
		}
		
		/**
		 * 更改音乐
		 * 
		 * @param	url			音乐路径
		 */
		public function changeBgm(url : String) : void 
		{
			TweenMax.killTweensOf(_sp);
			TweenMax.to(_sp, 1, {volume:0, onComplete:function():void
			{
				_sp.play(url, _isReplay);
				_sp.volume = 1;
				
				if(_sp.paused)
				{
					_sp.pause();
				}
			}});
		}
		
		/**
		 * 暂停音乐
		 */
		public function pause() : void 
		{
			TweenMax.killTweensOf(_sp);
			TweenMax.to(_sp, 1, {volume:0, onComplete:function():void
			{
				_sp.pause();
			}});
						
			_ui.pause();
		}
		
		/**
		 * 暂停后继续播放
		 */
		public function resume() : void 
		{
			TweenMax.killTweensOf(_sp);
			
			TweenMax.to(_sp, 1, {volume:1, onComplete:function():void
			{
				_sp.resume();
			}});
			
			_ui.resume();
		}
	}
}

class PrivateClass
{
}