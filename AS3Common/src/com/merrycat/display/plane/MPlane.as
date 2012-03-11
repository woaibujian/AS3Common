package com.merrycat.display.plane 
{
	import com.merrycat.utils.MNumberUtils;
	import org.casalib.time.EnterFrame;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Jan.Bu
	 */
	public class MPlane 
	{
		public var target : Sprite;
		public var xAxisDegree : Number;
		public var yAxisDegree : Number;
		
		protected var onBackToCenterCall:Function;

		public function MPlane(target : Sprite) 
		{
			this.target = target;
			this.target.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}

		public function start(xAxisDegree:Number = 0, yAxisDegree:Number = 0) : void 
		{
			this.xAxisDegree = MNumberUtils.getNumWithRange(xAxisDegree, 0, Number.POSITIVE_INFINITY);
			this.yAxisDegree = MNumberUtils.getNumWithRange(yAxisDegree, 0, Number.POSITIVE_INFINITY);
			
			EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, onRender);
		}

		public function stop(onBackToCenterCall:Function = null) : void 
		{
			this.onBackToCenterCall = onBackToCenterCall;
			EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onRender);
		}
		
		protected function onRender(e : Event) : void 
		{
		}
		
		protected function onRemove(e : Event) : void 
		{
			EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onRender);
		}
	}
}
