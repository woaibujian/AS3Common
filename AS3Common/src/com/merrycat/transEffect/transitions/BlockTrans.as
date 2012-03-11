package com.merrycat.transEffect.transitions
{
	import flash.display.Sprite;

	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����02:57:17
	 */
	public class BlockTrans extends TransWithDirectionBase
	{
		public function BlockTrans(targetSpt : Sprite, rows:uint, cols:uint, everyduration:uint = 200, direction : String = RANDOM, targetW:Number = 0, targetH:Number = 0)
		{
			super(targetSpt, rows, cols, everyduration, direction, targetW, targetH);
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
					
					var block : BlockTransMask = new BlockTransMask(_blockW, _blockH, _everyduration);
					_masks.push(block);
					block.x = xPos;
					block.y = yPos;
					block.generation = r + c;
					_maskLayer.addChild(block);
				}
			}
		}
	}
}
