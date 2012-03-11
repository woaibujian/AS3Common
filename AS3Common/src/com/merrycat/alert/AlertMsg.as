package com.merrycat.alert
{
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import com.merrycat.alert.AlertMsgUIBase;

	import com.greensock.easing.Cubic;
	import com.merrycat.ViewBase;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.casalib.util.StageReference;
	
	/**
	 * @author merrycat
	 * 弹出控制类（配合AlertMsgUIBase使用）
	 * @see AlertMsgUIBase
	 */
	public class AlertMsg extends ViewBase
	{
		private static var instance : AlertMsg;

		public var alertIdDict:Dictionary;
		public var alertId : int;

		public function AlertMsg( pw : PrivateClass ) : void
		{
			super();
			
			alertIdDict = new Dictionary( true );
		}
		
		/**
		 * 移除弹出对象，并返回弹出的标识ID（以作移除和标识用）
		 * 
		 * @param	alertMsgUI			弹出UI
		 * @param	frame				当前弹出UI指向的帧（可以是帧数字，也可以是帧标签）
		 * @param	r					弹出约束的范围（计算中心点）
		 * @param	parent				承载并显示弹出的父对象
		 * @param	blurBmp				模糊背景传入的位图
		 * @param	percent				百分比定位
		 * @param	lock				是否锁定背景（不可点击）
		 * @param	lockColor			底色
		 * @param	lockAlpha			底色透明度
		 * @return						标识ID
		 * 
		 * @example
		 * _blurBmpd = new BitmapData(StageReference.getStage().stageWidth, StageReference.getStage().stageHeight);
			_blurMatrix = new Matrix();
			_blurMatrix.translate(( StageReference.getStage().stageWidth - MResizer.getInstance().defaultRect.width) / 2, 
				( StageReference.getStage().stageHeight - MResizer.getInstance().defaultRect.height ) / 2);
			_blurBmpd.draw( _interactScene, _blurMatrix );
			
			_alertId = AlertMsg.show(new PopupUICamp(), "2", MResizer.getInstance().defaultRect, 
				v, _blurBmpd,
				 null, true, 0xFFFFFF, 0.2);
		 * 
		 */
		public static function show( alertMsgUI:AlertMsgUIBase, 
			frame:String = "1", 
			r:Rectangle = null, 
			parent:DisplayObjectContainer = null,
			blurBmp:BitmapData = null,
			percent:Point = null,
			lock:Boolean = true,
			lockColor:uint = 0x000000,
			lockAlpha:Number = 0.5 ):int
		{
			if ( instance == null )
				instance = new AlertMsg( new PrivateClass());
				
			if(!percent)
			{
				percent = new Point(0.5, 0.5);
			}
				
			alertMsgUI.holder = new Sprite();
			
			if(parent)
			{
				alertMsgUI.parent = parent;
			}else
			{
				alertMsgUI.parent = StageReference.getStage();
			}
				
			alertMsgUI.parent.addChild( alertMsgUI.holder );
			alertMsgUI.holder.addChild( alertMsgUI.asset );
			
			alertMsgUI.asset.alpha = 0;
			
			alertMsgUI.asset.scaleX = 0;
			alertMsgUI.asset.scaleY = 0;
			
			if(!r)
			{
				r = StageReference.getStage().getRect(StageReference.getStage());	
			}
			
			alertMsgUI.asset.x = -( StageReference.getStage().stageWidth - r.width) / 2 + StageReference.getStage().stageWidth * percent.x;
			alertMsgUI.asset.y = -( StageReference.getStage().stageHeight - r.height ) / 2 + StageReference.getStage().stageHeight * percent.y;
			
			TweenMax.to( alertMsgUI.asset, 1, { 
				alpha : 1,
				scaleX: 1,
				scaleY: 1, 
				ease:Cubic.easeInOut,
				onComplete:function():void
				{
					alertMsgUI.onAddFun && alertMsgUI.onAddFun();
				}
			} );
			
			if(lock)
			{
				alertMsgUI.holder.graphics.beginFill(lockColor, lockAlpha);
//				alertMsgUI.holder.graphics.drawRect(
//					-( StageReference.getStage().stageWidth - r.width) / 2,
//				 	-( StageReference.getStage().stageHeight - r.height ) / 2,
//				 	StageReference.getStage().stageWidth, 
//					StageReference.getStage().stageHeight);
				alertMsgUI.holder.graphics.drawRect(
					-( 1920 - r.width) / 2,
				 	-( 1280 - r.height ) / 2,
				 	1920, 
					1280);
					
				alertMsgUI.holder.graphics.endFill();
			}
			
			if(blurBmp)
			{
				alertMsgUI.blurBmp = blurBmp;
				
				var blurBg:Sprite = new Sprite();
				blurBg.addChild(new Bitmap(blurBmp));
				blurBg.x = -( StageReference.getStage().stageWidth - r.width) / 2;
				blurBg.y = -( StageReference.getStage().stageHeight - r.height ) / 2;
				TweenMax.to(blurBg, 0.5, { blurFilter:{ blurX:10, blurY:10, quality:1 } } );
				alertMsgUI.holder.addChildAt( blurBg, 0 );
			}
			
			
			instance.alertIdDict[ ++instance.alertId ] = alertMsgUI;
			
			alertMsgUI.alertId = instance.alertId;
			
			alertMsgUI.label = frame;
			MovieClip( alertMsgUI.asset ).gotoAndStop( frame );
			
			return instance.alertId;
		}
		
		/**
		 * 根据弹出对象的标识ID移除弹出对象
		 * 
		 * @param	alertId			标识ID
		 */
		public static function removeById( alertId:int ):void
		{
			var alertMsgUI:AlertMsgUIBase = instance.alertIdDict[ alertId ] as AlertMsgUIBase;
			
			if(alertMsgUI)
			{
				TweenMax.to(alertMsgUI.asset, 0.5, {scaleX:0, scaleY:0});
				
				alertMsgUI.destory();
				
				TweenMax.to(alertMsgUI.holder, 0.3, {alpha:0, onComplete:function():void
					{
						alertMsgUI.parent.removeChild( alertMsgUI.holder);
						alertMsgUI.onRemoveFun && alertMsgUI.onRemoveFun();
						instance.alertIdDict[ alertId ] = null;
						
						if(alertMsgUI.blurBmp)
						{
							alertMsgUI.blurBmp.dispose();
						}
					}
				});
			}
		}
		
		/**
		 * 根据弹出对象的标识ID获取弹出的UI对象
		 * 
		 * @param	alertId			标识ID
		 * @return					UI对象
		 */
		public static function getAlertUIById(alertId:int):AlertMsgUIBase
		{
			return instance.alertIdDict[ alertId ];
		}
		
		/**
		 * 获取还在显示当中的Alert列表
		 * 
		 * @return					AlertMsgUIBase对象
		 */
		public static function getShowedAlerts():Array
		{
			if ( instance == null )
				instance = new AlertMsg( new PrivateClass());
				
			var arr : Array = [];
			for each (var i : AlertMsgUIBase in instance.alertIdDict) 
			{
				if(i)
				{
					arr.push(i);
				}
			}
			
			return arr;
		}
	}
}

class PrivateClass{}