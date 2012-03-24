package com.merrycat.display.plane 
{
	import flash.geom.Point;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;
	import com.merrycat.resize.MResizer;

	import org.casalib.util.StageReference;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author:		Merrycat
	 * @createDate:	2010-11-15	下午02:32:44
	 * _mMovePlane = new MMovePlane(v.charactor);
			_mMovePlane.start(10);
	 */
	public class MMovePlane extends MPlane 
	{
		private var _y : Number;
		private var _x : Number;
		
		private var _orginX : Number;
		private var _orginY : Number;
		private var _reverse : Boolean;
		
		private var _customContainer : DisplayObjectContainer;
		private var _customRect : Rectangle;
		
		public function MMovePlane(target : Sprite, reverse:Boolean = false, customContainer:DisplayObjectContainer = null, customRect:Rectangle = null)
		{
			super(target);
			
			if(customRect)
			{
				_customRect = customRect;	
			}
			
			if(customContainer)
			{
				_customContainer = customContainer;
				if(!_customRect)
				{
					_customRect = new Rectangle(_customContainer.x, _customContainer.y, _customContainer.width, _customContainer.height);
				}
			}
			
			_x = target.x;
			_y = target.y;
			
			_reverse = reverse;
			
			_orginX = _x;
			_orginY = _y;
		}

		override public function stop(onBackToCenterCall:Function = null) : void 
		{
			super.stop();
			TweenLite.to(target, 0.5, {x:_orginX, y:_orginY, onComplete:onBackToCenterCall && onBackToCenterCall()});
		}
		
		override protected function onRemove(e : Event) : void
		{
			super.onRemove(e);
			
			TweenLite.killTweensOf(target);
		}
		
		override protected function onRender(e : Event) : void 
		{
			var mousex:Number;
			var mousey:Number;
			var maxw:Number;
			var maxh:Number;
			
			var center:Point;
			
			if(_customContainer)
			{
				mousex = _customContainer.mouseX;
				if(mousex < 0) mousex = 0;
				
				mousey = _customContainer.mouseY;
				if(mousey < 0) mousey = 0;
				
				maxw = _customRect.width;
				maxh = _customRect.height;
				
				center = new Point(maxw / 2, maxh / 2);
			}else
			{
				mousex = StageReference.getStage().mouseX;
				mousey = StageReference.getStage().mouseY;
				maxw = StageReference.getStage().stageWidth;
				maxh = StageReference.getStage().stageHeight;
				center = new Point(MResizer.defaultRect.width / 2, MResizer.defaultRect.height / 2);
			}
			
			if(xAxisDegree != 0)
			{
				if(!_reverse)
				{
					_x = _orginX - (mousex - maxw / 2) / (maxw / 2) * xAxisDegree;
				}else
				{
					_x = _orginX + (mousex - maxw / 2) / (maxw / 2) * xAxisDegree;
				}
				target.x += (_x - target.x) * 0.1; 
			}
			
			if(yAxisDegree != 0)
			{
				if(!_reverse)
				{
					_y = _orginY - (mousey - maxh / 2) / (maxh / 2) * yAxisDegree;
				}else
				{
					_y = _orginY + (mousey - maxh / 2) / (maxh / 2) * yAxisDegree;
				}
				target.y += (_y - target.y) * 0.1; 
			}
		}
	}
}
