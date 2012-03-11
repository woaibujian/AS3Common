package com.merrycat.utils
{
	import flash.geom.Rectangle;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	/**
	 * @author:		Merrycat
	 * @version:	2010-12-10	����01:04:03
	 */
	public class PointConversion
	{
		/**
		 * 获取在target中相对于ref对象的坐标。
		 * @param target 			实际对象
		 * @param ref 				用于计算的相对对象
		 * @param refPoint 			相对对象中的坐标点
		 * 
		 * @example
		 * 
		 * PointConversion.refToTarget(target, ref, new Point(10, 10)) // 20, 20;
		 */
		public static function refToTarget(target:DisplayObjectContainer, ref:DisplayObjectContainer, refPoint:Point) : Point
		{
			return target.globalToLocal(ref.localToGlobal(refPoint));
		}
		
		/**
		 * 判断一个点坐标是否在一个矩形区域内
		 * @param p 			点
		 * @param rect 			矩形区域
		 * 
		 * @example
		 * 
		 * PointConversion.isPointInRect(new Point(10, 10), new Rectangle(0,0,100,100)) // true
		 */
		public static function isPointInRect(p:Point, rect:Rectangle):Boolean
		{
			if(p.x >= rect.x && p.x <= rect.x + rect.width && p.y >= rect.y && p.y <= rect.y + rect.height)
			{
				return true;
			}
			
			return false;
		}
	}
}
