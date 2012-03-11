package com.merrycat.load
{
	import com.greensock.TweenMax;

	import org.casalib.math.Percent;
	import org.casalib.time.Interval;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * @author merrycat
	 * 加载进度类，环状圆呈现
	 */
	public class PreLoadUI implements IPreLoadUI
	{
		private var _ani100 : MovieClip;
		private var _txt : TextField;
		private var _currPercent : Percent;
		
		private var _debugPercent : Number;
		
		/**
		 * 构造函数
		 * @example
		 * <listing version="3.0">
		 * package {
				public class CommonLoadingUI extends PreLoadUI
				{
					public function CommonLoadingUI(ani100:MovieClip)
					{
						super(ani100, txt);
					}
					override public function set currPercent( p : Percent ):void
					{
						super.currPercent = p;
					}
			
					override public function destory():void
					{
						super.destory();
					}
				}
			}
		 * 
		 * var loader:SwfLoad = new SwfLoad("demo.swf");
		 * var loading:MovieClip = new CommonLoading();
		 * var loadingUI:PreLoadUI = new CommonLoadingUI(loading);
		 * StageReference.getStage().addChild(loading);
		 * var preLoad:PreLoad = new PreLoad(loadingUI, loader, loadComp);
		 * 
		 * function loadComp():void{}
		 * </listing>
		 * 
		 * @param	parent			承载对象
		 */
		public function PreLoadUI( ani100 : MovieClip = null, txt : TextField = null )
		{
			_ani100 = ani100;
			if( ani100 ) ani100.stop();
			_txt = txt;
		}
		
		/**
		 * 调试模式，按参数频率设置加载进度
		 * @param	frequency			频率
		 */
		public function useDebugMode(frequency:int = 20) : void 
		{
			_debugPercent = 0;
			Interval.setInterval(debugUpdate, frequency).start();
		}

		private function debugUpdate() : void 
		{
			_debugPercent += 0.01;
			if(_debugPercent > 1)
			{
				_debugPercent = 0;
			}
			currPercent = new Percent(_debugPercent);
		}
		
		public function set currPercent( p : Percent ):void
		{
			_currPercent = p;
			var pp : Number = Math.round( _currPercent.percentage );
			
			if( _ani100 ) updateAni100( pp );
			if( _txt ) updateTxt( pp );
		}
		
		public function get currPercent():Percent
		{
			return _currPercent;
		}
		
		public function get ani100():MovieClip
		{
			return _ani100;
		}
		
		public function get txt():TextField
		{
			return _txt;
		}
		
		protected function updateAni100( pp : Number ):void
		{
			_ani100.gotoAndStop( pp );
		}
		
		protected function updateTxt( pp : Number ):void
		{
			_txt.text = String( pp + "%");
		}

		public function destory() : void 
		{
			TweenMax.to(_ani100, 0.5, {alpha:0, onComplete:fadeComp});
		}

		private function fadeComp() : void 
		{
			if(_ani100)
			{
				_ani100.parent.removeChild(_ani100);
				_ani100 = null;
			}
		}
		
		public function get dispUI() : DisplayObject
		{
			return _ani100;
		}
	}
}