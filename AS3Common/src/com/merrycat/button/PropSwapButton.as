package com.merrycat.button
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;

	/**
	 * @author Administrator
	 */
	public class PropSwapButton extends AbstractBtn
	{
		public var overMC:Sprite;
		
		public var overProp : BtnOverPropVO;
		
		public function PropSwapButton(ui : Sprite, clickedFun:Function = null, overProp:BtnOverPropVO = null,
			copyPos:Boolean = true, downEff : Boolean = false, 
			soundOverEff:Sound = null, autoAddToDisplayList:Boolean = true)
		{
			super(clickedFun, downEff, soundOverEff);
			
			TweenPlugin.activate([ColorTransformPlugin, TintPlugin]);
			
			if(copyPos)
			{
				this.x = ui.x;
				this.y = ui.y;
			}
			
			if(autoAddToDisplayList && ui.parent)
			{
				ui.parent.addChild(this);
			}
			
//			ui.visible = false;
			
			this.overProp = overProp;
			
			overMC = this.addChild(ui) as Sprite;
			ui.x = 0;
			ui.y = 0;
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.ROLL_OVER, overHandler);
		}
		
		override protected function overHandler( e : MouseEvent = null ):void
		{
			this.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			this.removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			
			if(overProp.color)
			{
				TweenLite.to(overMC, 0.3, {colorTransform:{tint:overProp.color, tintAmount:1}});
			}
			
			if(overProp.offset)
			{
				TweenLite.to(overMC, 0.3, {x:overProp.offset.x, y:overProp.offset.y});
			}
		}
		
		override protected function outHandler( e : MouseEvent = null ):void
		{
			if(selected)
			{
				return;
			}
			this.removeEventListener(MouseEvent.ROLL_OUT, outHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			
			if(overProp.color)
			{
				TweenLite.to(overMC, 0.3, {colorTransform:{tint:overProp.color, tintAmount:0}});
			}
			
			if(overProp.offset)
			{
				TweenLite.to(overMC, 0.3, {x:0, y:0});
			}
		}
		
		override protected function destory( e:Event = null ):void
		{
			super.destory(e);
		}

		override public function set selected(b : Boolean) : void
		{
			super.selected = b;
			
			this.mouseEnabled = !b;
			if( b )
			{
				overHandler();
			}else
			{
				outHandler();
			}
			
		}
	}
}
