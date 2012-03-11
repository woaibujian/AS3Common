package com.merrycat.utils
{
	import de.polygonal.ds.Array2;

	import flash.display.Sprite;

	public class MWall
	{
		private var _totalColumn : uint;
		private var _totalRow : uint;
		private var _cellW : uint;
		private var _cellH : uint;
		private var _total : uint = 0;
		
		private var _wallItems : Array2;
		private var centered : Boolean;
		private var _parent : Sprite;
		
		private var _currAddColumn:int = 0;
		private var _currAddRow : int = 0;
		private var _columnGap : uint;
		private var _rowGap : uint;

		public function MWall(parent:Sprite, totalColumn : uint = 3, totalRow : uint = 3, cellW : uint = 0, cellH : uint = 0, columnGap:uint = 0, rowGap:uint = 0, centerAligned : Boolean = true)
		{
			_parent = parent;
			
			_totalColumn = totalColumn;
			_totalRow = totalRow;
			
			_total = totalColumn * totalRow;
			
			_cellW = cellW;
			_cellH = cellH;
			
			_columnGap = columnGap;
			_rowGap = rowGap;
			
			centered = centerAligned;
			
			_wallItems = new Array2(totalColumn, totalRow);
			_wallItems.fill(null);
		}

		public function addItem(item : Sprite) : void
		{
			_wallItems.set(_currAddColumn, _currAddRow, item);
			
			item.x = (_currAddColumn ) * (_cellW + _columnGap);
			item.y = (_currAddRow ) * (_cellH + _rowGap);
			
			if (centered)
			{
				item.x += -(_cellW + _columnGap) * (_totalColumn) / 2;
				item.y += -(_cellH + _rowGap)* (_totalRow) / 2;
			}

			_currAddColumn++;
			if(_currAddColumn == _totalColumn)
			{
				_currAddColumn = 0;
				_currAddRow++;
			}

			_parent.addChild(item);
		}

		public function getCellAt(column : int, row : int) : Sprite
		{
			return _wallItems.get(column, row);
		}
		
		public function get wallItems():Array2
		{
			return _wallItems;
		}
	}
}