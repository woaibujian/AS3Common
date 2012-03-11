package com.merrycat.utils
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import flash.display.DisplayObject;
	/**
	 * @author:		Merrycat
	 * @version:	2010-12-1	����06:05:29
	 */
	public class MTweenUtils
	{
		public function MTweenUtils()
		{
		}

		public static function autoRemoveTweenTarget(target:DisplayObject, duration:Number = 0.5, vars:Object = null, onCompleteCall:Function = null, onCompleteCallParams:Array = null) : void
		{
			if(!vars)
			{
				vars = {alpha:0};
			}
			
			vars.onComplete = function():void
			{
				onCompleteCall && onCompleteCall.apply(null, onCompleteCallParams);
				
				if (target.parent)
				{
					target.parent.removeChild(target);
//					target = null;
				}
			};
			
			TweenLite.to(target, duration, vars);
		}
		
		public static const FADE_OUT : int = 0;
		public static const FADE_IN: int = 1;
		public static function fadeTargetArr(arr:Array, type:int, duration:Number = 0.5, vars:Object = null) : void
		{
			if(vars)
			{
				vars.autoAlpha = type;
			}else
			{
				vars = {autoAlpha:type};
			}
			
			for (var i : int = 0; i < arr.length; i++)
			{
				TweenMax.to(arr[i], duration, vars);
			}
		}
		
		public static const COMMON_EASE: Function = Cubic.easeInOut;
		public static const COMMON_DURATION: Number = 0.25;
		public static function commonTweenLite(target:DisplayObject, vars:Object) : void
		{
			vars.ease = MTweenUtils.COMMON_EASE;

			TweenLite.to(target, MTweenUtils.COMMON_DURATION, vars);
		}
	}
}
