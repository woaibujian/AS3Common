package com.merrycat.utils
{
	import flash.geom.Point;

	public class MNumberUtils
	{
		/**
		 * 根据一个区间的起点和终点数来获取源数据的百分比值
		 * @param value 			源数据
		 * @param minimum 			最小值
		 * @param maximum 			最大值
		 * @example
		 * 
		 * MNumberUtils.normalize(5, 0, 10) // 0.5
		 */
		public static function normalize(value : Number, minimum : Number, maximum : Number) : Number
		{
			return (value - minimum) / (maximum - minimum);
		}

		/**
		 * 根据一个区间的起点和终点数来获取百分比值的区间值
		 * @param normValue 		百分比
		 * @param minimum 			最小值
		 * @param maximum 			最大值
		 * @example
		 * 
		 * MNumberUtils.interpolate(0.5, 0, 10) // 5
		 */
		public static function interpolate(normValue : Number, minimum : Number, maximum : Number) : Number
		{
			return minimum + (maximum - minimum) * normValue;
		}

		/**
		 * 根据一个区间的起点和终点数来获取百分比值来应用于令一个区间来获取区间值
		 * @param value 			用来确定百分比的区间值
		 * @param min1 				用来确定百分比的区间最小值
		 * @param max1 				用来确定百分比的区间最大值
		 * @param min2 				用来获取区间值的最小值
		 * @param max2 				用来获取区间值的最大值
		 * @example
		 * 
		 * MNumberUtils.map(5, 0, 10, 0, 100) // 50
		 */
		public static function map(value : Number, min1 : Number, max1 : Number, min2 : Number, max2 : Number) : Number
		{
			return interpolate(normalize(value, min1, max1), min2, max2);
		}

		/**
		 * 返回某一值的取模后的整数部分值
		 * @param value 			源数值
		 * @param step 				去模的数
		 * @example
		 * 
		 * trace( snap( 19, 3 ) );//  18 = 3 * 6 ( + ( 19 % 3 ) = 19 )
		trace( snap( 19, 4 ) );//  16 = 4 * 4 ( + ( 19 % 4 ) = 19 )
		trace( snap( 19, 10 ) );// 10 = 10 * 1 ( + ( 19 % 10 ) = 19 )
		 */
		public static function snap(value : Number, step : Number) : Number
		{
			return int(value / step) * step;
		}

		/**
		 * 返回两点之间的弧度
		 * @param p0 			点1
		 * @param p1 			点2
		 * @example
		 * 
		 * MNumberUtils.angleByRadian(new Point(0, 0), new Point(100, 100)) // 0.7853981633974483
		 */
		public static function angleByRadian(p0 : Point, p1 : Point) : Number
		{
			return Math.atan2(p1.y - p0.y, p1.x - p0.x);
		}

		/**
		 * 返回两点之间的角度
		 * @param p0 			点1
		 * @param p1 			点2
		 * @example
		 * 
		 * MNumberUtils.angleByDegree(new Point(0, 0), new Point(100, 100)) // 45
		 */
		public static function angleByDegree(p0 : Point, p1 : Point) : Number
		{
			return radianToDegree(angleByRadian(p0, p1));
		}

		/**
		 * 弧度转角度
		 * @param radian 		弧度
		 * @example
		 * 
		 * MNumberUtils.radianToDegree(0.7853981633974483) // 45
		 */
		public static function radianToDegree(radian : Number) : Number
		{
			return radian * 180 / Math.PI;
		}

		/**
		 * 角度转弧度
		 * @param degree 		角度
		 * @example
		 * 
		 * MNumberUtils.radianToDegree(45) // 0.7853981633974483
		 */
		public static function degreeToRadian(degree : Number) : Number
		{
			return degree * Math.PI / 180;
		}

		/**
		 * 两点间距离
		 * @param p0 		点1
		 * @param p1 		点2
		 * @example
		 * 
		 * MNumberUtils.distance(new Point(0, 300), new Point(400, 0)) // 500
		 */
		public static function distance( p0:Point, p1:Point ):Number
		{
			return Math.sqrt( squareDistance( p0.x, p0.y, p1.x, p1.y ) );
		}
		
		public static function squareDistance(x0 : Number, y0 : Number, x1 : Number, y1 : Number) : Number
		{
			var dx : Number = x0 - x1;
			var dy : Number = y0 - y1;
			return dx * dx + dy * dy;
		}

		/**
		 * 获取区间数值
		 * @param value 		源数据
		 * @param min 			最小值
		 * @param max 			最大值
		 * @example
		 * 
		 * MNumberUtils.getNumWithRange(1 , 5, 10) // 5
		 */
		public static function getNumWithRange(value : Number, min : Number, max : Number) : Number
		{
			var v : Number = Math.max(value, min);

			if (v != value)
			{
				return min;
			}
			else
			{
				return Math.min(v, max);
			}
		}

		/**
		 * 在tween运算时对于无限接近0的小数直接返回0，默认为绝对值小于0.01的小数
		 * @param value 		源数据
		 * @example
		 * 
		 * MNumberUtils.approximateZero(0.005) // 0
		 */
		public static function approximateZero(value : Number, limit : Number = 0.01) : Number
		{
			if (Math.abs(value) < limit)
			{
				return 0;
			}

			return value;
		}

		/**
		 * 获取区间数值，currIndex限定在startIndex与length - 1之间循环取值
		 * @param currIndex 	当前index值
		 * @param value 		递增或递减值，通常取 1（ADD） or -1（SUBSTRACT）
		 * @param max 		最大值
		 * @param min 	最小值
		 * @example
		 * 
		 * 	MNumberUtils.loopIndex(10, MNumberUtils.ADD, 10) // 0
		MNumberUtils.loopIndex(0, MNumberUtils.SUBSTRACT, 10) // 10
		 */
		public static const ADD : int = 1;
		public static const SUBSTRACT : int = -1;

		public static function loopIndex(currIndex : int, value : int, max : int, min : int = 0) : Number
		{
			var tmpIdx : int = currIndex + value;

			if ((tmpIdx) > max )
			{
				return min;
			}

			if ((tmpIdx) < min )
			{
				return max;
			}

			return tmpIdx;
		}

		/**
		 * 获取区间数值，currIndex限定在startIndex与length - 1之间循环取值，头尾的溢出值会在循环时叠加
		 * @param value 		当前值
		 * @param count 		叠加值
		 * @param max 			最大值
		 * @param min 			最小值
		 * @example
		 * 
		 * MNumberUtils.loopValue(2, -5, 10, 1) // 7
		 * MNumberUtils.loopValue(8, 5, 10, 0) // 2
		 * 			
		 */
		public static function loopValue(value : int, count : int, max : int, min : int = 0) : Number
		{
			var tmpIdx : int = value + count;

			if (count > 0)
			{
				if ((tmpIdx) > max )
				{
					return min + (tmpIdx - max) - 1;
				}
			}

			if (count < 0)
			{
				if ((tmpIdx) < min )
				{
					return max + (tmpIdx - min) + 1;
				}
			}

			return tmpIdx;
		}

		/**
		 * 获取URL地址中的随机数
		MNumberUtils.getNoCacheNum() // 10
		 */
		public static function getNoCacheNum() : Number
		{
			return new Date().getTime();
		}
		
		public static function getSimpleTweenValue(orginValue:Number, toValue:Number, easingNum:Number = 0.1):Number
		{
			return orginValue + (toValue - orginValue)*easingNum; 
		}
	}
}