package com.merrycat.utils
{
	import com.merrycat.ViewBase;
	import com.greensock.TweenLite;

	import org.casalib.time.EnterFrame;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	/**
	 * @author:		Merrycat
	 * @version:	2010-11-26	����10:49:44
	 * @decs		创建无限衔接移动动画，目前只支持横向移动
	 */
	public class MOneByOne extends ViewBase
	{
		private var _leftTarget : Sprite;
		private var _rightTarget : Sprite;
		private var _autoMaskRect : Rectangle;
		private var _mask : Sprite;
		private var _speed : Number;
		private var _tweenObj : TweenObj;
		
		private var _delta : Number;
		private var _offsetPos : Number;
		
		private var _state:String = STOP;
		
		private var _singleWidth : Number;
		
		public static const RUNING : String = "runing";
		public static const BEGIN_STOP : String = "beginStop";
		public static const STOP : String = "stop";
		
		/**
		 * 构造函数
		 * @param targetCont 		承载对象
		 * @param targetClass 		无限移动单个对象类
		 * @param offsetPos 		起始偏移位置
		 * @param customWidth 		使用自定义宽度，用于计算衔接位置
		 * @param autoMaskRect 		自动创建遮罩，并指定遮罩区域
		 */
		public function MOneByOne(targetCont : Sprite, targetClass : Class, offsetPos : Number = 0, customWidth : Number = NaN, autoMaskRect : Rectangle = null)
		{
			super(targetCont);
			
			_offsetPos = offsetPos;
			
			_autoMaskRect = autoMaskRect;

			if (isNaN(customWidth))
			{
				_singleWidth = _leftTarget.width;
			}else
			{
				_singleWidth = customWidth;
			}
			
			if(autoMaskRect)
			{
				_mask = new Sprite();
				_mask.graphics.beginFill(0, 0.3);
				_mask.graphics.drawRect(autoMaskRect.x, autoMaskRect.y, autoMaskRect.width, autoMaskRect.height);
				_mask.graphics.endFill();
				asset.parent.addChild(_mask);
	
				asset.mask = _mask;
			}
			
			_leftTarget = new targetClass();
			_leftTarget.x = -_singleWidth;
			asset.addChild(_leftTarget);
			
			_rightTarget = new targetClass();
			asset.addChild(_rightTarget);
			
			asset.x = _offsetPos;
		}
		
		/**
		 * 开始移动
		 * @param speed 		移动速度
		 */
		public function startMove(speed:Number) : void
		{
			_speed = speed;
			
			if(_state == MOneByOne.STOP)
			{
				_state = MOneByOne.RUNING;
				EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, onEf);
				if (_speed < 0)
				{
					asset.x = _singleWidth - _offsetPos;
				}
			}
		}
		
		/**
		 * 停止移动
		 * @param time 		移动放慢到停止的时间，单位：秒
		 * @param ease 		缓动方式（Greensock）
		 */
		public function stopMove(time:Number, ease:Function = null) : void
		{
			if(_state == MOneByOne.RUNING)
			{
				_tweenObj = new TweenObj();
				_tweenObj.speed = _speed;
				TweenLite.to(_tweenObj, time, {speed:0, ease:ease});
				_state = MOneByOne.BEGIN_STOP;
			}
		}
		
		/**
		 * 改变移动速度（亦可改变方向）
		 * @param speed 		移动速度
		 */
		public function changeSpeed(speed : Number) : void 
		{
			_speed = speed;
		}
		
		/**
		 * 移动到某一位置，待完成
		 * @param pos 		位置
		 */
		public function moveTo(pos:Number) : void
		{
		}
		
		private function onEf(e : Event) : void
		{
			switch(_state)
			{
				case MOneByOne.RUNING:
					
					break;
				case MOneByOne.BEGIN_STOP:
					_speed = _tweenObj.speed;
					break;
				default:
			}
			
			asset.x += _speed;
			
			if(_speed > 0)
			{
				if (asset.x > _singleWidth)
				{
					_delta = asset.x - _singleWidth;
					asset.x = _delta;
				}
			}
			else if (_speed < 0)
			{
				if (asset.x < 0)
				{
					_delta = asset.x;
					asset.x = _singleWidth + _delta;
				}
			}
			
			if(_speed == 0)
			{
				EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEf);
				_state = MOneByOne.STOP;
			}
		}
		
		public function get speed() : Number 
		{
			return _speed;
		}

		override public function destory(e : Event = null) : void
		{
			EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEf);
			super.destory(e);
		}
	}
}

/**
 * @author MCat
 */
class TweenObj
{
	public var speed : Number = 0;
}
