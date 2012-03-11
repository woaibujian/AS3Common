package com.merrycat.ComboBox
{
	import flash.events.Event;

	/**
	 * ...
	 * @author ZUOCHEN.CHEN | coward_c@hotmail.com
	 * @since 2009-2-11 15:22
	 */
	public class  MyDataEvent extends Event
	{
		private var _data : Object;

		public function MyDataEvent(str : String, myData : Object = null , bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(str, bubbles, cancelable);
			_data = myData;
		}

		public function set data(d : Object) : void
		{
			_data = d;
		}

		public function get data() : Object
		{
			return _data;
		}
	}
}