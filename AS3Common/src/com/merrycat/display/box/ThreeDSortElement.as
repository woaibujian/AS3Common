package
com.merrycat.display.box{
	import flash.display.Sprite;

	public final class ThreeDSortElement
	{
		public var z : Number;
		public var child : Sprite;

		public function ThreeDSortElement(depth : Number, s : Sprite)
		{
			z = depth;
			child = s;
		};
	}
}