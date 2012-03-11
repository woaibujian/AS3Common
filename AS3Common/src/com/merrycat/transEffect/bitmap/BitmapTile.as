package com.merrycat.transEffect.bitmap
{
	import frocessing.color.ColorHSV;

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����03:02:32
	 */
	public class BitmapTile extends BitmapData
	{
		private var _rect : Rectangle;
		private var unit : uint;

		public function BitmapTile(r : Rectangle, u : uint)
		{
			_rect = r;
			unit = u;
			super(_rect.width, _rect.height, false);
			init();
		}

		private function init() : void
		{
			var shape : Shape = new Shape();
			var cols : uint = Math.ceil(_rect.width / unit);
			var rows : uint = Math.ceil(_rect.height / unit);
			var px : uint = 0;
			var py : uint = 0;
			var direction : uint = 0;
			var round : uint = 1;
			var hsv : ColorHSV = new ColorHSV(0, 0, 0);
			var c : Number = 1 / (cols * rows - 1);
			for (var n : uint = 0; n < cols * rows; n++)
			{
				hsv.v = c * n;
				var color : uint = hsv.value;
				shape.graphics.beginFill(color);
				shape.graphics.drawRect(unit * px, unit * py, unit, unit);
				shape.graphics.endFill();
				switch (direction)
				{
					case 0 :
						px++;
						if (px > cols - round - 1)
						{
							direction = 1;
						}
						break;
					case 1 :
						py++;
						if (py > rows - round - 1)
						{
							direction = 2;
						}
						break;
					case 2 :
						px--;
						if (px < round)
						{
							direction = 3;
						}
						break;
					case 3 :
						py--;
						if (py < round + 1)
						{
							direction = 0;
							round++;
						}
						break;
				}
			}
			draw(shape);
		}
	}
}
