package com.merrycat.effect
{
	import flash.events.Event;
	import org.casalib.time.EnterFrame;
	import flash.display.Sprite;
	import com.merrycat.ViewBase;
	/**
	 * @author:		Merrycat
	 * @createDate:	2011-4-7	����10:31:46
	 */
	public class ShakeEff extends ViewBase
	{
		private var _orginX : Number;
		private var _orginY : Number;
		private var _orginRot : Number;
		private var _degree : Number;
		
		public function ShakeEff(asset:Sprite)
		{
			super(asset);
			
			_orginX = asset.x;
			_orginY = asset.y;
			_orginRot = asset.rotation;
		}

		public function start(degree:Number = 2) : void
		{
			_degree = degree;
			EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, shake);
		}

		public function stop() : void
		{
			asset.x = _orginX;
            asset.y = _orginY;
            asset.rotation = _orginRot;
            
            EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, shake);
		}

		private function shake(e : Event) : void
		{
			asset.x = _orginX + Math.random()*_degree - 1;
            asset.y = _orginY + Math.random()*_degree - 1;
            asset.rotation = _orginRot + Math.random()*_degree - 1;
		}

		override public function destory(e : Event = null) : void
		{
			super.destory(e);
			
			stop();
		}
	}
}
