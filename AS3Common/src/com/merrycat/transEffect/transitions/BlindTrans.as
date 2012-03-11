package com.merrycat.transEffect.transitions
{
	import flash.display.Sprite;
	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����02:58:17
	 */
	public class BlindTrans extends TransWithDirectionBase
	{
		public function BlindTrans(targetSpt : Sprite, split:uint, everyduration:uint = 200, direction : String = RANDOM, targetW:Number = 0, targetH:Number = 0)
		{
			super(targetSpt, split, split, everyduration, direction, targetW, targetH);
			
			if(_direction == TransDirection.FROM_BL || _direction == TransDirection.FROM_BR)
			{
				_cols = 1;
			}else
			{
				_rows = 1;
			}
		}

		override protected function createMasks() : void
		{
			super.createMasks();
			
			for (var r : uint = 0; r < _rows; r++)
			{
				for (var c : uint = 0; c < _cols; c++)
				{
					var xPos : uint = _blockW / 2 + _blockW * (c % _cols);
					var yPos : uint = _blockH / 2 + _blockH * r;
					var blind : BlindTransMask;
					if(_direction == TransDirection.FROM_BL || _direction == TransDirection.FROM_BR)
					{
						blind = new BlindTransMask(_direction, _targetW * 2, _blockH, _everyduration);
					}else
					{
						blind = new BlindTransMask(_direction, _blockW, _targetH * 2, _everyduration);
					}
					_masks.push(blind);
					blind.x = xPos;
					blind.y = yPos;
					blind.generation = r + c;
					_maskLayer.addChild(blind);
				}
			}
		}
	}
}
