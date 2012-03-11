package com.merrycat.display.plane 
{
	import com.greensock.TweenLite;
	import com.merrycat.resize.MResizer;

	import org.casalib.util.StageReference;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author:		Merrycat
	 * @createDate:	2010-11-12	下午06:14:50
	 */
	public class MRotatePlane extends MPlane
	{
		private var _ry : Number;
		private var _rx : Number;

		public function MRotatePlane(target : Sprite) 
		{
			super(target);
		}

		override public function stop(onBackToCenterCall:Function = null) : void 
		{
			super.stop();
			TweenLite.to(target, 0.5, {rotationX:0, rotationY:0, onComplete:onBackToCenterCall && onBackToCenterCall()});
		}
		
		override protected function onRender(e : Event) : void 
		{
			if(xAxisDegree != 0)
			{
				_ry = (StageReference.getStage().mouseX - MResizer.defaultRect.width / 2) / (StageReference.getStage().stageWidth / 2) * xAxisDegree;
				target.rotationY += (_ry - target.rotationY) * 0.1; 
			}
			
			if(yAxisDegree != 0)
			{
				_rx = (StageReference.getStage().mouseY - MResizer.defaultRect.height / 2) / (StageReference.getStage().stageHeight / 2) * yAxisDegree;
				target.rotationX += (_rx - target.rotationX) * 0.1; 
			}
		}
	}
}
