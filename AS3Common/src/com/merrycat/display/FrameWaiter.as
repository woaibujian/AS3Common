package com.merrycat.display
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class FrameWaiter
	{
		private static var instance:FrameWaiter;

		private var _mcDict:Dictionary;

		private var _waiterId:int = 0;

		public function FrameWaiter( pw:PrivateClass ):void
		{
			_mcDict = new Dictionary( true );
		}

		public static function getInstance():FrameWaiter
		{
			if ( instance == null )
				instance = new FrameWaiter( new PrivateClass());

			return instance;
		}

		public function wait( numFrames:uint , callback:Function ):int
		{
			var fmc:FrameMc = new FrameMc();
			_waiterId++;
			_mcDict[ _waiterId ] = fmc;
			fmc.numFrames = numFrames;
			fmc.callback = callback;

			fmc.addEventListener( Event.ENTER_FRAME , ef );

			return _waiterId;
		}

		private function ef( e:Event ):void
		{
			var fmc:FrameMc = e.currentTarget as FrameMc;
			fmc.numFrames--;

			if ( fmc.numFrames == 0 )
			{
				fmc.removeEventListener( Event.ENTER_FRAME , ef );
				fmc.callback();
			}
		}

		public function destoryByWaiterId( id:int ):void
		{
			if ( _mcDict[ id ])
			{
				_mcDict[ id ].removeEventListener( Event.ENTER_FRAME , ef );
				_mcDict[ id ] = null;
			}
		}

		public function destory():void
		{
			for (var id:* in _mcDict) 
			{ 
				destoryByWaiterId( id );
			} 
		}
	}
}
import flash.display.MovieClip;

class FrameMc extends MovieClip
{
	public var numFrames:uint;

	public var callback:Function;

	public function FrameMc()
	{
		super();
	}
}

class PrivateClass
{
}