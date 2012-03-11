package com.merrycat.mouse 
{
	import com.merrycat.ViewBase;
	import flash.geom.Rectangle;
	import com.merrycat.utils.MNumberUtils;

	import org.casalib.time.EnterFrame;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author:		Merrycat
	 * @version:	2010-11-24	下午02:32:03
	 * @desc:		跟随鼠标指针类
	 * @example		
	  				var _mouseFollowed : MouseFollowed;
	 		 		_mouseFollowed = new MouseFollowed(ui, 50, -ui.width / 2, -ui.height / 2);
	 				_mouseFollowed.start(); 
	 */
	public class MouseFollowed extends ViewBase
	{
		private var _offsetX : Number;
		private var _offsetY : Number;
		private var _sleepPadingl : int;
		private var _toX : Number;
		private var _toY : Number;
		
		public var limitBottom : Number;
		
		/**
		 * 初始化
		 * 
		 * @param	asset				跟随鼠标显示对象
		 * @param	sleepAreaPixel		设置一个范围，鼠标在该范围内时跟随对象不跟着鼠标移动。该参数为扩展四周边界的像素值
		 * @param	offsetX				跟随对象相对于注册原点的偏移X值
		 * @param	offsetY				跟随对象相对于注册原点的偏移Y值
		 */
		public function MouseFollowed(asset:Sprite, sleepPading:int = 1, offsetX:Number = 0, offsetY:Number = 0) 
		{
			this.asset = asset;	
			_sleepPadingl = sleepPading;
			_offsetX = offsetX;
			_offsetY = offsetY;
		}
		
		/**
		 * 开始跟随
		 */
		public function start() : void 
		{
			_toX = asset.x;
			_toY = asset.y;
			
			EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, onEf);
		}
		
		/**
		 * 停止跟随
		 */
		public function stop() : void 
		{
			EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEf);
		}
		
		private function onEf(event : Event) : void 
		{
			if(!isInArea(getAssetAreaRect()))
			{
				_toX = _offsetX + asset.parent.mouseX;
				_toY = _offsetY + asset.parent.mouseY;
			}
			
			asset.x += MNumberUtils.approximateZero((_toX - asset.x) * 0.1); 
			asset.y += MNumberUtils.approximateZero((_toY - asset.y) * 0.1); 
			
			if(asset.y > limitBottom)
			{
				asset.y = limitBottom;	
			}
		}
		
		/**
		 * 当跟随对象被移除显示列表时自动停止跟随
		 */
		override public function destory(e : Event = null) : void 
		{
			super.destory(e);
			stop();
		}

		private function isInArea(area:Rectangle) : Boolean 
		{
//			(_asset.parent as Sprite).graphics.clear();
//			(_asset.parent as Sprite).graphics.beginFill(0xFF0000);
//			(_asset.parent as Sprite).graphics.drawRect(area.x, area.y, area.width, area.height);
//			(_asset.parent as Sprite).graphics.endFill();
			
			if(asset.parent.mouseX >= area.x 
				&& asset.parent.mouseX <= area.x + area.width  
				&& asset.parent.mouseY >= area.y 
				&& asset.parent.mouseY <= area.y + area.height
				)
			{
				return true;
			}
			
			return false;
		}

		private function getAssetAreaRect() : Rectangle 
		{
			return new Rectangle(asset.x - _sleepPadingl, 
				asset.y - _sleepPadingl, 
				asset.width + _sleepPadingl * 2, 
				asset.height + _sleepPadingl * 2);
		}
	}
}
