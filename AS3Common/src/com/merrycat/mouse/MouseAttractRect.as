package com.merrycat.mouse
{
	import flash.display.Shape;
	import flash.events.Event;
	import org.casalib.time.EnterFrame;
	import flash.geom.Rectangle;

	import com.merrycat.ViewBase;

	import flash.display.Sprite;

	/**
	 * @author:		Merrycat
	 * @version:	2010-12-7	����03:00:26
	 * 
	 * 未完成
	 */
	public class MouseAttractRect extends MouseAttractBase
	{
		private var _areaRect : Rectangle;
		
		private var _toX : Number;
		private var _toY : Number;

		public function MouseAttractRect(asset : Sprite, areaRect : Rectangle = null, activePading : int = 10)
		{
			super(asset);

			if (!areaRect)
			{
				areaRect = new Rectangle(asset.x - activePading, asset.y - activePading, asset.width + activePading * 2, asset.height + activePading * 2);
			}else
			{
				areaRect = new Rectangle(areaRect.x - activePading, areaRect.y - activePading, areaRect.width + activePading * 2, areaRect.height + activePading * 2);
			}

			_areaRect = areaRect;
			
			createTestAreaShape();
		}

		override protected function createTestAreaShape() : void
		{
			var shape : Shape = new Shape();
			shape.graphics.beginFill(0, 0.2);
			shape.graphics.drawRect(_areaRect.x, _areaRect.y, _areaRect.width, _areaRect.height);
			shape.graphics.endFill();

			asset.parent.addChild(shape);
		}

		override public function start() : void
		{
			EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, onEf);
		}

		override protected function onEf(e : Event) : void
		{
			if(!isInArea())
			{
				_toX = asset.parent.mouseX;
				_toY = asset.parent.mouseY;
			}else
			{
			}
		}
		
		override protected function isInArea() : Boolean 
		{
			if(asset.parent.mouseX >= _areaRect.x 
				&& asset.parent.mouseX <= _areaRect.x + _areaRect.width  
				&& asset.parent.mouseY >= _areaRect.y 
				&& asset.parent.mouseY <= _areaRect.y + _areaRect.height
				)
			{
				return true;
			}
			return false;
		}
	}
}
