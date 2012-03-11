package com.merrycat.mouse
{
	import com.merrycat.utils.MNumberUtils;
	import org.casalib.time.EnterFrame;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author:		Merrycat
	 * @version:	2010-12-7	����07:33:04
	 */
	public class MouseAttractCircle extends MouseAttractBase
	{
		private var _center : Point;
		private var _radius : int;
		private var shape : Shape;
		
		private var _inArea:Boolean = false;
		
		public var beginInAreaCall:Function;
		public var beginInAreaCallParam:Array;
		public var endInAreaCall:Function;
		public var endInAreaCallParam:Array;
		
		public function MouseAttractCircle(asset : Sprite, center:Point, radius:int)
		{
			super(asset);

			_center = center;
			_radius = radius;

			orginX = asset.x;
			orginY = asset.y;
			
//			createTestAreaShape();
		}

		public function changePoint(orginX:Number, orginY:Number):void
		{
			this.orginX = orginX;
			this.orginY = orginY;
		}
		
		override protected function createTestAreaShape() : void
		{
			shape = new Shape();
			shape.graphics.beginFill(0, 0.2);
			shape.graphics.drawCircle(_center.x, _center.y, _radius);
			shape.graphics.endFill();
			
			asset.parent.addChild(shape);
		}
		
		override public function stop() : void
		{
			super.stop();
			
			if(shape && shape.stage)
			{
				asset.parent.removeChild(shape);
			}
		}

		override public function start() : void
		{
			EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, onEf);
		}

		override protected function onEf(e : Event) : void
		{
			if(isInArea())
			{
				inArea = true;
				asset.x += MNumberUtils.approximateZero((asset.parent.mouseX - asset.x) * 0.1); 
				asset.y += MNumberUtils.approximateZero((asset.parent.mouseY - asset.y) * 0.1); 
			}else
			{
				inArea = false;
				asset.x += MNumberUtils.approximateZero((orginX - asset.x) * 0.1);
				asset.y += MNumberUtils.approximateZero((orginY - asset.y) * 0.1); 
			}
		}
		
		override protected function isInArea() : Boolean 
		{
			if(Math.sqrt(Math.pow(asset.parent.mouseY - _center.y, 2) + Math.pow(asset.parent.mouseX - _center.x, 2)) < _radius)
			{
				return true;
			}
			
			return false;
		}
		
		public function set inArea(value:Boolean):void
		{
			if(_inArea && !value)
			{
				beginInAreaCall && beginInAreaCall.apply(null, beginInAreaCallParam);
			}
			
			if(!_inArea && value)
			{
				endInAreaCall && endInAreaCall.apply(null, endInAreaCallParam);
			}
			
			_inArea = value;
		}
		
		public function get inArea():Boolean
		{
			return _inArea;
		}
	}
}
