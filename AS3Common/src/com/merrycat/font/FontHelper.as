package com.merrycat.font
{
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * @author merrycat
	 * 
	 * 字体管理类
	 */
	public class FontHelper
	{
		public static var HAS_FONT_DICT : Dictionary;
		public static var defaultFont : String;
		
		public static var FONT_TYPE_NUMBER_CHAR : String = "fontTypeNumberChar";
		public static var FONT_TYPE_CHINESE_CHAR : String = "fontTypeChineseChar";
		public static var FONT_TYPE_ENGLISH_CHAR : String = "fontTypeEnglishChar";
		public static var FONT_TYPE_PUNCTUATION_CHAR : String = "fontTypePunctuationChar";
		public static var UN_KNOW_TYPE : String = "unknowType";

		public function FontHelper() : void
		{
			super();
		}
		
		/**
		 * 判断字符类型（数字，英文字母，汉字，标点）
		 * 
		 * @param	value		代入值，可以是汉子或16位进制数
		 * @return				（数字，英文字母，汉字，标点）
		 * @example
		 * 
		 * FontHelper.getFontCharType("汉"); // "fontTypeNumberChar"
		 */
		public static function getFontCharType(value : Object) : String
		{
			var n : int;
			if (value is String)
			{
				n = int("0x" + String(value).charCodeAt().toString(16));
			}
			else if (value is Number)
			{
				n = int(value);
			}

			if(isEnglishChar(n))
			{
				return FONT_TYPE_ENGLISH_CHAR;	
			}
			
			if(isNumberChar(n))
			{
				return FONT_TYPE_NUMBER_CHAR;	
			}
			
			if(isPunctuationChar(n))
			{
				return FONT_TYPE_PUNCTUATION_CHAR;	
			}
			
			if(isChineseChar(n))
			{
				return FONT_TYPE_CHINESE_CHAR;	
			}

			return UN_KNOW_TYPE;
		}

		/**
		 * 判断代入值是否是汉字(0x4e00~0x9fa5为所有汉字)
		 * 
		 * @param	value		代入值，可以是汉子或16位进制数
		 * @example
		 * 
		 * FontHelper.isChineseChar("汉"); // true
		 * FontHelper.isChineseChar(0x6c49); // true
		 */
		public static function isChineseChar(value : Object) : Boolean
		{
			var n : int;
			if (value is String)
			{
				n = int("0x" + String(value).charCodeAt().toString(16));
			}
			else if (value is Number)
			{
				n = int(value);
			}

			if (n >= 0x4e00 && n <= 0x9fa5)
			{
				return true;
			}

			return false;
		}

		/**
		 * 判断代入值是否是数字
		 * (0x30~0x39为所有半角数字)
		 * 
		 * (0xff10~0xff19为所有全角数字)
		 * 
		 * @param	value		代入值，可以是英文字母或16位进制数
		 * @example
		 * 
		 * FontHelper.isNumberChar("1"); // true
		 * FontHelper.isNumberChar(0x30); // true
		 */
		public static function isNumberChar(value : Object) : Boolean
		{
			var n : int;
			if (value is String)
			{
				n = int("0x" + String(value).charCodeAt().toString(16));
			}
			else if (value is Number)
			{
				n = int(value);
			}

			if (n >= 0x30 && n <= 0x39)
			{
				return true;
			}
			else if (n >= 0xff10 && n <= 0xff19)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * 判断代入值是否是英文字母
		 * (0x41~0x5a为所有半角大写字母)
		 * (0x61~0x7a为所有半角小写字母)
		 * 
		 * (0xFF21~0xFF3a为所有全角小写字母)
		 * (0xFF41~0xFF5a为所有全角小写字母)
		 * 
		 * @param	value		代入值，可以是英文字母或16位进制数
		 * @example
		 * 
		 * FontHelper.isEnglishChar("a"); // true
		 * FontHelper.isEnglishChar(0x41); // true
		 */
		public static function isEnglishChar(value : Object) : Boolean
		{
			var n : int;
			if (value is String)
			{
				n = int("0x" + String(value).charCodeAt().toString(16));
			}
			else if (value is Number)
			{
				n = int(value);
			}

			if (n >= 0x41 && n <= 0x5a)
			{
				return true;
			}
			else if (n >= 0x61 && n <= 0x7a)
			{
				return true;
			}
			else if (n >= 0xFF21 && n <= 0xFF3a)
			{
				return true;
			}
			else if (n >= 0xFF41 && n <= 0xFF5a)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * 判断代入值是否是标点符号(包含空格)
		 * (0x20~0x7e为所有半角拉丁字符)
		 * (0xFF01~0xFF65为所有全角拉丁字符)
		 * (0x00b7,0x2014,0x2018,0x2019,0x201c,0x201d,0x2026,0x3000-0x303f)
		 *  
		 * @param	value		代入值，可以是汉子或16位进制数
		 * @example
		 * 
		 * FontHelper.isPunctuationChar("，"); // true
		 * FontHelper.isPunctuationChar(0x2e); // true
		 */
		public static function isPunctuationChar(value : Object) : Boolean
		{
			var n : int;
			if (value is String)
			{
				n = int("0x" + String(value).charCodeAt().toString(16));
			}
			else if (value is Number)
			{
				n = int(value);
			}
			//半角 || 全角
			if (n >= 0x20 && n <= 0x7e || n >= 0xFF01 && n <= 0xFF65)
			{
				if(isEnglishChar(n) || isNumberChar(n))
				{
					return false;
				}else
				{
					return true;
				}
			}
			
			if( n == 0x00b7 || n == 0x2014 || n == 0x2018 || n == 0x2019 || n == 0x201c || n == 0x201d || n == 0x2026)
			{
				return true;
			}
			
			if (n >= 0x3000 && n <= 0x303f)
			{
				return true;
			}

			return false;
		}

		/**
		 * 返回一个字体编码区间内所有字体编码字符串，使用“|”隔开。（用于导出字体）
		 * 
		 * @param	from		编码区间起始值
		 * @param	to			编码区间结束值
		 * @param	withStr		连同字符一起导出，字体编码与字符之间使用“,”隔开
		 * @example
		 * 
		 * FontHelper.getCodeWithRange(0x0061, 0x63); // U+61|U+62|U+63
		 * FontHelper.getCodeWithRange(0x0061, 0x63, true); // U+61,a|U+62,b|U+63,c
		 */
		public static function getCodeWithRange(from : int, to : int, withStr : Boolean = false) : String
		{
			var str : String = "";
			var len : int = to - from;
			for (var i : int = 0; i < len; i++)
			{
				if (withStr)
				{
					str += "U+" + ( from + i ).toString(16) + ",";
					str += String.fromCharCode(Number("0x" + ( from + i ).toString(16))) + "|";
				}
				else
				{
					str += "U+" + ( from + i ).toString(16) + "|";
				}
			}
			if (withStr)
			{
				str += "U+" + to.toString(16) + ",";
				str += String.fromCharCode(Number("0x" + ( from + i ).toString(16)));
			}
			else
			{
				str += "U+" + to.toString(16);
			}
			return str;
		}

		/**
		 * 根据字符获取编码
		 * @param str 			字符
		 * @example
		 * 
		 * FontHelper.getCodeFromStr("七") // U+4e03
		 */
		public static function getCodeFromStr(str : String) : String
		{
			return "U+" + getCodeNumFromStr(str);
		}

		/**
		 * 根据编码获取字符
		 * @param code 			编码
		 * @example
		 * 
		 * FontHelper.getStrFromCode("U+4e03") // 七
		 */
		public static function getStrFromCode(code : String) : String
		{
			return String.fromCharCode(Number("0x" + getCodeNumStrFromUCode(code)));
		}

		/**
		 * 根据字符获取编码16位值（未加0x前缀）
		 * @param str 			字符
		 * @example
		 * 
		 * FontHelper.getCodeNumFromStr("七") // 4e03
		 */
		public static function getCodeNumFromStr(str : String) : String
		{
			return str.charCodeAt().toString(16);
		}

		/**
		 * 根据编码获取编码16位值（未加0x前缀）
		 * @param code 			编码
		 * @example
		 * 
		 * FontHelper.getCodeNumStrFromUCode("U+4e03") // 4e03
		 */
		public static function getCodeNumStrFromUCode(code : String) : String
		{
			return code.substring(2);
		}

		/**
		 * 客户端系统是否已安装该字库
		 * 
		 * @param	fontName		字体名称
		 */
		public static function hasFont(fontName : String = "微软雅黑") : Boolean
		{
			if (!HAS_FONT_DICT[fontName])
			{
				var f : Font = new Font();
				var arr : Array = Font.enumerateFonts(true);
				for (var i : uint = 0;i < arr.length;i++)
				{
					f = arr[i] as Font;
					if (f.fontName == fontName)
					{
						HAS_FONT_DICT[fontName] = true;
						break;
					}
				}
			}

			return HAS_FONT_DICT[fontName];
		}

		/**
		 * 改变文本字体
		 * 
		 * @param	t				文本对象
		 * @param	fontName		字体名称
		 */
		public static function changeFont(t : TextField, fontName : String = "微软雅黑") : void
		{
			if (hasFont(fontName))
			{
				var tf : TextFormat = new TextFormat();
				tf.font = fontName;
				t.setTextFormat(tf);
			}
		}

		// /////////////////////////////////////////////////for FontCompiler//////////////////
		/**
		 * 根据字符获取加载文件名
		 * @param str 			字符
		 * @example
		 * 
		 * FontHelper.getFileNameFromStr("七") // U4e03.swf
		 */
		public static function getFileNameFromStr(str : String) : String
		{
			return "U" + getCodeNumFromStr(str) + ".swf";
		}

		/**
		 * 根据字符获取字体绑定名称
		 * @param str 			字符
		 * @example
		 * 
		 * FontHelper.getFont("七") // U+4e03
		 */
		public static function getFont(str : String) : String
		{
			return getCodeFromStr(str);
		}
	}
}