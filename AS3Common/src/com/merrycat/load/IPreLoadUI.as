package com.merrycat.load
{
	import flash.display.DisplayObject;
	import org.casalib.math.Percent;
	
	public interface IPreLoadUI
	{
		function set currPercent( p : Percent ):void
		function get dispUI():DisplayObject;
		function destory():void
	}
}