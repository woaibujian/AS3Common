package com.merrycat.utils
{
	/**
	 * @author:		Merrycat
	 * @version:	2010-12-15	����11:24:32
	 */
	public class MClass
	{
		
		public static function getClassByTarget(target:*) : Class
		{
			return target.constructor;	
		}
	}
}
