package com.merrycat.media
{
	import flash.events.Event;

	public class PlayerEvent extends Event
	{
		public static const UPDATE_STATUS : String="UPDATE_STATUS";
		
		public var status : String;

		public function PlayerEvent(type:String, status : String , bubbles:Boolean=false)
		{
			super(type, bubbles);
			
			this.status = status;
		}

		public override function clone():Event
		{
			return new PlayerEvent(type, status ,bubbles);
		}
	}
}