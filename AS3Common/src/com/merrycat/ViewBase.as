package com.merrycat
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	public class ViewBase extends EventDispatcher
	{
		private var _asset : Sprite;

		public function ViewBase( asset:Sprite = null )
		{
			if( asset )
			{
				this.asset = asset;
			}
		}

		public function get asset() : Sprite
		{
			return _asset;
		}

		public function set asset( s : Sprite ) : void
		{
			_asset = s;
			
			_asset.addEventListener(Event.REMOVED_FROM_STAGE, destory, false, 0, true);
		}
		
		public function destory(e:Event = null):void
		{
			_asset.removeEventListener(Event.REMOVED_FROM_STAGE, destory);
		}
	}
}