package com.merrycat.transEffect
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����03:03:11
	 */
	public class ColorManager
	{
		private static var rs : Number = 0.3086;
		private static var gs : Number = 0.6094;
		private static var bs : Number = 0.0820;

		public function ColorManager()
		{
		}

		public static function brightOffset(target : DisplayObject, param : Number) : void
		{
			target.transform.colorTransform = getBrightOffset(param);
		}

		private static function getBrightOffset(param : Number) : ColorTransform
		{
			var percent : Number = 1;
			var offset : Number = param * 2.55;
			var colorTrans : ColorTransform = new ColorTransform(0, 0, 0, 1, 0, 0, 0, 0);
			colorTrans.redMultiplier = percent;
			colorTrans.greenMultiplier = percent;
			colorTrans.blueMultiplier = percent;
			colorTrans.redOffset = offset;
			colorTrans.greenOffset = offset;
			colorTrans.blueOffset = offset;
			colorTrans.alphaMultiplier = 1;
			colorTrans.alphaOffset = 0;
			return colorTrans;
		}

		public static function saturation(target : DisplayObject, param : Number) : void
		{
			target.filters = [getSaturation(param)];
		}

		private static function getSaturation(param : Number) : ColorMatrixFilter
		{
			var colorMatrix : ColorMatrixFilter = new ColorMatrixFilter();
			var p : Number = param * 0.01;
			var r : Number = (1 - p) * rs;
			var g : Number = (1 - p) * gs;
			var b : Number = (1 - p) * bs;
			var matrix : Array = [r + p, g, b, 0, 0, r, g + p, b, 0, 0, r, g, b + p, 0, 0, 0, 0, 0, 1, 0];
			colorMatrix.matrix = matrix;
			return colorMatrix;
		}
	}
}
