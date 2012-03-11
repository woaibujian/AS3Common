/**
 * @author	Lzy100% <lzy100w@msn.com>
 * @since	2009-4-1 15:13
 * @version	0.42
 */

/*
说明: 
名称      注解
rollMc    滚动的内容(必须)
maskMc    mask(必须)
rollBar   滚动条(可选)

rollMc,maskMc,rollBar 注册点需要在左上角

EXAMPLES: 

 */
//------此类的修改和引用已获得 原作者:Lzy100%  同意--------
package com.merrycat.ComboBox
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class LiRoll extends EventDispatcher
	{
		/**
		 * 滚动条类
		 * @param	rollMc	滚动MC名称
		 * @param	maskMc	遮罩MC名称
		 * @param	rollBar	滚动条MC名称
		 * @param	horizontal	横向模式
		 */
		public function LiRoll(rollMc : Sprite, maskMc : Sprite,rollBar : Sprite = null,horizontal : Boolean = false)
		{
			$rollMc = rollMc;
			$maskMc = maskMc;
			$rollBar = rollBar;
			_horizontal = horizontal;
			initialize();
		}

		/**
		 * rollMc的easing值
		 */
		public var easing : Number = 0.5;
		/**
		 * 鼠标滚轮的速度
		 */
		public var rollSpeed : Number = 10;
		/**
		 * 是否打开鼠标滚轮
		 */
		public var mouseWheel : Boolean = true;
		/**
		 * 是否实时监测rollMc的高或宽度
		 */
		public var autoUpdate : Boolean = false;
		/**
		 * 是否打开鼠标滚动模式
		 */
		public var mouseMode : Boolean = false;

		private var OldMouseMode : Boolean;
		private var _horizontal : Boolean = false;
		private var HeightOrWidth : String;
		private var YorX : String;
		private var mouseYorX : String;
		private var scaleXorY : String;

		private var $rollMc : Sprite = null;
		private var $maskMc : Sprite = null;
		private var $rollBar : Sprite = null;
		private var $rollBarBounds : Rectangle = null;

		private var currentPercentage : Number = 0;
		private var rollMcMoveRange : Number;
		private var rollBarMoveRange : Number;
		private var rollBarOldXorY : Number;
		private var mouseRectangle : Rectangle;
		private var onClickRollBar : Boolean;

		private var inArea : Boolean;
		private var oldPosition : Boolean = false;

		private function initialize() : void
		{
			//计算横竖
			if (horizontal == false) 
			{
				HeightOrWidth = "height";
				YorX = "y";
				mouseYorX = "mouseY";
				scaleXorY = "scaleY";
			} 
			else 
			{
				HeightOrWidth = "width";
				YorX = "x";
				mouseYorX = "mouseX";
				scaleXorY = "scaleX";
			}
			//计算rollMc
			if ($rollBar != null) 
			{
				if ($rollBarBounds != null) 
				{
					//指定范围时

					rollBarOldXorY = $rollBarBounds[YorX];
					$rollBar.x = $rollBarBounds.x;
					$rollBar.y = $rollBarBounds.y;
					
					//rollBar移动范围
					rollBarMoveRange = numberRange($rollBarBounds[HeightOrWidth] - $rollBar[HeightOrWidth], 0);
					//拖动范围
					mouseRectangle = new Rectangle($rollBarBounds.x, $rollBarBounds.y, rollBarMoveRange, rollBarMoveRange);
					//修正拖动范围
					mouseRectangle[contrast(HeightOrWidth)] = numberRange($rollBarBounds[contrast(HeightOrWidth)] - $rollBar[contrast(HeightOrWidth)], 0);
				}
				else 
				{
					//未指定范围时

					rollBarOldXorY = $rollBar[YorX];
					//
					rollBarMoveRange = numberRange($maskMc[HeightOrWidth] - $rollBar[HeightOrWidth], 0);
					//
					mouseRectangle = new Rectangle($rollBar.x, $rollBar.y, rollBarMoveRange, rollBarMoveRange);
					//
					mouseRectangle[contrast(HeightOrWidth)] = 0;
				}
				
				$rollBar.buttonMode = true;
				
				//事件
				$rollBar.addEventListener(MouseEvent.MOUSE_DOWN, rollBar_MOUSE_DOWN);
				
				$rollBar.stage.addEventListener(MouseEvent.MOUSE_WHEEL, stage_MOUSE_WHEEL);
			}
			$maskMc.stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_MOUSE_MOVE);
			
			update();
			
			//
			//$rollMc.cacheAsBitmap = true;
			//$maskMc.cacheAsBitmap = true;
			$rollMc.mask = $maskMc;//设置mask

			$rollMc[YorX] = $maskMc[YorX];
			
			$rollMc.addEventListener(Event.ENTER_FRAME, ENTER_FRAME_tracking);
		}

		private function stage_MOUSE_MOVE(e : Event) : void
		{
			//计算鼠标是否在显示区域内
			inArea = $maskMc.mouseX > 0 && $maskMc.mouseX * $maskMc.scaleX < $maskMc.width && $maskMc.mouseY > 0 && $maskMc.mouseY * $maskMc.scaleY < $maskMc.height;
			//计算百分比
			if (mouseMode) 
			{
				if (oldPosition == true || inArea) 
				{ 
					oldPosition = inArea;
					currentPercentage = numberRange(($maskMc[mouseYorX] * $maskMc[scaleXorY]) / $maskMc[HeightOrWidth], 0, 1);
				}
			}else if (onClickRollBar && rollBarMoveRange > 0)
			{
				currentPercentage = numberRange(( $rollBar[YorX] - rollBarOldXorY ) / rollBarMoveRange, 0, 1);
			}
		}

		private function rollBar_MOUSE_DOWN(e : Event) : void
		{
			if (rollMcMoveRange > 0) 
			{
				$rollBar.stage.addEventListener(MouseEvent.MOUSE_UP, stage_MOUSE_UP);
				//记录之前鼠标模式状态
				OldMouseMode = mouseMode;
				mouseMode = false;
				$rollBar.startDrag(false, mouseRectangle);
				//trace(mouseRectangle.width,mouseRectangle.height)
				onClickRollBar = true;
			}
		}

		private function stage_MOUSE_UP(e : Event) : void
		{
			//还原之前鼠标模式状态
			$rollBar.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_MOUSE_UP);
			mouseMode = OldMouseMode;
			$rollBar.stopDrag();
			onClickRollBar = false;
		}

		private function stage_MOUSE_WHEEL(e : *) : void 
		{
			if (inArea && mouseWheel) 
			{ 
				roll(e.delta * rollSpeed);
			}
		}

		/**
		 * 滚动指定的像素
		 * @param	num	指定滚动的距离
		 */
		public function roll(num : Number) : void 
		{
			if ( rollMcMoveRange > 0) 
			{
				currentPercentage = numberRange(currentPercentage - (num / rollMcMoveRange), 0, 1);
			}
		}

		private function ENTER_FRAME_tracking(e : *) : void
		{
			autoUpdate && update();
			//移动rollMc
			$rollMc[YorX] -= ($rollMc[YorX] - ($maskMc[YorX] - rollMcMoveRange * currentPercentage)) * easing;
			$rollBar != null && ($rollBar[YorX] = rollBarOldXorY + rollBarMoveRange * currentPercentage);
		}

		/**
		 *清除LiRoll
		 */
		public function clear() : void
		{
			if ($rollBar != null) 
			{
				$rollBar.buttonMode = false;
				$rollBar.removeEventListener(MouseEvent.MOUSE_DOWN, rollBar_MOUSE_DOWN);
				$rollBar.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_MOUSE_UP);
				$rollBar.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, stage_MOUSE_WHEEL);
			}
			$rollMc.mask = null;
			//$rollMc.cacheAsBitmap = false;
			//$maskMc.cacheAsBitmap = false;
			$maskMc.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_MOUSE_MOVE);
			$rollMc.removeEventListener(Event.ENTER_FRAME, ENTER_FRAME_tracking);
		}

		/**
		 *重新计算rollMc的高或宽度
		 */
		public function update() : void
		{
			rollMcMoveRange = numberRange($rollMc[HeightOrWidth] - $maskMc[HeightOrWidth], 0);
			rollMcMoveRange == 0 && (currentPercentage = 0);
		}

		/**
		 *设置rollBar
		 */
		public function set rollBar(value : Sprite) : void 
		{
			clear();
			$rollBar = value;
			initialize();
		}

		/**
		 *取得rollBar
		 */
		public function get rollBar() : Sprite
		{
			return $rollBar; 
		}

		/**
		 *以Rectangle的大小设置rollbar滚动区域
		 */
		public function set rollBarBounds(value : Rectangle) : void 
		{
			clear();
			$rollBarBounds = value;
			initialize();
		}

		/**
		 *取得rollbar滚动区域
		 */
		public function get rollBarBounds() : Rectangle
		{
			return $rollBarBounds; 
		}

		/**
		 *以mc的大小设置rollbar滚动区域
		 */
		public function set rollBarBoundsMc(value : Sprite) : void 
		{
			clear();
			$rollBarBounds = new Rectangle(value.x, value.y, value.width, value.height);
			initialize();
		}

		/**
		 * 设置横向模式
		 */
		public function set horizontal(value : Boolean) : void 
		{
			clear();
			_horizontal = value;
			initialize();
		}

		/**
		 * 取得当前是否为横向模式
		 */
		public function get horizontal() : Boolean
		{
			return _horizontal; 
		}

		/**
		 * 设置滚动半分比1为100%,0为0%.
		 */
		public function set percentage(p : Number) : void 
		{
			currentPercentage = numberRange(p, 0, 1);
		}

		/**
		 * 取得当前百分比
		 */
		public function get percentage() : Number
		{
			return currentPercentage;
		}

		private function numberRange(value : Number, min : Number = NaN, max : Number = NaN) : Number
		{
			if (value < min) 
			{
				return min;
			} else if (value > max) 
			{
				return max;
			} 
			else 
			{
				return value;
			}
		}

		/**
		 * 返回项对应的参数
		 * @param	word	需要变换的字符串
		 * @return
		 */
		private function contrast(word : String) : String
		{
			var wordArr1 : Array = ["height", "x", "up", "left", "front","true","0","scaleX"];
			var wordArr2 : Array = ["width", "y", "down", "right", "back","false","1","scaleY"];
			if (wordArr1.indexOf(word) != -1) 
			{
				return wordArr2[wordArr1.indexOf(word)];
			}else if (wordArr2.indexOf(word) != -1) 
			{
				return wordArr1[wordArr2.indexOf(word)];
			}
			else 
			{
				return null;
			}
		}
	}
}