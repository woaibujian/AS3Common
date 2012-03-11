package com.merrycat.transEffect.transitions
{
	import com.merrycat.transEffect.bitmap.BitmapTile;
	import com.merrycat.transEffect.bitmap.Threshold;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����03:14:50
	 */
	public class ThresholdTrans extends TransBase
	{
		private var _operation : String = Threshold.OPERATION_HIGH;
		
		private var _rect : Rectangle;
		private var _bmpd : BitmapData;
		private var threshold : Threshold;
		private var _bitmap : Bitmap;
		private var _threshold : uint = 0x000000;
		private var _speed : uint = 0x020202;
		private var _color : uint = 0x00000000;
		private var _mask : uint = 0x00FFFFFF;

		public function ThresholdTrans(targetSpt : Sprite, operationBmpd:BitmapData, speed:uint = 0x020202)
		{
			super(targetSpt);
			
			_speed = speed;
			_rect = new Rectangle(0, 0, _targetW, _targetH);
			_bmpd = operationBmpd;
		}
		
		override public function effectBegin(type:int = TransBase.APPEAR) : void
		{
			super.effectBegin(type);
			
			var bitmapData : BitmapData = new BitmapData(_rect.width, _rect.height, false);
			_bitmap = new Bitmap(bitmapData);
			threshold = new Threshold(_bmpd);
			_bitmap.bitmapData = threshold;
			
			_targetSpt.cacheAsBitmap = true;
			_bitmap.cacheAsBitmap = true;
			_targetSpt.mask = _bitmap;
			if (!_targetSpt.contains(_bitmap)) _targetSpt.addChild(_bitmap);
			
			switch(type)
			{
				case TransBase.APPEAR:
					_threshold = 0x000000;
					threshold.reset(0x00000000);
					break;
					
				case TransBase.DISAPPEAR:
					_threshold = 0xFFFFFF;
					threshold.reset(0xFFFFFFFF);
					break;
			}
			
			addEventListener(Event.ENTER_FRAME, transit, false, 0, true);
		}

		private function transit(evt : Event) : void
		{
			switch(transType)
			{
				case TransBase.APPEAR:
					_threshold += _speed;
					threshold.apply(_operation, _threshold, _color, _mask);
					if (_threshold > 0xFFFFFF)
					{
						effectEnd();
					}
					break;
					
				case TransBase.DISAPPEAR:
					_threshold -= _speed;
					threshold.apply(_operation, _threshold, _color, _mask);
					if (_threshold <= 0x000000)
					{
						effectEnd();
					}
					break;
			}
		}
		
		override protected function effectEnd() : void
		{
			super.effectEnd();
			
			switch(transType)
			{
				case TransBase.APPEAR:
					_threshold = 0xFFFFFF;
					break;
					
				case TransBase.DISAPPEAR:
					_threshold = 0x000000;
					break;
			}
			
			removeEventListener(Event.ENTER_FRAME, transit);
			onTransComp && onTransComp();
			reset();
		}

		override public function reset() : void
		{
			if (_targetSpt)
			{
				if (_targetSpt.contains(_bitmap))
				{
					_targetSpt.removeChild(_bitmap);
					_targetSpt.mask = null;
					
					if (transType == TransBase.DISAPPEAR)
					{
						_targetSpt.visible = false;
					}
				}
			}
		}
	}
}
