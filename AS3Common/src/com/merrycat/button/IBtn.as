package com.merrycat.button
{
	import flash.events.IEventDispatcher;
	
	public interface IBtn extends IEventDispatcher
	{
		function get selected():Boolean;
    	function set selected(value:Boolean):void;
	}
}