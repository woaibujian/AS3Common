package com.merrycat.transEffect.transitions
{
	import flash.display.Sprite;

	/**
	 * @author:		Merrycat
	 * @version:	2011-4-4	����06:15:00
	 */
	public class TransMaskBase extends Sprite
	{
		public var onMaskComp : Function;
		
		public var everyduration : uint;
		
		public var transType:int = TransBase.APPEAR;
		
		public function TransMaskBase(everyduration:uint)
		{
			this.everyduration = everyduration;
		}

		public function effect(type:int = TransBase.APPEAR) : void
		{
			transType = type;
		}

		public function close() : void
		{
		}
	}
}
