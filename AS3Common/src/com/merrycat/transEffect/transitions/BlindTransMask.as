package com.merrycat.transEffect.transitions
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����02:59:13
	 */
	public class BlindTransMask extends TransMaskBase
	{
		public var generation : uint;
		private var type : String;
		private var mWidth : uint;
		private var mHeight : uint;
		private var _scale : Number = 1;
		private var timer : Timer;
		private static var deceleration : Number = 0.4;

		public function BlindTransMask(t : String, w : uint, h : uint, everyduration:uint)
		{
			super(everyduration);
			
			type = t;
			mWidth = w;
			mHeight = h;
			init();
		}

		private function init() : void
		{
			graphics.beginFill(0x000000);
			graphics.drawRect(-mWidth / 2, -mHeight / 2, Math.ceil(mWidth), Math.ceil(mHeight));
			graphics.endFill();
		}

		override public function effect(type:int = TransBase.APPEAR) : void
		{
			super.effect(type);
			
			switch(type)
			{
				case TransBase.APPEAR:
					scale = 0;
					break;
					
				case TransBase.DISAPPEAR:
					scale = 1;
					break;
			}
			
			var offset : uint = everyduration * (generation + 1);
			timer = new Timer(offset, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, open, false, 0, true);
			timer.start();
		}

		private function open(evt : TimerEvent) : void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, open);
			addEventListener(Event.ENTER_FRAME, transit, false, 0, true);
		}

		private function transit(evt : Event) : void
		{
			switch(transType)
			{
				case TransBase.APPEAR:
					scale += (1 - scale) * deceleration;
					if (Math.abs(1 - scale) < 0.005)
					{
						scale = 1;
						removeEventListener(Event.ENTER_FRAME, transit);
						onMaskComp && onMaskComp();
					}
					break;
					
				case TransBase.DISAPPEAR:
					scale -= (scale) * deceleration;

					if (Math.abs(scale) < 0.005)
					{
						scale = 0;
						removeEventListener(Event.ENTER_FRAME, transit);
						onMaskComp && onMaskComp();
					}
					break;
			}
		}

		override public function close() : void
		{
			switch(transType)
			{
				case TransBase.APPEAR:
					scale = 0;
					break;
					
				case TransBase.DISAPPEAR:
					scale = 1;
					break;
			}
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, open);
			timer.stop();
			removeEventListener(Event.ENTER_FRAME, transit);
		}

		public function get scale() : Number
		{
			return _scale;
		}

		public function set scale(param : Number) : void
		{
			_scale = param;
			switch (type)
			{
				case TransDirection.FROM_TL :
				case TransDirection.FROM_TR :
					scaleX = _scale;
					break;
				case TransDirection.FROM_BL :
				case TransDirection.FROM_BR :
					scaleY = _scale;
					break;
			}
		}
	}
}
