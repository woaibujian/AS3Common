package com.merrycat.load
{
	import flash.display.BlendMode;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import com.merrycat.resize.MResizer;

	import org.casalib.math.Percent;
	import org.casalib.time.Interval;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author merrycat
	 * 加载进度类，环状圆呈现
	 */
	public class CircleLoadUI implements IPreLoadUI
	{
		private var _center : Point;
		private var _loadInterval : Interval;
		private var _currCircleIdx : int = 0;
		private var _circles : Array;
		private var _circleCont : Sprite;
		private var _parent : DisplayObjectContainer;
		private var _autoRemove : Boolean;

		/**
		 * 构造函数
		 * @example
		 * <listing version="3.0">
		 * var loader:SwfLoad = new SwfLoad("demo.swf");
		 * var loadingUI:CircleLoadUI = new CircleLoadUI(StageReference.getStage());
		 * var preLoad:PreLoad = new PreLoad(loadingUI, loader, loadComp);
		 * 
		 * function loadComp():void{}
		 * </listing>
		 * 
		 * @param	parent			承载对象
		 */
		public function CircleLoadUI(parent : DisplayObjectContainer, color:uint = 0xFFFFFF, autoRemove:Boolean = true, circleScale:Number = 1)
		{
			_parent = parent;
			
			_autoRemove = autoRemove;
			
			var rect:Rectangle;
			if(parent is Stage)
			{
				rect = new Rectangle(0, 0, MResizer.defaultRect.width, MResizer.defaultRect.height);
				_center = new Point(rect.width / 2, rect.height / 2);
			}else
			{
				rect = parent.getRect(parent);
				_center = new Point(rect.x + rect.width / 2, rect.y + rect.height / 2);
			}
			
			_circleCont = new Sprite();
			_circleCont.x = _center.x;
			_circleCont.y = _center.y;
			_circleCont.scaleX = _circleCont.scaleY = circleScale;
			if(_autoRemove)
			{
				_circleCont.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			}
			
			var circle : Sprite;
			
			_circles = [];
			
			for(var i : int = 0;i < 10;i++ )
			{
				circle = new Sprite();
				circle.graphics.beginFill(color);
				circle.graphics.drawCircle(0, 0, 4);
				circle.graphics.endFill();
				
				circle.x = Math.cos(Math.PI / 180 * 36 * i) * 16;
				circle.y = Math.sin(Math.PI / 180 * 36 * i) * 16;
				circle.alpha = 0;
				_circleCont.addChild(circle);
				
				_circles[ i ] = circle;
			}
			
			_loadInterval = Interval.setInterval(circleShow, 80);
			_loadInterval.start();
			
			parent.addChild(_circleCont);
		}

		private function onRemove(e : Event = null) : void 
		{
			remove();
		}
		
		public function remove() : void 
		{
			_circleCont.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			if(_parent.contains(_circleCont))
			{
				_parent.removeChild(_circleCont);
			}
			destory();
		}
		
		private function circleShow() : void
		{
			var circle : Sprite = _circles[ _currCircleIdx ];
			TweenLite.to(circle, 0.3, { alpha:0.5, onComplete:circleHide, onCompleteParams:[circle] });
			
			_currCircleIdx++;
			if(_currCircleIdx == 10)
			{
				_currCircleIdx = 0;
			}
		}

		private function circleHide(circle : Sprite) : void
		{
			TweenLite.to(circle, 0.3, { alpha:0, delay:0.2 });
		}

		public function destory() : void
		{
			_loadInterval.destroy();
		}
		
		public function set currPercent( p : Percent ):void
		{
		}
		
		/**
		 * 返回该类的显示对象
		 * 
		 * @return						显示对象
		 */
		public function get dispUI() : DisplayObject
		{
			return _circleCont;
		}
	}
}