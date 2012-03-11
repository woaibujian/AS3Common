package com.merrycat.transEffect.transitions
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����03:00:21
	 */
	public class CircleTransMask extends TransMaskBase
	{
		public var generation : uint;
		private var radius : uint;
		private var _scale : Number = 1;
		private var timer : Timer;
		private static var speed : Number = 0.05;

		public function CircleTransMask(r : uint, everyduration:uint)
		{
			super(everyduration);
			
			radius = r;
			
			init();
		}

		private function init() : void
		{
			graphics.beginFill(0x000000);
			graphics.drawCircle(0, 0, radius);
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
					scale += speed;
					if (scale >= 1)
					{
						scale = 1;
						removeEventListener(Event.ENTER_FRAME, transit);
						onMaskComp && onMaskComp();
					}
					break;
					
				case TransBase.DISAPPEAR:
					scale -= speed;
					if (scale <= 0)
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
