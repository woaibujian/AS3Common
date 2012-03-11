package com.merrycat.utils.site 
{
	import com.greensock.TweenMax;

	import org.casalib.util.StageReference;
	import org.robotlegs.core.IContext;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author Jan.Bu
	 */
	public class ModuleBase extends Sprite
	{
		private var _signalBus : CommonSignalBus;
		
		private var _isRunAlone : Boolean = true;
		
		public static const FADE_IN_COMP : String = "fadeInComp";
		public static const FADE_OUT_COMP : String = "fadeOutComp";

		public function ModuleBase()
		{
			if(this.parent is Stage)
			{
				StageReference.setStage(( this.parent as Stage ));
				StageReference.getStage().scaleMode = StageScaleMode.NO_SCALE;
			}else 
			{
				_isRunAlone = false;
			}
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, destory);
		}
		
		public function get isRunAlone():Boolean
		{
			return _isRunAlone;
		}

		public function get signalBus() : CommonSignalBus
		{
			if(!_signalBus)
			{
				_signalBus = new CommonSignalBus();
			}
			return _signalBus;
		}

		public function set signalBus(signalBus : CommonSignalBus) : void 
		{
			_signalBus = signalBus;
		}

		public function fadeIn() : void
		{
			this.alpha = 0;
			TweenMax.to(this, 1, {autoAlpha:1, onComplete:fadeInComp});
		}

		public function fadeInComp() : void
		{
			signalBus.signal.dispatch(FADE_IN_COMP);
		}

		public function fadeOut() : void
		{
			TweenMax.to(this, 1, {autoAlpha:0, onComplete:fadeOutComp});
		}

		public function fadeOutComp() : void
		{
			signalBus.signal.dispatch(FADE_OUT_COMP);
		}

		public function getContext() : IContext
		{
			return null;
		}

		public function destory(e : Event) : void 
		{
		}
	}
}
