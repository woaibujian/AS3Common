package com.merrycat.display
{
	import org.casalib.util.DisplayObjectUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class MDisplayObjectUtil extends DisplayObjectUtil
	{
		public function MDisplayObjectUtil()
		{
			super();
		}
		
		public static function takeSnapshot(target:DisplayObject, w:int = -1, h:int = -1, offX:int = 0, offY:int = 0) : Bitmap
        {
            w = w < 0 ? (target.width) : (w);
            h = h < 0 ? (target.height) : (h);
            if (!target)
            {
                throw new Error("takeSnapshot: the displayobject is NULL!");
            }
            if (w <= 0 || h <= 0)
            {
                throw new Error("takeSnapshot: width or  height of the bitmap is <= zero !");
            }
            if (w + offX > target.width || h + offY > target.height)
            {
                throw new Error("takeSnapshot: width or height plus the offset x or y  is bigger than the DisplayObject\'s dimensions !");
            }
            if (w >= 2880 || h >= 2880)
            {
                throw new Error("takeSnapshot: width or  height of the bitmap is >= 2880 !");
            }
            var bmp:Bitmap = new Bitmap(new BitmapData(w, h, true, 0));
            var m:Matrix = new Matrix();
            m.translate(-offX, -offY);
            bmp.bitmapData.draw(target, m);
            return bmp;
        }
		
		/**
		 * 检查父显示对象中有无参数对象
		 * 
		 * @param	target 		检测对象
		 * @param	parent 		父显示对象
		 */
		public static function hasChild(target:DisplayObject, parent : DisplayObjectContainer) : Boolean
		{
			var has:Boolean = false;
			for (var i : int = 0;i < parent.numChildren;i++) 
			{
				if(parent.getChildAt(i) == target)
				{
					has = true;
					break;
				}
			}
			
			return has;
		}
		
		/**
		 * 检查父显示对象中有无参数实例名的对象
		 * 
		 * @param	targetName 	检测对象实例名
		 * @param	parent 		父显示对象
		 */
		public static function hasChildByName(targetName:String, parent : DisplayObjectContainer) : Boolean
		{
			var has:Boolean = false;
			for (var i : int = 0;i < parent.numChildren;i++) 
			{
				if(parent.getChildAt(i).name == targetName)
				{
					has = true;
					break;
				}
			}
			
			return has;
		}

		/**
		 *   Wait a given number of frames then call a callback
		 *   @param numFrames Number of frames to wait before calling the callback
		 *   @param callback Function to call once the given number of frames have passed
		 */
		public static function wait(numFrames : uint, callback : Function) : void
		{
			var mc : MovieClip = new MovieClip();
			mc.addEventListener(Event.ENTER_FRAME, function(ev : Event): void
			{
				numFrames--;
				if (numFrames == 0)
				{
					mc.removeEventListener(Event.ENTER_FRAME, arguments.callee);
					callback();
				}
			});
		}

		/**
		 *   Apply a scroll rect from (0,0) to (width,height)
		 *   @param dispObj Display object to apply on
		 */
		public static function applyNaturalScrollRect(dispObj : DisplayObject) : void
		{
			dispObj.scrollRect = new Rectangle(0, 0, dispObj.width, dispObj.height);
		}

		/**
		 *   Create a shape that is a simple solid color-filled rectangle
		 *   @param width Width of the rectangle
		 *   @param height Height of the rectangle
		 *   @param color Color of the rectangle
		 *   @param alpha Alpha of the rectangle
		 *   @return The created shape
		 */
		public static function createRectangleShape(width : uint, height : uint, color : uint, alpha : Number) : Shape
		{
			var rect : Shape = new Shape();
			
			var g : Graphics = rect.graphics;
			g.beginFill(color, alpha);
			g.drawRect(0, 0, width, height);
			g.endFill();
			
			return rect;
		}

		/**
		 *   Remove all children from a container and leave the bottom few
		 *   @param container Container to remove from
		 *   @param leave (optional) Number of bottom children to leave
		 */
		public static function removeAllChildren(container : DisplayObjectContainer, leave : int = 0) : void
		{
			while (container.numChildren > leave)
			{
				container.removeChildAt(leave);
			}
		}

		/**
		 *   Instantiate a new instance of a certain class of display object
		 *   @param obj Display object whose class a new display object should be
		 *              instantiated of
		 *   @param args Arguments to pass to the display object's constructor
		 *   @return A new instance of the given display object's class
		 */
		/*public static function instantiate(obj:DisplayObject, args:Array): DisplayObject
		{
		var c:Class = ObjectUtils.getDisplayObjectClass(obj);
		return c == null ? null : DisplayObject(FunctionUtils.instantiate(c, args));
		}*/
		
		/**
		 *   Check if a display object is visible. This checks all of its
		 *   parents' visibilities.
		 *   @param obj Display object to check
		 */
		public static function isVisible(obj : DisplayObject) : Boolean
		{
			for (var cur : DisplayObject = obj;cur != null;cur = cur.parent)
			{
				if (!cur.visible)
				{
					return false;
				}
			}
			return true;
		}

		/**
		 *   Get the children of a container as an array
		 *   @param container Container to get the children of
		 *   @return The children of the given container as an array
		 */
		public static function getChildren(container : DisplayObjectContainer) : Array
		{
			var ret : Array = [];
			
			var numChildren : int = container.numChildren;
			for (var i : int = 0;i < numChildren;++i)
			{
				ret.push(container.getChildAt(i));
			}
			
			return ret;
		}

		/**
		 *   Get the parents of a display object as an array
		 *   @param obj Object whose parents should be retrieved
		 *   @param includeSelf If obj should be included in the returned array
		 *   @param stopAt Display object to stop getting parents at. Passing
		 *                 null indicates that all parents should be included.
		 *   @return An array of the parents of the given display object. This
		 *           includes all parents unless stopAt is non-null. If stopAt is
		 *           non-null, it and its parents will not be included in the
		 *           returned array.
		 */
		public static function getParents(obj : DisplayObject, includeSelf : Boolean = true, stopAt : DisplayObject = null) : Array
		{
			var ret : Array = [];
			
			for (var cur : DisplayObject = includeSelf ? obj : obj.parent;cur != stopAt && cur != null;cur = cur.parent
			)
			{
				ret.push(cur);
			}
			
			return ret;
		}
	}
}