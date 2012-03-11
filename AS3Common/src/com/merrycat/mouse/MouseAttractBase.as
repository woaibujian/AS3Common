package com.merrycat.mouse
{
	import com.merrycat.ViewBase;

	import org.casalib.time.EnterFrame;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author:		Merrycat
	 * @version:	2010-12-7	����07:25:34
	 */
	public class MouseAttractBase extends ViewBase
	{
		public var orginX : Number;
		public var orginY : Number;
		
		public function MouseAttractBase(asset : Sprite)
		{
			super(asset);
		}
		
		protected function createTestAreaShape() : void
		{
		}
		
		public function start() : void
		{
			EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, onEf);
		}
		
		public function stop() : void
		{
			EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEf);
		}

		protected function onEf(e : Event) : void
		{
		}
		
		protected function isInArea() : Boolean 
		{
			return false;
		}

		override public function destory(e : Event = null) : void
		{
			super.destory(e);
			
			stop();
		}
	}
}
