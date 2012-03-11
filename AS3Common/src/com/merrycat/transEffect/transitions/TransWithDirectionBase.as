package com.merrycat.transEffect.transitions
{
	import org.casalib.util.NumberUtil;

	import flash.display.Sprite;

	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����05:34:09
	 */
	public class TransWithDirectionBase extends TransBase
	{
		private var _directions:Array = [TransDirection.FROM_TL, TransDirection.FROM_TR, TransDirection.FROM_BL, TransDirection.FROM_BR];
		
		public static const RANDOM:String = "random";
		
		protected var _cols : uint;
		protected var _rows : uint;
		protected var _direction : String;
		protected var _everyduration : uint;
		protected var _completed : uint = 0;
		protected var _maskLayer : Sprite;
		protected var _masks : Array;
		
		protected var _blockW : Number;
		protected var _blockH : Number;
		
		public function TransWithDirectionBase(targetSpt : Sprite, rows:uint, cols:uint, everyduration:uint = 200, direction : String = RANDOM, targetW:Number = 0, targetH:Number = 0)
		{
			super(targetSpt, targetW, targetH);
			
			_rows = rows;
			_cols = cols;
			
			_blockH = _targetH / _rows;
			_blockW = _targetW / _cols;
			
			_everyduration = everyduration;
			
			if(direction == RANDOM)
			{
				_direction = _directions[NumberUtil.randomIntegerWithinRange(0, _directions.length - 1)];
			}else
			{
				_direction = direction;
			}
			
			_maskLayer = new Sprite();
		}
		
		override public function effectBegin(type:int = TransBase.APPEAR) : void
		{
			super.effectBegin(type);
			
			createMasks();
			
			transit();
		}
		
		protected function createMasks() : void
		{
			_masks = [];
			
			_targetSpt.addChild(_maskLayer);
			_targetSpt.mask = _maskLayer;
		}
		
		override public function reset() : void
		{
			super.reset();
			
			if (_targetSpt)
			{
				if (_targetSpt.contains(_maskLayer))
				{
					_targetSpt.removeChild(_maskLayer);
					_targetSpt.mask = null;
					
					if (transType == TransBase.DISAPPEAR)
					{
						_targetSpt.visible = false;
					}
				}
			}
			
			close();
		}
		
		protected function transit() : void
		{
			for (var n : uint = 0; n < _rows * _cols; n++)
			{
				var transMask : TransMaskBase = _masks[n];
				transMask.onMaskComp = onMaskComp;
				transMask.effect(transType);
			}
		}
		
		protected function close() : void
		{
			for (var n : uint = 0; n < _rows * _cols; n++)
			{
				var transMask : TransMaskBase = _masks[n];
				transMask.close();
				transMask.onMaskComp = null;
			}
			_completed = 0;
		}
		
		private function onMaskComp() : void
		{
			_completed++;
			if (_completed >= _rows * _cols)
			{
				reset();
				effectEnd();
			}
		}
	}
}
