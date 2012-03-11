package com.merrycat.resize 
{
	import org.casalib.collection.List;
	import org.casalib.util.StageReference;

	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author merrycat
	 * 
	 * 舞台缩放控制类，
	 * 用于控制显示对象适应屏幕缩放、对齐
	 * （注：同时支持StageAlign.TOP_LEFT与CENTER模式）
	 * 
	 * @see MResizerVO
	 */
	public class MResizer 
	{
		private static var instance : MResizer;

		/**
		 * 记录列表
		 */
		private var _resizes : List;

		/**
		 * 屏幕原始尺寸（主要记录宽高）
		 */
		public static var defaultRect : Rectangle = new Rectangle(0, 0, 1000, 600);

		private var _matrix : Matrix;

		public function MResizer( pw : PrivateClass ) : void
		{
			_resizes = new List();
			
			StageReference.getStage().addEventListener(Event.RESIZE, resizeHandler);
		}

		public static function getInstance() : MResizer
		{
			if ( instance == null )
				instance = new MResizer(new PrivateClass());
				
			return instance;
		}

		/**
		 * 添加需要监听舞台缩放的对象，属性由MResizerVO类指定
		 * 
		 * @param	vo			带有属性的显示对象
		 */
		public function add(vo : MResizerVO) : void 
		{
			if(_resizes.contains(vo))
			{
				return;	
			}
			
			switch(vo.type)
			{
				case MResizerVO.ALIGN_BY_VALUE:
					if(!isNaN(vo.x) && vo.x < defaultRect.width / 2)
					{
						vo.reviseX = -1;
					}
					if(!isNaN(vo.y) && vo.y < defaultRect.height / 2)
					{
						vo.reviseY = -1;
					}
					break; 
					
				case MResizerVO.SCALE_WITH_MAX:
				
					break;
					
				case MResizerVO.SCALE_WITH_MIN:
				
					break;
					
				case MResizerVO.ALIGN_BY_PERCENT:
				
					if(!vo.refTarget)
					{
						vo.refTarget = StageReference.getStage();
					}
				
					break;
			}
			
			vo.target.addEventListener(Event.REMOVED_FROM_STAGE, removeTarget);
			
			_resizes.addItem(vo);
			
			update();
		}

		/**
		 * 移除需要监听舞台缩放的对象，属性由MResizerVO类指定
		 * 
		 * @param	vo			带有属性的显示对象
		 */
		public function remove(vo : MResizerVO) : void 
		{
			if(vo && _resizes.contains(vo))
			{
				_resizes.removeItem(vo);
				vo = null;
			}
		}

		private function resizeHandler(e : Event = null) : void 
		{
			_resizes.toArray().forEach(function( vo : MResizerVO, ... param ) : void
			{
				if(vo.target.stage)
				{
					switch(vo.type)
					{
						case MResizerVO.ALIGN_BY_VALUE:
							
							if(StageReference.getStage().align != StageAlign.TOP_LEFT)
							{
								if(!isNaN(vo.x))
									vo.target.x = vo.reviseX * (StageReference.getStage().stageWidth - defaultRect.width) / 2 + vo.x;
									
								if(!isNaN(vo.y))
									vo.target.y = vo.reviseY * (StageReference.getStage().stageHeight - defaultRect.height) / 2 + vo.y;
							}else
							{
								if(!isNaN(vo.x))
								{
									if(vo.reviseX == 1)
										vo.target.x = (StageReference.getStage().stageWidth - defaultRect.width) +  vo.x;
									else
										vo.target.x = vo.x;
								}
								
								if(!isNaN(vo.y))
								{
									if(vo.reviseY == 1)
										vo.target.y = (StageReference.getStage().stageHeight - defaultRect.height) + vo.y;
									else
										vo.target.y = vo.y;
								}
							}
							break; 
						
						case MResizerVO.SCALE_WITH_MAX:
						
							vo.targetScale = Math.max(StageReference.getStage().stageWidth / defaultRect.width, StageReference.getStage().stageHeight / defaultRect.height);
							_matrix = new Matrix(vo.targetScale, 0, 0, vo.targetScale);
							vo.target.transform.matrix = _matrix;
							
							if(StageReference.getStage().align != StageAlign.TOP_LEFT)
							{
								vo.target.x = -(StageReference.getStage().stageWidth - defaultRect.width ) / 2 + (StageReference.getStage().stageWidth - defaultRect.width * vo.targetScale ) / 2;
								vo.target.y = -(StageReference.getStage().stageHeight - defaultRect.height ) / 2 + (StageReference.getStage().stageHeight - defaultRect.height * vo.targetScale ) / 2; 
							}else
							{
								vo.target.x = (StageReference.getStage().stageWidth - defaultRect.width * vo.targetScale ) / 2;
								vo.target.y = (StageReference.getStage().stageHeight - defaultRect.height * vo.targetScale ) / 2; 
							}
	
							//						var stageScale : Number = StageReference.getStage().stageHeight / StageReference.getStage().stageWidth;
							//						if (stageScale <= vo.targetScale) 
							//						{
							//							vo.target.width = StageReference.getStage().stageWidth;
							//							vo.target.height = vo.target.width * vo.targetScale;
							//						} 
							//						else 
							//						{
							//							vo.target.height = StageReference.getStage().stageHeight;
							//							vo.target.width = vo.target.height / vo.targetScale;
							//						}
							//				
							//						vo.target.x = -(vo.target.width - defaultRect.width ) / 2;
							//						vo.target.y = -( vo.target.height - defaultRect.height ) / 2; 

							break;
						
						case MResizerVO.SCALE_WITH_MIN:
						
							vo.targetScale = Math.min(StageReference.getStage().stageWidth / defaultRect.width, StageReference.getStage().stageHeight / defaultRect.height);
							_matrix = new Matrix(vo.targetScale, 0, 0, vo.targetScale);
							vo.target.transform.matrix = _matrix;
							
							if(StageReference.getStage().align != StageAlign.TOP_LEFT)
							{
								vo.target.x = -(StageReference.getStage().stageWidth - defaultRect.width ) / 2 + (StageReference.getStage().stageWidth - defaultRect.width * vo.targetScale ) / 2;
								vo.target.y = -(StageReference.getStage().stageHeight - defaultRect.height ) / 2 + (StageReference.getStage().stageHeight - defaultRect.height * vo.targetScale ) / 2; 
							}else
							{
								vo.target.x = (StageReference.getStage().stageWidth - defaultRect.width * vo.targetScale ) / 2;
								vo.target.y = (StageReference.getStage().stageHeight - defaultRect.height * vo.targetScale ) / 2; 
							}
						
						case MResizerVO.ALIGN_BY_PERCENT:
						
							if(StageReference.getStage().align != StageAlign.TOP_LEFT)
							{
								// 当相关对象自适应全屏时，计算它的缩放后比例尺寸。
								var tmpTargets : Array = getVOByTarget(vo.refTarget);
								var refVo : MResizerVO;
								var hasTarget : Boolean = false;
								for (var i : int = 0; i < tmpTargets.length; i++) 
								{
									refVo = tmpTargets[i];
									if (refVo.type == MResizerVO.SCALE_WITH_MAX)
									{
										hasTarget = true;
										var refW:Number = defaultRect.width * refVo.targetScale;
										var refH:Number = defaultRect.height * refVo.targetScale;
										
										if(!isNaN(vo.percentX))
											vo.target.x = -( refW - defaultRect.width ) / 2 + refW * vo.percentX;
									
										if(!isNaN(vo.percentY))
											vo.target.y = -( refH - defaultRect.height ) / 2 + refH * vo.percentY;
										break;
									}
								}
								if (!hasTarget)
								{
									if(!isNaN(vo.percentX))
										vo.target.x = -( vo.refTarget.width - defaultRect.width ) / 2 + vo.refTarget.width * vo.percentX;
									
									if(!isNaN(vo.percentY))
										vo.target.y = -( vo.refTarget.height - defaultRect.height ) / 2 + vo.refTarget.height * vo.percentY;
								}
								
								//限定目标对象距离舞台边界的像素值距离
								if(vo.limit != MResizerVO.LIMIT_NONE)
								{
									if(vo.target.x + vo.target.width > defaultRect.width + (StageReference.getStage().stageWidth - defaultRect.width) / 2 - vo.limitX)
									{
										vo.target.x = defaultRect.width + (StageReference.getStage().stageWidth - defaultRect.width) / 2 - vo.target.width - vo.limitX;
									}
									
									if(vo.target.y + vo.target.height > defaultRect.height + (StageReference.getStage().stageHeight - defaultRect.height) / 2 - vo.limitY)
									{
										vo.target.y = defaultRect.height + (StageReference.getStage().stageHeight - defaultRect.height) / 2 - vo.target.height - vo.limitY;
									}
									
									if(vo.target.x < -(StageReference.getStage().stageWidth - defaultRect.width) / 2  + vo.limitX)
									{
										vo.target.x = -(StageReference.getStage().stageWidth - defaultRect.width) / 2 + vo.limitX;
									}
									
									if(vo.target.y < -(StageReference.getStage().stageHeight - defaultRect.height) / 2  + vo.limitY) 
									{
										vo.target.y = -(StageReference.getStage().stageHeight - defaultRect.height) / 2 + vo.limitY;
									}
								}
							}else
							{
								if(vo.percentX)
									vo.target.x = vo.refTarget.width * vo.percentX;
								
								if(vo.percentY)
									vo.target.y = vo.refTarget.height * vo.percentY;
							}
							
							break;
							
						case MResizerVO.BIND_POINT:
							
							var refPoint : Point = vo.refTarget.localToGlobal(new Point(vo.x, vo.y));
							var targetPoint : Point = vo.target.parent.globalToLocal(refPoint);
								
							vo.target.x = targetPoint.x + vo.offX;
							vo.target.y = targetPoint.y + vo.offY;
							
							//限定目标对象距离舞台边界的像素值距离
							if(vo.limit != MResizerVO.LIMIT_NONE)
							{
								if(vo.target.x + vo.target.width > defaultRect.width + (StageReference.getStage().stageWidth - defaultRect.width) / 2 - vo.limitX)
								{
									vo.target.x = defaultRect.width + (StageReference.getStage().stageWidth - defaultRect.width) / 2 - vo.target.width - vo.limitX;
								}
								
								if(vo.target.y + vo.target.height > defaultRect.height + (StageReference.getStage().stageHeight - defaultRect.height) / 2 - vo.limitY)
								{
									vo.target.y = defaultRect.height + (StageReference.getStage().stageHeight - defaultRect.height) / 2 - vo.target.height - vo.limitY;
								}
								
								if(vo.target.x < -(StageReference.getStage().stageWidth - defaultRect.width) / 2  + vo.limitX)
								{
									vo.target.x = -(StageReference.getStage().stageWidth - defaultRect.width) / 2 + vo.limitX;
								}
								
								if(vo.target.y < -(StageReference.getStage().stageHeight - defaultRect.height) / 2  + vo.limitY) 
								{
									vo.target.y = -(StageReference.getStage().stageHeight - defaultRect.height) / 2 + vo.limitY;
								}
							}
							
							break;
					}
					
					if(vo.roundCoordinate)
					{
						vo.target.x = Math.round(vo.target.x);
						vo.target.y = Math.round(vo.target.y);
					}
				}
			}, this);
		}

		/**
		 * 根据显示对象来获得MResizerVO
		 * 
		 * @param	target			监听缩放的显示对象
		 */
		public function getVOByTarget(target : DisplayObject) : Array 
		{
			var tmpTargets : Array = [];
			for(var i : int = 0;i < _resizes.size;i++)
			{
				var vo : MResizerVO = _resizes.getItemAt(i) as MResizerVO;
				if(vo.target == target)
				{
					tmpTargets.push(vo);
				}
			}
			
			return tmpTargets;
		}

		private function removeTarget(e : Event) : void 
		{
			var t : DisplayObject = e.currentTarget as DisplayObject;
			t.removeEventListener(Event.REMOVED_FROM_STAGE, removeTarget);
			
			var tmpTargets : Array = getVOByTarget(t);
			
			for (var i : int = 0; i < tmpTargets.length; i++) 
			{
				remove(tmpTargets[i]);
			}
		}

		/**
		 * 强制运算一次舞台缩放并刷新屏幕
		 */
		public function update() : void 
		{
			resizeHandler();
		}
		
		/**
		 * 获得缩放系数
		 * @param	mode			缩放模式
		 */
		public function getScaleRatio(mode:String) : Number
		{
			switch(mode)
			{
				case MResizerVO.SCALE_WITH_MAX:
					return Math.max(StageReference.getStage().stageWidth / defaultRect.width, StageReference.getStage().stageHeight / defaultRect.height);
					break;
				case MResizerVO.SCALE_WITH_MIN:
					return Math.min(StageReference.getStage().stageWidth / defaultRect.width, StageReference.getStage().stageHeight / defaultRect.height);
					break;
			}
			
			return 1;
		}
		
		/**
		 * 获得缩放偏移位置
		 * @param	mode			缩放模式
		 */
		public function getOffect(mode:String) : Point
		{
			return new Point(-(StageReference.getStage().stageWidth - defaultRect.width ) / 2 + (StageReference.getStage().stageWidth - defaultRect.width * getScaleRatio(mode) ) / 2,
							-(StageReference.getStage().stageHeight - defaultRect.height ) / 2 + (StageReference.getStage().stageHeight - defaultRect.height * getScaleRatio(mode) ) / 2); 
		}
	}
}

class PrivateClass
{
}