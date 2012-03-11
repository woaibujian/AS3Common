package com.merrycat.transEffect.transitions
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����02:57:50
	 */
	public class BlockTransMask extends TransMaskBase
	{
		public var generation : uint;
		private var mWidth : Number;
		private var mHeight : Number;
		private var _scale : Number = 1;
		private var timer : Timer;
		private static var deceleration : Number = 0.4;

		public function BlockTransMask(w : Number, h : Number, everyduration:uint)
		{
			super(everyduration);
			
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
			
			var offset : uint;
			
			switch(type)
			{
				case TransBase.APPEAR:
					scale = 0;
					break;
					
				case TransBase.DISAPPEAR:
					scale = 1;
					break;
			}
			
			offset = everyduration * (generation + 1);
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

		public function get scale() : Number
		{
			return _scale;
		}

		public function set scale(param : Number) : void
		{
			_scale = param;
			scaleX = scaleY = _scale;
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
	}
}
