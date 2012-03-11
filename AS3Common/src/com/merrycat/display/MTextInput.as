package com.merrycat.display 
{
	import com.merrycat.utils.MValidate;
	import org.casalib.util.StringUtil;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;

	/**
	 * @author merrycat
	 * 
	 * 输入文本框，支持默认提示信息
	 */
	public class MTextInput 
	{
		public static const COMMON:int = 0;
		public static const MOBILE:int = 1;
		public static const EMAIL:int = 2;
		
		private var _tf : TextField;
		private var _defInput : String;
		private var _mode : int;
		
		/**
		 * 构造函数
		 * 
		 * @param	tf 			目标TextField
		 * @param	defInput 	默认提示文字
		 * @param	maxChars 	最多输入字符
		 */
		public function MTextInput(tf : TextField, defInput : String = "", maxChars : int = 20, mode:int = 0)
		{
			this.tf = tf;
			
			_mode = mode;
			
			_defInput = defInput;
			
			tf.maxChars = maxChars;
			tf.addEventListener(FocusEvent.FOCUS_IN, onInputFocusIn);
			tf.text = defInput;
			
			tf.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
			switch(_mode)
			{
				case MOBILE:
					tf.restrict = "0-9";
					break;
				case EMAIL:
					tf.restrict = "A-Z0-9a-z .@";
					break;
				default:
			}
		}

		private function onInputFocusIn(e : FocusEvent) : void 
		{
			tf.removeEventListener(FocusEvent.FOCUS_IN, onInputFocusIn);
			tf.addEventListener(FocusEvent.FOCUS_OUT, onInputFocusOut);
			
			if(tf.text == _defInput)
			{
				tf.text = "";
			}
		}

		private function onInputFocusOut(e : FocusEvent) : void 
		{
			tf.removeEventListener(FocusEvent.FOCUS_OUT, onInputFocusOut);
			tf.addEventListener(FocusEvent.FOCUS_IN, onInputFocusIn);
			
			if(tf.text == "")
			{
				tf.text = _defInput;
			}
		}

		public function set tf(value : TextField) : void
		{
			_tf = value;
		}

		public function get tf() : TextField
		{
			return _tf;
		}

		private function onRemove(e : Event) : void 
		{
			tf.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			tf.removeEventListener(FocusEvent.FOCUS_IN, onInputFocusIn);
			tf.removeEventListener(FocusEvent.FOCUS_OUT, onInputFocusOut);
		}

		public function validate() : Boolean
		{
			if(StringUtil.trim(tf.text) == "" || StringUtil.trim(tf.text) == _defInput)
			{
				return false;
			}
			
			switch(_mode)
			{
				case MOBILE:
					if(!MValidate.checkMobile(tf.text))
					{
						return false;
					}
					break;
				case EMAIL:
					if(!MValidate.checkEmailAddress(tf.text))
					{
						return false;
					}
					break;
				default:
			}
			
			return true;
		}
	}
}
