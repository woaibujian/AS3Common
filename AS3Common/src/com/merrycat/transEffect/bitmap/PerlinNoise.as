package com.merrycat.transEffect.bitmap
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.ColorTransform;

	public class PerlinNoise extends BitmapData
	{
		// プロパティ
		private var source : BitmapData;
		private var base : uint;
		private var octaves : uint;
		private var seed : uint;
		private static var point : Point = new Point();
		private var offsets : Array = [point, point];
		private var color : ColorTransform;
		private var multiplier : Object = {r:1, g:1, b:1};
		private var offset : Object = {r:0x00, g:0x00, b:0x00};

		// コンストラクタ
		public function PerlinNoise(rect : Rectangle, b : uint = 20, o : uint = 2, s : uint = 1)
		{
			super(rect.width, rect.height, false, 0xFF000000);
			source = new BitmapData(rect.width, rect.height, false, 0xFF000000);
			create(b, o, s);
		}

		// メソッド
		public function create(b : uint, o : uint, s : uint) : void
		{
			base = b;
			octaves = o;
			seed = s;
			if (seed == 0) seed = Math.floor(Math.random() * 1000);
			lock();
			source.perlinNoise(base, base, octaves, seed, false, true, 0, true, offsets);
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