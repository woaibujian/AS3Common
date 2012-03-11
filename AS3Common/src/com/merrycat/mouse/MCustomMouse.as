package com.merrycat.mouse 
{
	import flash.ui.Mouse;
	import org.casalib.util.StageReference;
	import flash.events.Event;
	import org.casalib.time.EnterFrame;
	import com.merrycat.ViewBase;

	import flash.display.Sprite;

	/**
	 * @author merrycat
	 * 自定义鼠标图标类
	 * 注意使用手动销毁
	 */
	public class MCustomMouse extends ViewBase 
	{
		private var _isCustomShow:Boolean = false;
		private var _inDisplayList:Boolean = false;
		
		/**
		 * lock后鼠标图标锁定不变
		 */
		public var lock:Boolean = false;
		
		public function MCustomMouse(asset:Sprite) 
		{
			super(asset);
			
			asset.visible = false;
			asset.mouseEnabled = false;
			asset.mouseChildren = false;
		}
		
		/**
		 * 显示自定义图标
		 */
		public function showCustom() : void 
		{
			if(!_inDisplayList)
			{
				_inDisplayList = true;
				
				if(!asset.parent)
				{
					StageReference.getStage().addChild(asset);
				}else
				{
//					trace(222)
//					asset.removeEventListener(Event.REMOVED_FROM_STAGE, destory);
				}
			}
			
			if(!lock && !_isCustomShow)
			{
				_isCustomShow = true;
				asset.visible = true;
				asset.x = asset.parent.mouseX;
				asset.y = asset.parent.mouseY;
				Mouse.hide();
				EnterFrame.getInstance().addEventListener(Event.ENTER_FRAME, onEf);
			}
		}
		
		/**
		 * 隐藏自定义图标
		 */
		public function hideCustom() : void 
		{
			if(!lock && _isCustomShow)
			{
				_isCustomShow = false;
				asset.visible = false;
				Mouse.show();
				
				EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEf);
			}
		}
		
		private function onEf(e : Event) : void 
		{
			asset.x = asset.parent.mouseX;
			asset.y = asset.parent.mouseY;
		}
		
		/**
		 * 销毁
		 */
		override public function destory(e : Event = null) : void 
		{
			super.destory();
			
//			if(_inDisplayList)
//			{
//				asset.parent.removeChild(asset.parent);
//			}
			
			Mouse.show();
			EnterFrame.getInstance().removeEventListener(Event.ENTER_FRAME, onEf);
		}
	}
}
