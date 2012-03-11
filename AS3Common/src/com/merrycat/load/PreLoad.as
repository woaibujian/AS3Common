package com.merrycat.load
{
	import org.casalib.load.SwfLoad;

	import com.greensock.TweenMax;

	import org.casalib.events.LoadEvent;
	import org.casalib.load.LoadItem;
	import org.casalib.process.Process;
	import org.casalib.process.ProcessGroup;

	import flash.events.EventDispatcher;

	/**
	 * @author merrycat
	 * 加载进度控制类
	 */
	public class PreLoad extends EventDispatcher
	{
		private var _ui : IPreLoadUI;

		private var _loader : Process;
		private var _completed : Function;
		private var _autoFade : Boolean;
		private var _destoryed : Boolean;

		/**
		 * 构造函数
		 * @example
		 * <listing version="3.0">
		 * var loader:SwfLoad = new SwfLoad("demo.swf");
		 * var loading:MovieClip = new CommonLoading();
		 * var loadingUI:PreLoadUI = new CommonLoadingUI(loading);
		 * StageReference.getStage().addChild(loading);
		 * var preLoad:PreLoad = new PreLoad(loadingUI, loader, loadComp);
		 * 
		 * function loadComp():void{}
		 * </listing>
		 * 
		 * @param	ui			LOADING显示对象类
		 * @param	loader		加载类
		 * @param	completed	加载完成执行函数
		 * @param	autoFade	消失检出动画
		 */
		public function PreLoad( ui : IPreLoadUI, loader : Process, completed : Function, autoFade : Boolean = true )
		{
			_ui = ui;
			
			_loader = loader;
			
			_completed = completed;
			
			_autoFade = autoFade;
			
			if(loader is LoadItem || loader is ProcessGroup)
			{
				_ui.dispUI.alpha = 0;
				TweenMax.to(_ui.dispUI, 0.5, {alpha:1, delay:0.5});
				
				loader.addEventListener(LoadEvent.PROGRESS, progHandler);
				loader.addEventListener(LoadEvent.COMPLETE, compHandler);
				loader.start();
			}
			else
			{
				throw new Error("No LoadItem or Process be found"); 
			}
		}

		private function progHandler( e : LoadEvent ) : void
		{
			if( _ui )
				_ui.currPercent = e.progress;
		}

		private function compHandler( e : LoadEvent ) : void
		{
			if(_autoFade)
			{
				TweenMax.killDelayedCallsTo(_ui.dispUI);
				TweenMax.to(_ui.dispUI, 0.5, {alpha:0, onComplete:uiFadeOutComp});
			}
			
			_completed && _completed();
			
			if( _ui )
				_ui.currPercent = e.progress;
		}

		private function uiFadeOutComp() : void 
		{
			_ui.destory();
			_destoryed = true;
		}

		public function destory() : void 
		{
			TweenMax.killTweensOf(_ui);
			
			if(_loader is SwfLoad)
			{
				try 
				{ 
					//FP10 and up:
					if(this["unloadAndStop"] != null)
					{
						(_loader as SwfLoad).loader.unloadAndStop();
					}
				}
					catch (e : Error) 
				{
					(_loader as SwfLoad).loader.unload();
				}
			}
			
			_loader.destroy();
			if(!_destoryed) _ui.destory();
		}
	}
}