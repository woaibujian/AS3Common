package com.merrycat.button 
{
	import org.casalib.time.EnterFrame;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;

	/**
	 * @author jan.bu
	 */
	public class MCLongSimpleBtn extends MCSimpleBtn
	{
		public function MCLongSimpleBtn(ui : Sprite, clickedFun:Function = null, 
			copyPos:Boolean = true, downEff : Boolean = false, 
			soundOverEff:Sound = null, autoAddToDisplayList:Boolean = true)
		{
			super(ui, clickedFun, copyPos, downEff, soundOverEff, autoAddToDisplayList);
			
			EnterFrame.getInstance().addEventListener( Event.ENTER_FRAME, efHandler );
		}

		override public function fadeIn() : void 
		{
			overMC.play();
		}

		override protected function efHandler( e : Event ):void
		{
			if(overMC.currentFrame == overMC.totalFrames)
			{
				overMC.gotoAndStop("over");	
			}
		}
		
		override protected function mouseLeave(e : Event) : void 
		{
			if(!selected)
			{
				overMC.gotoAndStop(overMC.totalFrames);	
			}
		}

		override protected function overHandler( e : MouseEvent = null ):void
		{
			this.addEventListener(MouseEvent.ROLL_OUT, outHandler );
			this.removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			
			if(e)
			{
				if( !selected && overMC.currentFrame != overMC.totalFrames)
				{
					overMC.gotoAndPlay("over");
				} 
			}else
			{
//				if( overMC.currentFrame != overMC.totalFrames)
//				{
					overMC.gotoAndPlay("over");
//				} 
			}
		}
		
		override protected function outHandler( e : MouseEvent = null ):void
		{
			this.removeEventListener(MouseEvent.ROLL_OUT, outHandler );
			this.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			
			if(e)
			{
				if( !selected)
				{
					overMC.gotoAndPlay("out");
				} 
			}else
			{
				overMC.gotoAndPlay("out");
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
