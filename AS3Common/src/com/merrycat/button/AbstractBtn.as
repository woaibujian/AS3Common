package com.merrycat.button 
{
	import org.casalib.time.Interval;
	import flash.media.Sound;
	import flash.events.MouseEvent;

	import org.casalib.util.StageReference;

	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author merrycat
	 * 
	 * 按钮基类
	 */
	public class AbstractBtn extends Sprite implements IBtn
	{
		private var _downEff : Boolean;
		private var _selected : Boolean;
		private var _useRepeatMode:Boolean = false;
		private var _repeatCall:Function;
		private var _repeatFrequency:int;
		private var _repeatInterval:Interval;
		
		/**
		 * 当前对象的索引
		 * 方便如导航等，需要mousedown等事件监听函数执行后获取当前对象的标识ID
		 */
		public var idx:int;
		
		/**
		 * 可选带入的其他属性参数，为便利之用
		 */
		public var extra : Object;
		private var _enabled : Boolean;
		
		/**
		 * 按钮基类构造函数
		 * 
		 * @param	clickedFun			CLICK事件回调函数，直接带入，无需注册
		 * @param	downEff				鼠标按下效果，按钮对象x,y位置+1，鼠标弹起后恢复位置
		 * @param	soundOverEff		鼠标划过指定的声音 Sound 对象
		 */
		public function AbstractBtn(clickedFun:Function = null, downEff : Boolean = false, soundOverEff:Sound = null)
		{
			_downEff = downEff;
			
			if( downEff ) 
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			}
			
			if(soundOverEff)
			{
				this.addEventListener(MouseEvent.ROLL_OVER, function():void
				{
					soundOverEff.play();
				});
			}
			
			clickedFun && this.addEventListener(MouseEvent.CLICK, clickedFun );
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, destory);
			
			StageReference.getStage().addEventListener(Event.MOUSE_LEAVE, mouseLeave);
		}

		public function fadeIn() : void 
		{
			
		}
		
		/**
		 * 鼠标按下连续引发事件
		 * 
		 * @param	repeatCall			回调函数
		 * @param	repeatFrequency		回调频率，单位毫秒
		 */
		public function useRepeatMode(repeatCall:Function, repeatFrequency:int) : void 
		{
			_useRepeatMode = true;
			_repeatCall = repeatCall;
			_repeatFrequency = repeatFrequency;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		/**
		 * 当鼠标离开舞台时恢复按钮对象的鼠标划过效果
		 */
		protected function mouseLeave(e : Event) : void 
		{
			if(!selected)
			{
				outHandler();
			}
		}
		
		protected function overHandler( e : MouseEvent = null ):void
		{
		}
		
		protected function outHandler( e : MouseEvent = null ):void
		{
		}

		private function downHandler( e : MouseEvent ) : void
		{
			if(downEff)
			{
				this.x += 1;
				this.y += 1;
				
				StageReference.getStage().addEventListener(MouseEvent.MOUSE_UP, upHandler);
			}
			
			if(_useRepeatMode)
			{
				_repeatInterval = Interval.setInterval(_repeatCall, _repeatFrequency);
				_repeatInterval.start();
			}
		}

		private function upHandler( e : MouseEvent ) : void
		{
			if(downEff)
			{
				this.x -= 1;
				this.y -= 1;
				StageReference.getStage().removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			}
			
			if(_useRepeatMode)
			{
				_repeatInterval && _repeatInterval.destroy();
			}
		}

		protected function destory( e : Event = null ) : void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destory);
			StageReference.getStage().removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			_repeatInterval && _repeatInterval.destroy();
		}

		public function get downEff() : Boolean 
		{
			return _downEff;
		}
		
		/**
		 * 获得当前按钮的选择状态（如导航这种应用记录当前栏目的选中状态）
		 * @return						当前状态
		 */
		public function get selected() : Boolean
		{
			return _selected;
		}
		
		/**
		 * 设置当前按钮的选择状态（如导航这种应用记录当前栏目的选中状态）
		 */
		public function set selected( b : Boolean ) : void
		{
			_selected = b;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			
			if(_enabled)
			{
				this.alpha = 1;
				this.mouseEnabled = true;
			}else
			{
				this.alpha = 0.2;
				this.mouseEnabled = false;
			}
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
	}
}
