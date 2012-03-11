package com.merrycat.button
{
	import flash.media.Sound;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @author merrycat
	 * 
	 * 复杂按钮类，适用于包含的选中效果与鼠标划过效果不同的按钮对象，并支持多个层级的带入
	 */
	public class MCComplexBtn extends AbstractBtn implements IBtn
	{
		/**
		 * 带入的带有时间轴的鼠标OVER动画层，需设置起始和结尾的stop()方法
		 */
		public static const OVER : int = 1;
		
		/**
		 * 无时间轴的显示对象层
		 */
		public static const BASE : int = 2;
		
		/**
		 * 按钮选中后显示效果层
		 */
		public static const SELECTED : int = 3;
		
		//Sprite
		private var _baseImgs : Array;
		//MovieClip
		private var _overImgs : Array;
		//Sprite
		private var _selectedImgs : Array;
		
		private var _selectOverEff:Boolean;
		
		/**
		 * @param	elements			按钮分层元素
		 * @param	clickedFun			参见AbstractBtn基类
		 * @param	downEff				参见AbstractBtn基类
		 * @param	selectOverEff		按钮选中状态时,over效果是否播放
		 * @param	soundOverEff		参见AbstractBtn基类
		 */		
		public function MCComplexBtn( elements : Array, 
			clickedFun:Function = null, 
			downEff:Boolean = false, 
			selectOverEff:Boolean = true,
			soundOverEff:Sound = null
			)
		{
			super(clickedFun, downEff, soundOverEff);
			
			_selectOverEff = selectOverEff;
			
			elements.forEach( function( elementVO : BtnElementVO, ...param ):void
            {
            	var target : DisplayObject = elementVO.target;
            	
            	switch( elementVO.elementType )
            	{
            		case BASE:
            			if( !_baseImgs ) _baseImgs = [];
        				_baseImgs.push( target );
            			break;
            			
            		case OVER:
            		
            			MovieClip( target ).stop();
            			
            			if( !_overImgs ) _overImgs = [];
            			_overImgs.push( MovieClip( target ) );
            			break;
            			
            		case SELECTED:
            			if( !_selectedImgs ) _selectedImgs = [];
        				_selectedImgs.push( target );
            			break;
            	}
            	
            	this.addChild( target );
            } , this );
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			//如果只有base
			if( !( elements.length == 1 && ( elements[ 0 ] as BtnElementVO ).elementType == BASE ) )
			{
				selected = false;
				
				this.addEventListener( MouseEvent.MOUSE_OVER, overHandler );
				this.addEventListener( MouseEvent.MOUSE_OUT, outHandler );
			}
		}
		
		override protected function overHandler( e : MouseEvent = null ):void
		{
			if( !selected )
			{
				_overImgs.forEach( function( target : MovieClip, ...param ):void
            	{
            		target.removeEventListener( Event.ENTER_FRAME, efHandler );
            		
            		if( target.currentFrame != target.totalFrames )
            			target.play();
           		});
			} 
		}
		
		override protected function outHandler( e : MouseEvent = null ):void
		{
			if( !selected )
			{
				_overImgs.forEach( function( target : MovieClip, ...param ):void
            	{
//            		if( target.currentFrame != 1 ) 
            			target.addEventListener( Event.ENTER_FRAME, efHandler );
           		});
			} 
		}
		
		private function efHandler( e : Event ):void
		{
			var target : MovieClip = e.currentTarget as MovieClip;
			
			if( target.currentFrame > 1 )
				target.prevFrame();
			else
				target.removeEventListener( Event.ENTER_FRAME, efHandler );
		}
		
		override public function set selected( b : Boolean ):void
		{
			super.selected = b;
			
			if( _selectedImgs )
			{
				_selectedImgs.forEach( function( target : DisplayObject, ...param ):void
            	{
            		target.visible = b;
           		});
				
				_overImgs.forEach( function( target : MovieClip, ...param ):void
            	{
            		target.gotoAndStop( 1 );
           		});
           		//////////////////////////////////////
           		if( b )
				{
					_overImgs.forEach( function( target : MovieClip, ...param ):void
	            	{
	            		target.gotoAndStop( target.totalFrames );
	           		});
				}else
				{
					_overImgs.forEach( function( target : MovieClip, ...param ):void
	            	{
	            		target.gotoAndStop( 1 );
	           		});
				}
			}else
			{
				if( b && _selectOverEff )
				{
					_overImgs.forEach( function( target : MovieClip, ...param ):void
	            	{
	            		target.gotoAndStop( target.totalFrames );
	           		});
				}else
				{
					_overImgs.forEach( function( target : MovieClip, ...param ):void
	            	{
	            		target.gotoAndStop( 1 );
	           		});
				}
			}
			
			this.mouseEnabled = !b;
		}
		
		override protected function destory( e:Event = null ):void
		{
			_overImgs.forEach( function( target : MovieClip, ...param ):void
			{
				target.removeEventListener( Event.ENTER_FRAME, efHandler );
			});
		}
	}
}