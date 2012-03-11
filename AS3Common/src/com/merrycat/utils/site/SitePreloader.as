package com.merrycat.utils.site 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;

	/**
	 * @author:	Merrycat
	 * @version:	V1.0	2010-11-11	下午05:22:55
	 */
	public class SitePreloader extends MovieClip 
	{
		protected var loadPercent : int;
		
		private var _mainClassName : String;

		public function SitePreloader(mainClassName:String = "Main")
		{
			_mainClassName = mainClassName;
			
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			this.loaderInfo.addEventListener(Event.COMPLETE, onComplete);
			this.stop();
		}

		protected function onComplete(e : Event) : void
		{
			this.gotoAndStop(2);
			var main : Class = getDefinitionByName(_mainClassName) as Class;
			stage.addChild(new main());
		}

		protected function onProgress(e : ProgressEvent) : void
		{
			loadPercent = int(e.bytesLoaded / e.bytesTotal * 100);
		}
	}
}
