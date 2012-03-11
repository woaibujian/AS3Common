package com.merrycat.utils
{
	import flash.display.Sprite;
	/**
	 * @author Administrator
	 */
	public class TransformClone
	{
		
		public static function basicClone(target:Sprite, ref:Sprite):void
		{
			target.x = ref.x;
			target.y = ref.y;
			target.rotation = ref.rotation;
		}
	}
	
}
