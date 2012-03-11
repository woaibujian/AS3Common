package com.merrycat.display.plane 
{
	import com.merrycat.display.MFreeTogo;
	import com.merrycat.resize.MResizer;
	import com.merrycat.utils.MNumberUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.casalib.util.StageReference;

	/**
	 * @author:		Merrycat
	 * @createDate:	2010-11-19	下午06:13:18
	 */
	public class MMcPlane extends MPlane 
	{
		private var _mFreeTogo : MFreeTogo;

		public function MMcPlane(target : Sprite)
		{
			super(target);
			
			_mFreeTogo = new MFreeTogo(MovieClip(target));
			
		}
		
		override public function stop(onBackToCenterCall : Function = null) : void 
		{
			super.stop(onBackToCenterCall);
			
			_mFreeTogo.goto(String(Math.floor(yAxisDegree - xAxisDegree) / 2), onAniEnd);
		}

		private function onAniEnd() : void 
		{
			onBackToCenterCall && onBackToCenterCall();
		}

		override protected function onRender(e : Event) : void 
		{
			if(xAxisDegree != 0)
			{
				var frame : Number = yAxisDegree / 2 + (StageReference.getStage().mouseX - MResizer.defaultRect.width / 2) / (StageReference.getStage().stageWidth / 2) * yAxisDegree / 2;
//				trace(MNumberUtils.getNumWithRange(Math.ceil(frame), xAxisDegree, yAxisDegree))
//				MovieClip(target).gotoAndStop(MNumberUtils.getNumWithRange(Math.ceil(frame), xAxisDegree, yAxisDegree));
				
				_mFreeTogo.goto(String(MNumberUtils.getNumWithRange(Math.ceil(frame), xAxisDegree, yAxisDegree)));
			}
		}
	}
}
