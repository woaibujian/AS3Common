package com.merrycat.button
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	/**
	 * @author merrycat
	 * 
	 * MCComplexBtn（复杂按钮类）需要指定的按钮内部层对象
	 */
	public class BtnElementVO extends Dictionary
	{
		/**
		 * 按钮内部层对象
		 */
		public var target : DisplayObject;
		
		/**
		 * 按钮内部层对象类型，具体设置参见MCComplexBtn
		 */
		public var elementType : int; 
		
		/**
		 * 按钮内部层对象
		 * 
		 * @param	target			按钮内部层对象
		 * @param	elementType		按钮内部层对象类型，具体设置参见MCComplexBtn
		 */
		public function BtnElementVO( target : DisplayObject, elementType : int )
		{
			super( true );
			this.target = target;
			this.elementType = elementType;
		}
	}
}