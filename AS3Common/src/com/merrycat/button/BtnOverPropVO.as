package com.merrycat.button
{
	import flash.geom.Point;
	import com.merrycat.ValueObject;

	/**
	 * @author Administrator
	 */
	public class BtnOverPropVO extends ValueObject
	{
		public var color : uint;
		public var offset : Point;
		public function BtnOverPropVO()
		{
			super();
		}
	}
}
