package com.merrycat.button 
{
	import flash.media.Sound;
	import org.casalib.time.EnterFrame;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author merrycat
	 * 
	 * 简单按钮类，相对复杂按钮类只需带入按钮UI即可，只含有OVER效果一层，并且无需设置OVER效果层实例名以及首尾stop()方法。
	 */
	public class MCSimpleBtn extends AbstractBtn implements IBtn
	{
		/**
		 * 带有时间轴的OVER效果MovieClip对象
		 */
		public var overMC:MovieClip;
		
		protected var _currState : int;
		
		protected const NEXT_FRAME : int = 0;
		protected const PREV_FRAME : int = 1;
		
		/**
		 * @param	ui						带入按钮UI
		 * @param	clickedFun				参见AbstractBtn基类
		 * @param	copyPos					是否拷贝原UI的X,Y位置
		 * @param	downEff					参见AbstractBtn基类
		 * @param	soundOverEff			参见AbstractBtn基类
		 * @param	autoAddToDisplayList	自动添加到显示列表，与原UI同级
		 */		
		public function MCSimpleBtn(ui : Sprite, clickedFun:Function = null, 
			copyPos:Boolean = true, downEff : Boolean = false, 
			soundOverEff:Sound = null, autoAddToDisplayList:Boolean = true)
		{
			super(clickedFun, downEff, soundOverEff);
			
			if(copyPos)
			{
				this.x = ui.x;
				this.y = ui.y;
			}
			
			if(autoAddToDisplayList && ui.parent)
			{
				ui.parent.addChild(this);
			}
			
			ui.visible = false;
			
			overMC = this.addChild(ui.getChildAt(ui.numChildren - 1)) as MovieClip;
			overMC.stop();
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			
		}
		
		override protected function overHandler( e : MouseEvent = null ):void
		{
			this.addEventListener(MouseEvent.ROLL_OUT, outHandler );
			this.removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			
			if(e)
			{
				if( !selected && overMC.currentFrame != overMC.totalFrames)
				{
					_currState = NEXT_FRAME;
					EnterFrame.getInstance().addEventListener( Event.ENTER_FRAME, efHandler );
				} 
			}else
			{
				if( overMC.currentFrame != overMC.totalFrames)
				{
					_currState = NEXT_FRAME;
					EnterFrame.getInstance().addEventListener( Event.ENTER_FRAME, efHandler );
				} 
			}
		}
		
		override protected function outHandler( e : MouseEvent = null ):void
		{
			this.removeEventListener(MouseEvent.ROLL_OUT, outHandler );
			this.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			
			if(e)
			{
//				if( !selected && overMC.currentFrame != 1)
				if( !selected)
				{
					_currState = PREV_FRAME;
	            	EnterFrame.getInstance().addEventListener( Event.ENTER_FRAME, efHandler );
				} 
			}else
			{
//				if( overMC.currentFrame != 1)
//				if( overMC.currentFrame != 1)
//				{
					_currState = PREV_FRAME;
	            	EnterFrame.getInstance().addEventListener( Event.ENTER_FRAME, efHandler );
//				} 
			}
		}
		
		protected function efHandler( e : Event ):void
		{
			if(_currState == NEXT_FRAME)
			{
				if( overMC.currentFrame < overMC.totalFrames )
				{
					overMC.nextFrame();
				}
				else
				{
					overMC.stop();
					_currState = -1;
					EnterFrame.getInstance().removeEventListener( Event.ENTER_FRAME, efHandler );
				}
			}else if(_currState == PREV_FRAME)
			{
				if( overMC.currentFrame > 1 )
				{
					overMC.prevFrame();
				}
				else
				{
					overMC.stop();
					_currState = -1;
					EnterFrame.getInstance().removeEventListener( Event.ENTER_FRAME, efHandler );
				}
			}
		}
		
		override protected function destory( e:Event = null ):void
		{
			super.destory(e);
			EnterFrame.getInstance().removeEventListener( Event.ENTER_FRAME, efHandler );
		}

		override public function set selected(b : Boolean) : void
		{
			super.selected = b;
			
			if( b )
			{
				overHandler();
			}else
			{
				outHandler();
			}
			
			this.mouseEnabled = !b;
		}
	}
}
