package com.merrycat.display.plane 
{
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
		
		public function MMovePlane(target : Sprite, reverse:Boolean = false)
		{
			super(target);
			
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
			if(xAxisDegree != 0)
			{
				if(!_reverse)
				{
					_x = _orginX - (StageReference.getStage().mouseX - MResizer.defaultRect.width / 2) / (StageReference.getStage().stageWidth / 2) * xAxisDegree;
				}else
				{
					_x = _orginX + (StageReference.getStage().mouseX - MResizer.defaultRect.width / 2) / (StageReference.getStage().stageWidth / 2) * xAxisDegree;
				}
				target.x += (_x - target.x) * 0.1; 
			}
			
			if(yAxisDegree != 0)
			{
				if(!_reverse)
				{
					_y = _orginY - (StageReference.getStage().mouseY - MResizer.defaultRect.height / 2) / (StageReference.getStage().stageHeight / 2) * yAxisDegree;
				}else
				{
					_y = _orginY + (StageReference.getStage().mouseY - MResizer.defaultRect.height / 2) / (StageReference.getStage().stageHeight / 2) * yAxisDegree;
				}
				target.y += (_y - target.y) * 0.1; 
			}
		}
	}
}
