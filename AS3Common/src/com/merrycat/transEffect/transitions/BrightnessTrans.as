package com.merrycat.transEffect.transitions
{
	import com.merrycat.transEffect.ColorManager;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����02:56:29
	 */
	public class BrightnessTrans extends TransBase
	{
		private var _brightOffset : Number = 0;
		private var _speed : Number = 5;

		public function BrightnessTrans(targetSpt : Sprite, speed:Number = 5)
		{
			super(targetSpt);
			_speed = speed;
		}
		
		override public function effectBegin(type:int = TransBase.APPEAR) : void
		{
			super.effectBegin(type);
			
			switch(type)
			{
				case TransBase.APPEAR:
					brightOffset = 100;
					break;
					
				case TransBase.DISAPPEAR:
					brightOffset = 0;
					break;
			}
			
			addEventListener(Event.ENTER_FRAME, transit, false, 0, true);
		}

		private function transit(evt : Event) : void
		{
			switch(transType)
			{
				case TransBase.APPEAR:
					brightOffset -= _speed;
					if (brightOffset <= 0)
					{
						brightOffset = 0;
						removeEventListener(Event.ENTER_FRAME, transit);
						effectEnd();
					}
					break;
					
				case TransBase.DISAPPEAR:
					brightOffset += _speed;
					if (brightOffset >= 100)
					{
						brightOffset = 100;
						removeEventListener(Event.ENTER_FRAME, transit);
						effectEnd();
					}
					break;
			}
		}

		public function get brightOffset() : Number
		{
			return _brightOffset;
		}

		public function set brightOffset(param : Number) : void
		{
			_brightOffset = param;
			ColorManager.brightOffset(_targetSpt, _brightOffset);
		}

		override public function reset() : void
		{
			if (!_targetSpt)
			{
				return;
			}
			
			switch(transType)
			{
				case TransBase.APPEAR:
					brightOffset = 0;
					break;
					
				case TransBase.DISAPPEAR:
					brightOffset = 100;
					break;
			}	
		}
	}
}
