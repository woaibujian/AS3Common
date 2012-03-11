package com.merrycat.transEffect.transitions
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����03:13:17
	 */
	public class FadeTrans extends TransBase
	{
		private var _speed : Number = 0.05;

		public function FadeTrans(targetSpt : Sprite, speed:Number = 0.05)
		{
			super(targetSpt);
			
			_speed = speed;
		}
		
		override public function effectBegin(type:int = TransBase.APPEAR) : void
		{
			super.effectBegin();
			
			super.effectBegin(type);
			
			switch(type)
			{
				case TransBase.APPEAR:
					_targetSpt.alpha = 0;
					break;
					
				case TransBase.DISAPPEAR:
					_targetSpt.alpha = 1;
					break;
			}
		
			addEventListener(Event.ENTER_FRAME, transit, false, 0, true);
		}

		private function transit(evt : Event) : void
		{
			switch(transType)
			{
				case TransBase.APPEAR:
					_targetSpt.alpha += _speed;
					if (_targetSpt.alpha >= 1)
					{
						_targetSpt.alpha = 1;
						removeEventListener(Event.ENTER_FRAME, transit);
						effectEnd();
					}
					break;
					
				case TransBase.DISAPPEAR:
					_targetSpt.alpha -= _speed;
					if (_targetSpt.alpha <= 0)
					{
						_targetSpt.alpha = 0;
						removeEventListener(Event.ENTER_FRAME, transit);
						effectEnd();
					}
					break;
			}
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
					_targetSpt.alpha = 1;
					break;
					
				case TransBase.DISAPPEAR:
					_targetSpt.alpha = 0;
					break;
			}	
		}
	}
}
