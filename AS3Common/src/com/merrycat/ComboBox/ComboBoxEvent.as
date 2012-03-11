package com.merrycat.ComboBox
{

	/**
	* ...
	* @author ZUOCHEN.CHEN | coward_c@hotmail.com
	* @since 2009-4-1 18:44
	*/
	public class ComboBoxEvent extends MyDataEvent
	{
		public static var CHANGED:String = "combobox_changed";
		public static var HAVE_ANSWER:String="combobox_have_answer";
		
		
		public function ComboBoxEvent(type:String,data:Object=null,bubbles:Boolean = false, cancelable:Boolean = false  )
		{
			super(type,data, bubbles, cancelable);
		}
	}
	
}