package com.merrycat.media
{
	import com.merrycat.ValueObject;
	
	/**
	 * @author merrycat
	 * 结合播放器的字幕对象
	 */
	public class CaptionVO extends ValueObject
	{
		public var startSec:Number;
		public var endSec:Number;
		public var caption:String;
		
		/**
		 * 构造函数
		 * 
		 * @param	startSec	该字幕起始位置 单位秒
		 * @param	endSec		该字幕终止位置 单位秒
		 * @param	caption		字幕内容文字
		 */
		public function CaptionVO( startSec:Number, endSec:Number, caption:String )
		{
			super();
			
			this.startSec = startSec;
			this.endSec = endSec;
			this.caption = caption;
		}
	}
}