package com.merrycat.resize 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import com.merrycat.ValueObject;

	/**
	 * @author merrycat
	 * 
	 * 带有属性的屏幕缩放对象（配合MResizer使用）
	 * 
	 * @see MResizer
	 */
	public class MResizerVO extends ValueObject 
	{
		/**
		 * 普通对齐模式
		 */
		public static const ALIGN_BY_VALUE:String = "Align_By_Value";
		
		/**
		 * 缩放适应最小边
		 */
		public static const SCALE_WITH_MIN:String = "ScaleWithMin";
		
		/**
		 * 缩放适应最小边
		 */
		public static const SCALE_WITH_MAX:String = "ScaleWithMax";
		
		/**
		 * 百分比对齐模式
		 */
		public static const ALIGN_BY_PERCENT:String = "Align_By_Percent";
		
		/**
		 * 绑定某一缩放对象中的一个点坐标
		 */
		public static const BIND_POINT:String = "Bind_Point";
		
		/**
		 * 监听舞台缩放的显示对象
		 */
		public var target:DisplayObject;
		
		/**
		 * 普通对齐模式时
		 * 指定的X坐标偏移值（参照设置舞台上的坐标即可）
		 */
		public var x:Number;
		
		/**
		 * 普通对齐模式时 
		 * 指定的Y坐标偏移值（参照设置舞台上的坐标即可）
		 */
		public var y:Number;
		
		public var reviseX:int = 1;
		public var reviseY:int = 1;
		
		/**
		 * 缩放模式时 
		 * 计算出的高/宽比
		 */
		public var targetScale:Number;
		
		/**
		 * 百分比对齐模式时 
		 * 横向所处屏幕的百分比位置
		 */
		public var percentX:Number;
		
		/**
		 * 百分比对齐模式时 
		 * 纵向所处屏幕的百分比位置
		 */
		public var percentY:Number;
		
		/**
		 * 对齐参照对象
		 */
		public var refTarget:DisplayObjectContainer;
		
		/**
		 * 当前舞台缩放后执行运算的类型
		 */
		public var type:String;
		
		/**
		 * 是否坐标取整
		 */
		public var roundCoordinate : Boolean;
		
		/**
		 * ALIGN_BY_PERCENT时，限定目标对象距离舞台边界的像素值距离
		 */
		public var limit : Number = 0;
		public var limitX : Number = 0;
		public var limitY : Number = 0;
		
		/**
		 * 不计算边界限定常量
		 */
		public static const LIMIT_NONE : int = -1;
		
		public var offX : Number;
		public var offY : Number;
		
		/**
		 * 带有属性的屏幕缩放对象
		 * 
		 * @param	target			监听舞台缩放的显示对象
		 * @param	vars			带入的初始化变量可选值（x, y, refTarget） x,y皆为target具体坐标 
		 * 							当type == ALIGN_BY_PERCENT时自动计算宽高百分比, refTarget为参照对象
		 * @param	type			当前舞台缩放后执行运算的类型，默认为普通对齐模式
		 * @param	roundValue		是否对坐标值取整
		 */
		public function MResizerVO(target:DisplayObject, vars:Object, type:String = ALIGN_BY_VALUE, roundCoordinate:Boolean = true)
		{
			super();
			
			switch(type)
			{
				case ALIGN_BY_VALUE:
					x = vars.x; 
					y = vars.y; 
					break; 
					
				case SCALE_WITH_MAX:
				
					break;
					
				case SCALE_WITH_MIN:
				
					break;
					
				case ALIGN_BY_PERCENT:
				
					refTarget = vars.refTarget;
					
					if(!isNaN(vars.limit)) 
						limit = vars.limit;
						
					if(!isNaN(vars.limitX)) 
						limitX = vars.limitX;
						
					if(!isNaN(vars.limitY)) 
						limitY = vars.limitY;
						
					if (isNaN(vars.limitX) && isNaN(vars.limitY) && !isNaN(vars.limit))
					{
						limitX = limitY = limit;
					}
					
					//如果未设置则默认为parent
					if(!refTarget && target.parent)
					{
						refTarget = target.parent;
					}
					
//					var toX : Number = ( vars.x / MResizer.getInstance().defaultRect.width ) * parent.width;
//					var toY : Number = ( vars.y / MResizer.getInstance().defaultRect.height ) * parent.height;
//					
					//适用全屏尺寸
					if(vars.x)
					{
						percentX = vars.x / MResizer.defaultRect.width;
					}
					
					if(vars.y)
						percentY = vars.y / MResizer.defaultRect.height;
						
//					if(vars.x)
//						percentX = vars.x / parent.width;
//					
//					if(vars.y)
//						percentY = vars.y / parent.height;
					
					break;
					
				case BIND_POINT:
				
					if(!vars.refTarget)
					{
						throw new Error("must a refTarget");
					}
					
					refTarget = vars.refTarget;
					
					x = vars.x; 
					y = vars.y; 
					
					offX = vars.offX; 
					offY = vars.offY; 
					
					if(!isNaN(vars.limit)) 
						limit = vars.limit;
						
					if(!isNaN(vars.limitX)) 
						limitX = vars.limitX;
						
					if(!isNaN(vars.limitY)) 
						limitY = vars.limitY;
						
					if (isNaN(vars.limitX) && isNaN(vars.limitY) && !isNaN(vars.limit))
					{
						limitX = limitY = limit;
					}
					
					if(!x)
						x = 0;						
					
					if(!y)
						y = 0;
												
					if(!offX)
						offX = 0;
												
					if(!offY)
						offY = 0;		
						
					break;
			}
			
			this.target = target;
			this.type = type;
			this.roundCoordinate = roundCoordinate;
		}
	}
}
