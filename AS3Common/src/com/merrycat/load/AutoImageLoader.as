package com.merrycat.load 
{
	import org.casalib.events.LoadEvent;
	import org.casalib.load.ImageLoad;

	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	/**
	 * @author:		Merrycat
	 * @version:	2010-11-23	上午11:43:02
	 * @example:
	 				var _autoImageLoader : AutoImageLoader = new AutoImageLoader("assets/historyMap.jpg", imgCont);
					_autoImageLoader.onCompleteCall = onLoadComp;
					_autoImageLoader.startLoad();
	 */
	public class AutoImageLoader 
	{
		private var _url : String;
		private var _imageLoad : ImageLoad;
		private var _img : Bitmap;
		private var _imgSpt : Sprite;
		private var _loadUI : CircleLoadUI;
		private var _isLoaded : Boolean = false;
		
		public var bakUrl : String = "";
		
		public var onCompleteCall : Function;
		public var onCompleteCallParams : Array;
		
		public var loaderUIColor : uint = 0xFFFFFF;
		public var loaderUIScale : Number = 1;
		
		private var _loadingParent : DisplayObjectContainer;
		private var _parent : DisplayObjectContainer;
		
		private var _autoSmooth : Boolean;
		private var _useImgSpt : Boolean;

		public function AutoImageLoader(url:String, loadingParent:DisplayObjectContainer, parent:DisplayObjectContainer = null, autoSmooth:Boolean = true, useImgSpt:Boolean = false) 
		{
			_url = url;
			_loadingParent = loadingParent;
			_parent = parent;
			_autoSmooth = autoSmooth;
			_useImgSpt = useImgSpt;
			
			if (!parent)
			{
				_parent = _loadingParent;
			}
			
			if(_useImgSpt)
			{
				_imgSpt = new Sprite();
				_parent.addChild(_imgSpt);
			}
		}

		public function startLoad() : void 
		{
			_imageLoad = new ImageLoad(_url);
			_imageLoad.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_imageLoad.addEventListener(LoadEvent.COMPLETE, onLoaded);
			_imageLoad.start();
			
			_loadUI = new CircleLoadUI(_loadingParent, loaderUIColor, true, loaderUIScale);
		}

		private function onIOError(e : IOErrorEvent) : void
		{
			trace("AutoImageLoader onIOError: " + _imageLoad.url);
			if(bakUrl != "")
			{
				_imageLoad.destroy();
				
				_imageLoad = new ImageLoad(bakUrl);
				_imageLoad.addEventListener(LoadEvent.COMPLETE, onLoaded);
				_imageLoad.start();
			}else
			{
				_loadUI.remove();
			}
		}

		private function onLoaded(e : LoadEvent) : void 
		{
			_img = _imageLoad.contentAsBitmap;
			_img.smoothing = _autoSmooth;
			
			_isLoaded = true;
			
			_loadUI.remove();
			
			if(_useImgSpt)
			{
				_imgSpt.addChild(_img);
			}else
			{
//				_parent.addChild(_img);
			}
			
			_img.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
			
			onCompleteCall && onCompleteCall.apply(null, onCompleteCallParams);
		}

		private function dispose(e : Event) : void
		{
			_img.removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
			_img.bitmapData.dispose();
		}

		public function destory() : void 
		{
			if(_isLoaded)
			{
				if(_useImgSpt)
				{
					_imgSpt.removeChild(_img);
				}else
				{
//					_parent.removeChild(_img);
				}
				
				_img.bitmapData.dispose();
			}
			
			_imageLoad && _imageLoad.destroy();
		}
		
		public function get img() : Bitmap 
		{
			return _img;
		}
		
		public function get imgSpt() : Sprite 
		{
			return _imgSpt;
		}
		
		public function get isLoaded() : Boolean 
		{
			return _isLoaded;
		}
	}
}
