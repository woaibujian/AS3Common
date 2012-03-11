package com.merrycat.transEffect.transitions
{
	import flash.display.Sprite;

	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����02:59:52
	 */
	public class CircleTrans extends TransWithDirectionBase
	{
		private var _radius : Number;

		public function CircleTrans(targetSpt : Sprite, rows:uint, cols:uint, radius:Number = 30, everyduration:uint = 200, direction : String = RANDOM, targetW:Number = 0, targetH:Number = 0)
		{
			super(targetSpt, rows, cols, everyduration, direction, targetW, targetH);
			
			_radius = radius;
		}

		override protected function createMasks() : void
		{
			super.createMasks();
			
			for (var r : uint = 0; r < _rows; r++)
			{
				for (var c : uint = 0; c < _cols; c++)
				{
					var xPos : uint;
					var yPos : uint;
					switch (_direction)
					{
						case TransDirection.FROM_TL :
							xPos = _blockW / 2 + _blockW * (c % _cols);
							yPos = _blockH / 2 + _blockH * r;
							break;
						case TransDirection.FROM_BL :
							xPos = _blockW / 2 + _blockW * (c % _cols);
							yPos = _blockH / 2 + _blockH * (_rows - r - 1);
							break;
						case TransDirection.FROM_TR :
							xPos = _blockW / 2 + _blockW * ((_cols - c - 1) % _cols);
							yPos = _blockH / 2 + _blockH * r;
							break;
						case TransDirection.FROM_BR :
							xPos = _blockW / 2 + _blockW * ((_cols - c - 1) % _cols);
							yPos = _blockH / 2 + _blockH * (_rows - r - 1);
							break;
					}
					var circle : CircleTransMask = new CircleTransMask(_radius, _everyduration);
					_masks.push(circle);
					circle.x = xPos;
					circle.y = yPos;
					circle.generation = r + c;
					_maskLayer.addChild(circle);
				}
			}
		}
	}
}
