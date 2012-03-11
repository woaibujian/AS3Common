package com.merrycat.transEffect.bitmap
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����03:01:32
	 */
	public class Threshold extends BitmapData
	{
		private var source : BitmapData;
		private static var point : Point = new Point();
		private var operation : String;
		private var _threshold : uint;
		private var color : uint;
		private var mask : uint;
		public static const OPERATION_LOW : String = "<=";
		public static const OPERATION_HIGH : String = ">=";

		public function Threshold(bd : BitmapData, o : String = OPERATION_LOW, t : uint = 0x000000, c : uint = 0x00000000, m : uint = 0xFFFFFFFF)
		{
			super(bd.rect.width, bd.rect.height, true, 0xFFFFFFFF);
			source = bd;
			apply(o, t, c, m);
		}

		public function apply(o : String, t : uint, c : uint, m : uint) : void
		{
			operation = o;
			_threshold = t;
			color = c;
			mask = m;
			lock();
			reset();
			threshold(source, rect, point, operation, _threshold, color, mask, false);
			unlock();
		}

		public function reset(fill : uint = 0xFFFFFFFF) : void
		{
			fillRect(rect, fill);
		}
	}
}
