package com.merrycat.scrollbar
{
	import com.greensock.TweenLite;
	import com.merrycat.ViewBase;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import org.casalib.util.StageReference;
	
	/**
	 * @author merrycat
	 * 滚动类
	 */
	public class Scrollbar extends ViewBase
	{
		private var target:MovieClip;

		private var top:Number;

		private var bottom:Number;

		private var dragBot:Number;

		private var range:Number;

		private var ratio:Number;

		private var sPos:Number;

		private var sRect:Rectangle;

		private var ctrl:Number; //This is to adapt to the target's position

		private var timing:Number;

		private var isUp:Boolean;

		private var isDown:Boolean;

		private var isArrow:Boolean;

		private var arrowMove:Number;

		private var upArrowHt:Number;

		private var downArrowHt:Number;

		private var sBuffer:Number;

		private var _scroller:MovieClip;

		private var _track:MovieClip;

		private var _upArrow:MovieClip;

		private var _downArrow:MovieClip;
		
		private var _autoMask:Boolean = true;

		public function Scrollbar():void
		{
		}
		
		/**
		 * 初始化
		 * 
		 * @param	t					滚动对象容器
		 * @param	tt					缓动时间
		 * @param	sa					是否显示上下箭头
		 * @param	b					缓冲
		 * @param	autoMask			自动按照滚动条高度创建遮罩
		 */
		public function init( t:MovieClip , tt:Number , sa:Boolean , b:Number , parent:MovieClip, autoMask:Boolean = true ):void
		{
			_autoMask = autoMask;
			
			this.addEventListener( Event.REMOVED_FROM_STAGE , destory );

//			parent.addEventListener(MouseEvent.MOUSE_UP, stopScroll);			
			StageReference.getStage().addEventListener( MouseEvent.MOUSE_UP , stopScroll );

			target = t;
			timing = tt;
			isArrow = sa;
			sBuffer = b;
			
			_scroller.y = 0;
			
			if ( target.height <= _track.height )
			{
				asset.visible = false;
			}else
			{
				asset.visible = true;
			}

			//
			upArrowHt = _upArrow.height;
			downArrowHt = _downArrow.height;

			if ( isArrow )
			{
				top = _scroller.y;
				dragBot = ( _scroller.y + _track.height ) - _scroller.height;
				bottom = _track.height - ( _scroller.height / sBuffer );

			}
			else
			{
				top = _scroller.y;
				dragBot = ( _scroller.y + _track.height ) - _scroller.height;
				bottom = _track.height - ( _scroller.height / sBuffer );

				upArrowHt = 0;
				downArrowHt = 0;
				asset.removeChild( _upArrow );
				asset.removeChild( _downArrow );
			}
			range = bottom - top;
			sRect = new Rectangle( 0 , top , 0 , dragBot );
			ctrl = target.y;
			//set Mask
			isUp = false;
			isDown = false;
			arrowMove = 10;

			if ( isArrow )
			{
				_upArrow.addEventListener( Event.ENTER_FRAME , upArrowHandler );
				_upArrow.addEventListener( MouseEvent.MOUSE_DOWN , upScroll );
				_upArrow.addEventListener( MouseEvent.MOUSE_UP , stopScroll );
				//
				_downArrow.addEventListener( Event.ENTER_FRAME , downArrowHandler );
				_downArrow.addEventListener( MouseEvent.MOUSE_DOWN , downScroll );
				_downArrow.addEventListener( MouseEvent.MOUSE_UP , stopScroll );
			}
			
			if ( _autoMask )
			{
				var square:Sprite = new Sprite();
				square.addEventListener( MouseEvent.MOUSE_WHEEL , mouseWheelHandler );
				square.graphics.beginFill( 0xFF0000, 0 );
				square.graphics.drawRect( target.x , target.y , target.width + 5 , ( _track.height + upArrowHt + downArrowHt ));
				parent.addChild( square );
				target.mask = square;
			}else
			{
				t.addEventListener( MouseEvent.MOUSE_WHEEL , mouseWheelHandler );
			}
		}

		public function upScroll( event:MouseEvent ):void
		{
			isUp = true;
		}

		public function downScroll( event:MouseEvent ):void
		{
			isDown = true;
		}

		public function upArrowHandler( event:Event ):void
		{
			if ( isUp )
			{
				if ( _scroller.y > top )
				{
					_scroller.y -= arrowMove;

					if ( _scroller.y < top )
					{
						_scroller.y = top;
					}
					startScroll();
				}
			}
		}

		//
		public function downArrowHandler( event:Event ):void
		{
			if ( isDown )
			{
				if ( _scroller.y < dragBot )
				{
					_scroller.y += arrowMove;

					if ( _scroller.y > dragBot )
					{
						_scroller.y = dragBot;
					}
					startScroll();
				}
			}
		}

		//
		public function dragScroll( event:MouseEvent ):void
		{
			_scroller.startDrag( false , sRect );
			StageReference.getStage().addEventListener( MouseEvent.MOUSE_MOVE , moveScroll );
		}

		//
		public function mouseWheelHandler( event:MouseEvent ):void
		{
			if ( event.delta < 0 )
			{
				if ( _scroller.y < dragBot )
				{
					_scroller.y -= ( event.delta * 2 );

					if ( _scroller.y > dragBot )
					{
						_scroller.y = dragBot;
					}
					startScroll();
				}
			}
			else
			{
				if ( _scroller.y > top )
				{
					_scroller.y -= ( event.delta * 2 );

					if ( _scroller.y < top )
					{
						_scroller.y = top;
					}
					startScroll();
				}
			}
		}

		//
		public function stopScroll( event:MouseEvent ):void
		{
			isUp = false;
			isDown = false;
			_scroller.stopDrag();

			StageReference.getStage().removeEventListener( MouseEvent.MOUSE_MOVE , moveScroll );
		}

		//
		public function moveScroll( event:MouseEvent ):void
		{
			startScroll();
		}

		public function startScroll():void
		{
			ratio = ( target.height - range ) / range;
			sPos = ( _scroller.y * ratio ) - ctrl;

			this.dispatchEvent( new ScrollBarEvent( ScrollBarEvent.CHANGE , _scroller.y / dragBot ));
//			trace(_scroller.y / dragBot)
//			trace(sPos)
			
			TweenLite.to(target, timing, {y: -sPos});
		}

		override public function destory( e:Event = null ):void
		{
			this.removeEventListener( Event.REMOVED_FROM_STAGE , destory );

			_scroller.removeEventListener( MouseEvent.MOUSE_DOWN , dragScroll );

			StageReference.getStage().removeEventListener( MouseEvent.MOUSE_UP , stopScroll );
			StageReference.getStage().removeEventListener( MouseEvent.MOUSE_MOVE , moveScroll );
		}
		
		override public function set asset(s:Sprite) : void
		{
			super.asset = s;
			
			_scroller = asset.getChildByName( "scroller" ) as MovieClip;
			_scroller.buttonMode = true;
			_track = asset.getChildByName( "track" ) as MovieClip;
			_upArrow = asset.getChildByName( "upArrow" ) as MovieClip;
			_upArrow.buttonMode = true;
			_downArrow = asset.getChildByName( "downArrow" ) as MovieClip;
			_downArrow.buttonMode = true;
			
			_scroller.addEventListener( MouseEvent.MOUSE_DOWN , dragScroll );
		}
	}
}