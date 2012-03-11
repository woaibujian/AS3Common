package com.merrycat.transEffect.transitions
{
	import flash.display.Sprite;

	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����05:01:02
	 */
	public class TransBase extends Sprite
	{
		protected var _targetSpt : Sprite;
		protected var _targetW : Number;
		protected var _targetH : Number;
		protected var _running : Boolean = false;
		
		public var onTransComp : Function;
		public var onTransCompParam:Array;
		
		public var transType:int = APPEAR;
		
		public static const APPEAR:int = 0;
		public static const DISAPPEAR:int = 1;
		
		public function TransBase(targetSpt:Sprite, targetW:Number = 0, targetH:Number = 0)
		{
			_targetSpt = targetSpt;
			
			if(targetW <= 0)
			{
				_targetW = targetSpt.width;
			}else
			{
				_targetW = targetW;
			}
			
			if(targetH <= 0)
			{
				_targetH = targetSpt.height;
			}else
			{
				_targetH = targetH;
			}
		}

		public function effectBegin(type:int = TransBase.APPEAR) : void
		{
			_running = true;
			
			transType = type;
		}

		protected function effectEnd() : void
		{
			_running = false;
			
			if (transType == TransBase.DISAPPEAR && _targetSpt.parent)
			{
				_targetSpt.parent.removeChild(_targetSpt);
			}
			
			onTransComp && onTransComp.apply(null, onTransCompParam);
		}
		
		public function get running() : Boolean 
		{
			return _running;
		}
		
		public function reset() : void
		{
			
		}
	}
}
