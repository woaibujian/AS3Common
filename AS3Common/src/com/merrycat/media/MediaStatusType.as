package com.merrycat.media
{
	/**
	 * @author merrycat
	 * 播放器状态属性
	 */
	public class MediaStatusType
	{
		/**
		 * 播放停止
		 */
		public static const PLAY_STOP : String = "PLAY_STOP";
		
		/**
		 * 播放暂停
		 */
		public static const PLAY_PAUSE : String = "PLAY_PAUSE";
		
		/**
		 * 播放继续
		 */
		public static const PLAY_RESUME : String = "PLAY_RESUME";
		
		/**
		 * 播放开始
		 */
		public static const PLAY_START : String = "PLAY_START";
		
		/**
		 * 播放完成
		 */
		public static const PLAY_COMP : String = "PLAY_COMP";
		
		/**
		 * 缓冲区已满，可以播放
		 */
		public static const BUFFER_FULL : String = "BUFFER_FULL";
		
		/**
		 * 缓冲已空，需等待加载
		 */
		public static const BUFFER_EMPTY : String = "BUFFER_EMPTY";
		
		/**
		 * 播放进行中广播事件
		 */
		public static const PROGRESS : String = "PROGRESS";
		
		/**
		 * 视频原标签
		 */
		public static const METADATA : String = "METADATA";
		
		/**
		 * FLV结点信息广播事件
		 */
		public static const CUEPOINT : String = "CUEPOINT";
		
		/**
		 * 音频标签
		 */
		public static const ID3 : String = "ID3";
		
		public function MediaStatusType()
		{
		}

	}
}