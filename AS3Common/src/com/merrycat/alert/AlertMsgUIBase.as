package com.merrycat.alert
{
	import com.merrycat.ViewBase;

	import org.casalib.util.StageReference;

	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author merrycat
	 * 
	 * 弹出对象UI基类（配合AlertMsg使用）
	 * 
	 * @see AlertMsg
	 */
	public class AlertMsgUIBase extends ViewBase
	{
		/**
		 * 根据类标识ID
		 */
		public var alertId:int; 
		
		/**
		 * 承载并显示弹出的父对象
		 */
		public var parent:DisplayObjectContainer;
		
		/**
		 * 弹出对象（所有显示对象都由此对象承载）
		 */
		public var holder:Sprite;
		
		/**
		 * 模糊背景
		 */
		public var blurBmp:BitmapData;
		
		public var label:String;
		
		private var _onRemoveFun : Function;
		private var _onAddFun:Function;
		private var _onRender:Function;
		
		public function AlertMsgUIBase()
		{
			super();
		}
		
		/**
		 * 移除自身
		 */
		public function removeUI():void
		{
			AlertMsg.removeById( alertId );
		}
		
		/**
		 * 带有时间轴的图形UI（该对象以中心原点对齐）
		 */
		override public function set asset(s : Sprite) : void 
		{
			super.asset = s;
			
			MovieClip( asset ).stop();
			
			StageReference.getStage().invalidate();
			asset.addEventListener(Event.RENDER, onRendered);
		}
		
		/**
		 * 当带有时间轴的图形UI执行gotoAndStop渲染后执行
		 */
		protected function onRendered(e : Event) : void 
		{
			asset.removeEventListener(Event.RENDER, onRendered);
			
			onRender && onRender();
		}
		
		/**
		 * 清除相关对象
		 */
		override public function destory(e : Event = null) : void 
		{
			super.destory(e);
			
			asset.removeEventListener(Event.RENDER, onRendered);
		}
		
		/**
		 * 当显示动画执行完毕执行函数
		 */
		public function set onAddFun(value:Function):void
		{
			_onAddFun = value;
		}
		
		public function get onAddFun():Function
		{
			return _onAddFun;
		}
		
		/**
		 * 当消失动画执行完毕执行函数
		 */
		public function set onRemoveFun(value:Function):void
		{
			_onRemoveFun = value;
		}
		
		public function get onRemoveFun():Function
		{
			return _onRemoveFun;
		}
		
		public function set onRender(value:Function):void
		{
			_onRender = value;
		}
		
		public function get onRender():Function
		{
			return _onRender;
		}
	}
}