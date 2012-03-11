package com.merrycat.scrollbar
{
	import flash.events.Event;

	public class ScrollBarEvent extends Event
	{
		public static const CHANGE             : String    = "CHANGE";
		
		public var percent : Number;
			
		public function ScrollBarEvent( type : String, percent : Number , bubbles : Boolean = false )
		{
			super( type, bubbles );
			
			this.percent = percent;
		}
			
		public override function clone():Event
		{
			return new ScrollBarEvent( type, percent , bubbles );
		}
	}
}