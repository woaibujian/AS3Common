package com.merrycat.transEffect.bitmap
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;

	public class Noise extends BitmapData
	{
		// プロパティ
		private var source : BitmapData;
		private var seed : uint;
		private static var low : uint = 0;
		private static var high : uint = 255;
		private var color : ColorTransform;
		private var multiplier : Object = {r:1, g:1, b:1};
		private var offset : Object = {r:0x00, g:0x00, b:0x00};

		// コンストラクタ
		public function Noise(rect : Rectangle, s : uint = 1)
		{
			super(rect.width, rect.height, false, 0xFF000000);
			source = new BitmapData(rect.width, rect.height, false, 0xFF000000);
			create(s);
		}

		// メソッド
		public function create(s : uint) : void
		{
			seed = s;
			if (seed == 0) seed = Math.floor(Math.random() * 1000);
			lock();
			source.noise(seed, low, high, 0, true);
			draw(source);
			unlock();
		}

		public function colorize(m : Object, o : Object) : void
		{
			multiplier = m;
			offset = o;
			color = new ColorTransform(multiplier.r, multiplier.g, multiplier.b, 1, offset.r, offset.g, offset.b, 0);
			lock();
			draw(source, null, color);
			unlock();
		}
	}
}