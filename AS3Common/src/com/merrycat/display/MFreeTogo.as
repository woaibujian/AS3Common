package com.merrycat.display
{
	import org.casalib.util.StringUtil;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author merrycat
	 * 
	 * 给MovieClip附加灵活播放功能，自动判断播放头向前或向后
	 */
	public class MFreeTogo 
	{
		private const FORWARD:int = 0;
		private const BACKWARD:int = 1;
		
		public var mc : MovieClip;
		
		private var _onAniEnd : Function;
		private var _onAniUpdate : Function;
		private var _onAniStart : Function;
		private var _toFrame : String;
		private var _useFrameLabel : Boolean;
		private var _moveType : int;
		
		/**
		 * 构造函数
		 * 
		 * @param	asset 			目标MC
		 */
		public function MFreeTogo(asset : MovieClip) 
		{
			this.mc = asset;
			
			this.mc.addEventListener(Event.REMOVED_FROM_STAGE, destory);
		}
		
		/**
		 * 播放MC，自动判断播放方向
		 * 
		 * @param	toFrame 		目的地帧或帧标签
		 * @param	onAniEnd 		播放头执行到目的地后调用的执行函数
		 */
		public function goto(toFrame : String, onAniEnd : Function = null, onAniUpdate:Function = null) : void 
		{
			_toFrame = toFrame;
			
			//自动判断是使用帧还是帧标签
			_useFrameLabel = !StringUtil.isNumber(toFrame);
			
			_onAniStart && _onAniStart.apply();
			_onAniEnd = onAniEnd;
			_onAniUpdate = onAniUpdate;
			
			mc.stop();
			
			if(_useFrameLabel)
			{
				var labels : Array = mc.currentLabels;

				for (var i : uint = 0;i < labels.length;i++) 
				{
					var label : FrameLabel = labels[i];
					
					if(label.name == _toFrame)
					{
						if(label.frame == mc.currentFrame)
						{
							return;		
						}else if(label.frame > mc.currentFrame)
						{
							_moveType = FORWARD;
						}else if(label.frame < mc.currentFrame)
						{
							_moveType = BACKWARD;
						}
						break;
					}
//					trace("frame " + label.frame + ": " + label.name);
				}
			}else
			{
				if(Number(_toFrame) == mc.currentFrame)
				{
					return;		
				}else if(Number(_toFrame) > mc.currentFrame)
				{
					_moveType = FORWARD;
				}else if(Number(_toFrame) < mc.currentFrame)
				{
					_moveType = BACKWARD;
				}
			}
			
			mc.addEventListener(Event.ENTER_FRAME, onEf);
			
			onEf();
		}
		
		public function pause() : void
		{
			mc.removeEventListener(Event.ENTER_FRAME, onEf);
		}
		
		public function resume() : void
		{
			mc.addEventListener(Event.ENTER_FRAME, onEf);
		}

		public function stop() : void
		{
			mc.removeEventListener(Event.ENTER_FRAME, onEf);
		}

		private function onEf(e : Event = null) : void 
		{
			if(!_useFrameLabel && mc.currentFrame == Number(_toFrame))
			{
				mc.removeEventListener(Event.ENTER_FRAME, onEf);
				_onAniEnd && _onAniEnd();
				return;
			}
			
			if(_useFrameLabel && mc.currentLabel == _toFrame)
			{
				mc.removeEventListener(Event.ENTER_FRAME, onEf);
				_onAniEnd && _onAniEnd();
				return;
			}
			
			if(_moveType == FORWARD)
			{
				mc.nextFrame();
			}else
			{
				mc.prevFrame();
			}
			
			_onAniUpdate && _onAniUpdate.apply();
		}
		
		public function set onAniStart(value:Function):void
		{
			_onAniStart = value;
		}
		
		public function get onAniStart():Function
		{
			return _onAniStart;
		}

		public function destory(e : Event = null) : void 
		{
			this.mc.removeEventListener(Event.REMOVED_FROM_STAGE, destory);
			mc.removeEventListener(Event.ENTER_FRAME, onEf);
		}
	}
}
