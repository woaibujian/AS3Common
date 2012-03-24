package com.merrycat.utils
{
	import flash.geom.Point;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	/**
	 * @author:		Merrycat
	 * @createDate:	2011-8-24	����11:41:17
	 */
	public class Disp2
	{
		public static function addChildAbove(target:DisplayObject, parent:DisplayObjectContainer, referTarget:DisplayObject) : void
		{
			var parentIdx : int = parent.getChildIndex(referTarget);
			var toIdx : int = parentIdx + 1;
			parent.addChildAt(target, toIdx);
		}
		
		public static function addChildUnder(target:DisplayObject, parent:DisplayObjectContainer, referTarget:DisplayObject) : void
		{
			var parentIdx : int = parent.getChildIndex(referTarget);
			
			var toIdx : int = parentIdx;
			if(toIdx < 0)
			{
				toIdx = 0;
			}
			parent.addChildAt(target, toIdx);
		}
		
		public static function setChildAbove(target:DisplayObject, parent:DisplayObjectContainer, referTarget:DisplayObject) : void
		{
			var parentIdx : int = parent.getChildIndex(referTarget);
			var toIdx : int = parentIdx + 1;
			parent.setChildIndex(target, toIdx);
		}
		
		public static function setChildUnder(target:DisplayObject, parent:DisplayObjectContainer, referTarget:DisplayObject) : void
		{
			var parentIdx : int = parent.getChildIndex(referTarget);
			var toIdx : int = parentIdx - 1;
			if(toIdx < 0)
			{
				toIdx = 0;
			}
			parent.addChildAt(target, toIdx);
		}
		
		public static function setChildTop(target:DisplayObject, parent:DisplayObjectContainer) : void
		{
			parent.addChildAt(target, parent.numChildren - 1);
		}

		public static function centerChildren(target:DisplayObjectContainer, drawRect:Boolean = false) : void
		{
			var sideRect : Rectangle = new Rectangle();
			var children : Array = [];
			var child : DisplayObject;
			var tmpi:int;
			var orginPos:Array = [];
			var leftChild:DisplayObject;
			var topChild:DisplayObject;
			
			var dists:Array = [];
			
			for (tmpi = 0; tmpi < target.numChildren; tmpi++) 
			{
				child = target.getChildAt(tmpi);
				children[tmpi] = child;

				var orginPoint : Point = new Point(child.x, child.y);
				orginPos[tmpi] = orginPoint;
				
				if(sideRect.left > child.x)
				{
					sideRect.left = child.x;
					leftChild = child;
				}
				
				if(sideRect.right < child.x + child.width)
				{
					sideRect.right = child.x + child.width;
				}
				
				if(sideRect.top > child.y)
				{
					sideRect.top = child.y;
					topChild = child;
				}
				
				if(sideRect.bottom < child.y + child.height)
				{
					sideRect.bottom = child.y + child.height;
				}
			}
			for (tmpi = 0; tmpi < orginPos.length; tmpi++) 
			{
				var p : Point = orginPos[tmpi];

				var dist : Point = new Point(p.x - leftChild.x, p.y - topChild.y); 
				dists[tmpi] = dist;
			}
			
			var offX : Number = - (sideRect.right - sideRect.left)/2;
			var offY : Number = - (sideRect.bottom - sideRect.top)/2;
			
			for (tmpi = 0; tmpi < children.length; tmpi++) 
			{
				child = children[tmpi];
				child.x = offX + dists[tmpi].x;
				child.y = offY + dists[tmpi].y;
			}
			if(drawRect)
			{
				var rectShape : Shape = new Shape();
				rectShape.graphics.lineStyle(1, 0xff0000);
				rectShape.graphics.beginFill(0, 0);
				rectShape.graphics.drawRect(target.getRect(target).x, target.getRect(target).y, target.getRect(target).width, target.getRect(target).height);
				rectShape.graphics.endFill();
				target.addChild(rectShape);
			}
		}
	}
}
