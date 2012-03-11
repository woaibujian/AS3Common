package com.merrycat.tooltip 
{
	import flash.display.Shape;
	import com.greensock.TweenLite;
	import com.merrycat.display.MDisplayObjectUtil;

	import org.casalib.util.StageReference;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * @author jan.bu
	 * 
	 * 自定义UI Tooltip类
	 */
	public class MCutomTooltip 
	{
		private var _uiClass : Class;

		private static var instance : MCutomTooltip;

		private var _uiDict : Dictionary = new Dictionary(true);
		
		private var _offset : Point = new Point();

		public function MCutomTooltip(pw : PrivateClass)
		{
		}

		public static function getInstance() : MCutomTooltip
		{
			if ( instance == null )
				instance = new MCutomTooltip(new PrivateClass());

			return instance;
		}
		
		/**
		 * 设置用于Tooltip图形类
		 * @param uiClass 		UI类
		 * @example
		 * 
		 * MCutomTooltip.setUIClass(TipUI)
		 */
		public function setUIClass(uiClass : Class) : void 
		{
			_uiClass = uiClass;
		}
		
		/**
		 * 设置相对鼠标偏移值
		 * @param x 		偏移值x
		 * @param y 		偏移值y
		 * @example
		 * 
		 * MCutomTooltip.setOffset(10, 10)
		 */
		public function setOffset(x:Number = 0, y:Number = 0) : void
		{
			_offset.x = x;
			_offset.y = y;
		}
		
		/**
		 * 给目标对象添加Tooltip
		 * @param target 		目标对象
		 * @param frame 		Tooltip图形类定位在哪一帧
		 * @example
		 * 
		 * MCutomTooltip.addTip(target, "2")
		 */
		public function addTip(target : Sprite, frame : String = "") : void 
		{
			target.addEventListener(MouseEvent.ROLL_OVER, onTargetOver);
			_uiDict[target] = new UIObj();
			_uiDict[target].frame = frame;
		}
		
		/**
		 * 移除目标对象的Tooltip
		 * @param target 		目标对象
		 * @example
		 * 
		 * MCutomTooltip.removeTip(target)
		 */
		public function removeTip(target:Sprite) : void
		{
			target.removeEventListener(MouseEvent.ROLL_OVER, onTargetOver);
			target.removeEventListener(Event.ENTER_FRAME, onTargetMove);
			target.removeEventListener(MouseEvent.ROLL_OUT, onTargetOut);
			
			if(MDisplayObjectUtil.hasChild(_uiDict[target].ui, StageReference.getStage()))
				StageReference.getStage().removeChild(_uiDict[target].ui as Sprite);
		}

		private function onTargetOver(e : MouseEvent) : void 
		{
			var target : Sprite = e.currentTarget as Sprite;
			target.addEventListener(MouseEvent.ROLL_OUT, onTargetOut);
			target.addEventListener(Event.ENTER_FRAME, onTargetMove);
			target.removeEventListener(MouseEvent.ROLL_OVER, onTargetOver);
			
			if(!_uiDict[target].ui)
			{
				var uiCont:Sprite = new Sprite();
				var ui:MovieClip = new _uiClass();
				uiCont.addChild(ui);
				
				_uiDict[target].ui = uiCont;
				ui.gotoAndStop(_uiDict[target].frame);
				uiCont.mouseChildren = false;
				uiCont.mouseEnabled = false;
				uiCont.alpha = 0;
				
				var m:Shape = new Shape();
				m.graphics.beginFill(0);
				m.graphics.drawRect(0, 0, ui.width, ui.height);
				m.graphics.endFill();
				m.x = -ui.width;
				uiCont.addChild(m);
				uiCont.mask = m;
				
				_uiDict[target].m = m;
			}
			
			_uiDict[target].ui.x = _offset.x + StageReference.getStage().mouseX;
			_uiDict[target].ui.y = _offset.y + StageReference.getStage().mouseY;
			
			TweenLite.killTweensOf(_uiDict[target].ui);
			TweenLite.to(_uiDict[target].ui, 0.5, {alpha:1});
			TweenLite.to(_uiDict[target].m, 0.5, {x:0});
			StageReference.getStage().addChild(_uiDict[target].ui);
		}

		private function onTargetMove(e : Event) : void 
		{
			var target : Sprite = e.currentTarget as Sprite;
			
			_uiDict[target].ui.x += (_offset.x + StageReference.getStage().mouseX - _uiDict[target].ui.x) * 0.1;
			_uiDict[target].ui.y += (_offset.y + StageReference.getStage().mouseY - _uiDict[target].ui.y) * 0.1;
		}

		private function onTargetOut(e : MouseEvent) : void 
		{
			var target : Sprite = e.currentTarget as Sprite;
			
			target.addEventListener(MouseEvent.ROLL_OVER, onTargetOver);
			target.removeEventListener(MouseEvent.ROLL_OUT, onTargetOut);
			
			TweenLite.to(_uiDict[target].ui, 0.5, {alpha:0, onComplete:onUIFadeOut, onCompleteParams:[target]});
			TweenLite.to(_uiDict[target].m, 0.5, {x:-_uiDict[target].ui.width});
		}

		private function onUIFadeOut(target:Sprite) : void 
		{
			target.removeEventListener(Event.ENTER_FRAME, onTargetMove);
			
			if(MDisplayObjectUtil.hasChild(_uiDict[target].ui, StageReference.getStage()))
				StageReference.getStage().removeChild(_uiDict[target].ui as Sprite);
		}
	}
}

import flash.display.Shape;
import flash.display.Sprite;

class UIObj
{
	public var frame : String;
	public var ui : Sprite;
	public var m:Shape;
}

class PrivateClass
{
}