package com.merrycat.utils
{
	import flash.utils.ByteArray;
	
	/**
	 * @author:		Merrycat
	 * @version:	2010-11-26	����10:49:44
	 * @decs		String扩展类
	 */
	public class MStringUtil
	{
		public function MStringUtil()
		{
		}
		
		/**
		 * 获取扩展名
		 * @param url 		文件地址
		 */
		public static function getExtendName( url : String ):String
		{
			return url.slice( url.lastIndexOf( "." ) + 1 ).toLowerCase();
		}
		
		/**
		 * 获取文件名
		 * @param url 		文件地址
		 */
		public static function getFileName( url : String ):String
		{
			var fromIdx : int = url.lastIndexOf("/") + 1;
			return url.slice( fromIdx ).toLowerCase();
		}
		
		/**
		 * 获取字符字节长度
		 * @param url 		字符串
		 * @example
		 * 
		 * MStringUtil.getStrByteLen("sdf123哈哈哈") //12
		 */
		public static function getStrByteLen( str:String ):int
		{
			var thisStringBytsLength :ByteArray = new ByteArray();
			thisStringBytsLength.writeMultiByte(str, "gb2312");
			return thisStringBytsLength.length;
		}
		
		/**
		 * 将字符串分割为数组
		 * @param str 		字符串
		 * @example
		 * 
		 * MStringUtil.getArrFromStr("一二七八九十") //一,二,七,八,九,十
		 */
		public static function getArrFromStr(str:String) : Array
		{
			var arr : Array = [];
			for (var i : int = 0; i < str.length; i++) 
			{
				arr[i] = str.substr(i, 1); 
			}
			return arr;
		}
	}
}