package com.merrycat.tooltip 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * @author merrycat
	 * 
	 * Tooltip提示类
	 */
	public class MToolTip extends Sprite 
	{
		/**
		 * 圆角
		 */
		public static const ROUND_TIP : String = "roundTip";
		
		/**
		 * 方角
		 */
		public static const SQUARE_TIP : String = "squareTip";

		private static var OBO_TT : MToolTip;

		private var _adv : Boolean;
		private var _tipText : TextField;
		private var _tipColor : uint;
		private var _tipAlpha : Number;
		private var _format : TextFormat;
		private var _ds : DropShadowFilter;
		private var _root : DisplayObjectContainer;
		private var _userTip : String;
		private var _orgX : int;
		private var _orgY : int;

		/**
		 * MToolTip单例构造函数，请使用createToolTip方法创建对象实例
		 */
		public function MToolTip(tc : TipCreator, myRoot : DisplayObjectContainer, fontName : String, tipColor : uint = 0xFFFFFF, tipAlpha : Number = 1, tipShape : String = "roundTip", fontColor : uint = 0x000000, fontSize : int = 11, advRendering : Boolean = true) 
		{
			if (!tc is TipCreator) throw new Error("MToolTip class must be instantiated with static method MToolTip.createToolTip() method.");
         
			_root = myRoot;
			_tipColor = tipColor;
			_tipAlpha = tipAlpha;
			_userTip = tipShape;
			_adv = advRendering;
			_format = new TextFormat(fontName, fontSize, fontColor);
			_ds = new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3);
         
			this.mouseEnabled = false;
		}

		/**
		 * 创建MToolTip单例
		 * 
		 * @example
		 * <listing version="3.0">
		 * var toolTip:MToolTip = MToolTip.createToolTip(StageReference.getStage(), "宋体", 0x7C7C7C, 0.7, MToolTip.ROUND_TIP, 0xFFFFFF, 12, false);
		 * </listing>
		 * 
		 * @param   myRoot        tooltip承载对象
		 * @param   font          字体名
		 * @param   tipColor      背景颜色
		 * @param   tipAlpha      背景透明度
		 * @param   tipShape      背景类型<code>MToolTip.ROUND_TIP</code> or <code>MToolTip.SQUARE_TIP</code>，默认MToolTip.ROUND_TIP
		 * @param   fontColor     字体颜色
		 * @param   fontSize      字体尺寸
		 * @return				  MToolTip单例
		 */
		public static function createToolTip(myRoot : DisplayObjectContainer, fontName : String, tipColor : uint = 0xFFFFFF, tipAlpha : Number = 1, tipShape : String = "roundTip", fontColor : uint = 0x000000, fontSize : int = 11) : MToolTip 
		{
			if (OBO_TT == null) OBO_TT = new MToolTip(new TipCreator(), myRoot, fontName, tipColor, tipAlpha, tipShape, fontColor, fontSize);
			return OBO_TT;
		}

		/**
		 * 显示tip
		 * 
		 * @param	words 			tip内容文字
		 */
		public function addTip(words : String) : void 
		{
			removeTip();
			_root.addChild(this);
			_tipText = new TextField();
			_tipText.mouseEnabled = false;
			_tipText.selectable = false;
			_tipText.defaultTextFormat = _format;
			_tipText.antiAliasType = _adv ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
			_tipText.width = 1;
			_tipText.height = 1;
			_tipText.autoSize = TextFieldAutoSize.LEFT;
			//         _tipText.embedFonts = false;
			_tipText.multiline = true;
			_tipText.text = words;

			var w : Number = _tipText.textWidth;
			var h : Number = _tipText.textHeight;
         
			var tipShape : Array;
   
			switch (_userTip) 
			{
				case ROUND_TIP :
					tipShape = [[0, -13.42], [0, -2], [10.52, -15.7], [13.02, -18.01, 13.02, -22.65], [13.02, -16 - h], [13.23, -25.23 - h, 3.1, -25.23 - h], [-w , -25.23 - h], [-w - 7, -25.23 - h, -w - 7, -16 - h], [-w - 7, -22.65], [-w - 7, -13.42, -w, -13.42]];
					break;
				case SQUARE_TIP :
					tipShape = [[-((w / 2) + 5), -16], [-((w / 2) + 5), -((18 + h) + 4)], [((w / 2) + 5), -((18 + h) + 4)], [((w / 2) + 5), -16], [6, -16], [0, 0], [-6, -16], [-((w / 2) + 5), -16]];
					break;
				default :
					throw new Error("Undefined tool tip shape in OBO_ToolTip!");
					break;
			}
      
			var len : int = tipShape.length;
			this.graphics.beginFill(_tipColor, _tipAlpha);   
			for (var i : int = 0;i < len;i++) 
			{
				if (i == 0) 
				{
					this.graphics.moveTo(tipShape[i][0], tipShape[i][1]);
				} else if (tipShape[i].length == 2) 
				{
					this.graphics.lineTo(tipShape[i][0], tipShape[i][1]);
				} else if (tipShape[i].length == 4) 
				{
					this.graphics.curveTo(tipShape[i][0], tipShape[i][1], tipShape[i][2], tipShape[i][3]);
				}
			}
			this.graphics.endFill();
         
			this.x = stage.mouseX;
			this.y = stage.mouseY;
         
			this.filters = [_ds];
			_tipText.x = (_userTip == ROUND_TIP) ? Math.round(-w) : Math.round(-(w / 2)) - 2;
			_orgX = _tipText.x;
			_tipText.y = Math.round(-21 - h);
			_orgY = _tipText.y;
			this.addChild(_tipText);
         
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onTipMove);
		}
		
		private function onTipMove(me : MouseEvent) : void 
		{
      		
			this.x = Math.round(me.stageX);
			this.y = Math.round(me.stageY - 2);
         
         
         
			if (this.y - this.height < 0) 
			{
				this.scaleY = _tipText.scaleY = -1;
				_tipText.y = (_userTip == ROUND_TIP) ? -18 : -16;
				this.y = Math.round(me.stageY + 5);
			} 
			else 
			{
				this.scaleY = _tipText.scaleY = 1;
				_tipText.y = _orgY;
			}

			if (this.x - (this.width - 18) < 0) 
			{
				if (_userTip == ROUND_TIP) 
				{
					this.scaleX = _tipText.scaleX = -1;
					_tipText.x = 5;
				}
			} 
			else 
			{
				this.scaleX = _tipText.scaleX = 1;
				_tipText.x = _orgX;
			}
         
			me.updateAfterEvent();
		}

		/**
		 * 移除tip
		 */
		public function removeTip() : void 
		{
			if(_tipText)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTipMove);
				this.removeChild(_tipText);
				this.graphics.clear();
				_root.removeChild(this);
				_tipText = null;
			}
		}

		/**
		 * 设置tip类型
		 */
		public function set tipShape(shape : String) : void 
		{
			if (shape != ROUND_TIP && shape != SQUARE_TIP) throw new Error("Invalid tip shape \"" + shape + "\" specified at OBO_ToolTip.tipShape.");
			_userTip = shape;
		}
	}
}

internal class TipCreator {}