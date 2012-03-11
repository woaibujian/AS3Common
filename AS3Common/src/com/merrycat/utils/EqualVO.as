package com.merrycat.utils 
{
	import com.merrycat.ValueObject;

	/**
	 * @author jan.bu
	 */
	public class EqualVO extends ValueObject 
	{
		public var id:int;
		public var value:*;
		public var equals:Array;
		public var orginIdx:Array;
		
		public function EqualVO()
		{
			super();
		}
	}
}
