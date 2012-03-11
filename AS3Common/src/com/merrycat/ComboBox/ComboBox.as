package com.merrycat.ComboBox
{
	import com.greensock.TweenLite;
	import com.merrycat.ViewBase;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import org.casalib.util.StageReference;

	/**
	 * ...
	 * @author ZUOCHEN.CHEN | coward_c@hotmail.com
	 * @since 2009-4-1 12:34
	 * 
	 * 2010-6-29 由 merrycat根据项目需要修改
	 */

	/*-------------参数说明----------------
	 * itemHeight  每项目高度    默认20
	 * itemWidth   每项宽度      默认0
	 * fillColor   背景颜色
	 * fillAlpha   背景透明度
	 * hightLightColor   高亮背景颜色
	 * hightLightAlpha   高亮背景透明度
	 * itemFont    选项文字字体
	 * itemColor   选项文字颜色
	 * itemSize    选项文字字号
	 * itemCopyHightLightColor   文字高亮颜色
	 * maxShow     最多显示多少项
	 */
	
	public class ComboBox extends ViewBase 
	{
		private var _list : Array = new Array();
		private var _openType : Boolean = false;

		public var itemHeight : Number = 18;
		public var itemWidth : Number = 0;
		public var fillColor : int = 0xFFFFFF;
		public var fillAlpha : Number = 1;
		public var hightLightColor : uint = 0x007bc5;
		public var hightLightAlpha : Number = 1;
		public var itemFont : String = "Arial";
		public var itemColor : int = 0xaaaaaa;
		public var itemSize : int = 12;
		public var itemCopyHightLightColor : int = 0xffffff;

		public var unavailableFontColor : uint = 0xc8c8c8;

		private var _titleColor : int = 0xaaaaaa;
		private var _titleSize : int = 12;
		private var _titleFont : String = "Arial";
		private var _answer : Object = null;
		private var _defaultCopy : String = "请选择";
		private var _baseX : Number;
		private var _baseY : Number;
		private var _barBaseX : Number;
		private var _barBaseY : Number;

		
		
		private var _bg : MovieClip = null ;
		private var _btn : MovieClip = null;
		private var _bar : MovieClip = null;
		private var _barBg : MovieClip = null;
		private var _titleTxt : TextField;
		private var _scroll : LiRoll = null;

		private var itemGetter : Sprite = new Sprite();
		private var mask_mc : Sprite = new Sprite();

		public var maxShow : int = 15;
		private var _itemX : Number = 0;
		private var _itemY : Number = 3;

		private var itemH : Number;

		public var availableIdx : int = 1;

		public var itemBg : Sprite;
		public var itemMask : Sprite;
		public var itemMask2 : Sprite;

		public function ComboBox(bgMc : MovieClip = null , btnMc : MovieClip = null, barMc : MovieClip = null, barBg : MovieClip = null ) : void
		{
		}

		private function init() : void
		{
			var bg : MovieClip = asset.getChildByName("bg") as MovieClip;
			var btn : MovieClip = asset.getChildByName("btn") as MovieClip;
			var bar : MovieClip = asset.getChildByName("bar") as MovieClip;
			var barBg : MovieClip = asset.getChildByName("barBg") as MovieClip;
			
			_bg = (_bg == null) ? MovieClip(bg) : _bg;
			_btn = (_btn == null) ? MovieClip(btn) : _btn;
			_btn.buttonMode = true;
			if (_bar == null)
			{
				try
				{
					_bar = MovieClip(bar);
					_barBaseX = _bar .x;
					_barBaseY = _bar .y;
				}catch (e : *)
				{
				}
			}
			else
			{
				_barBaseX = _bar .x;
				_barBaseY = _bar .y;
			}
			if (_barBg == null )
			{
				try
				{
					_barBg = MovieClip(barBg);
				}catch (e : *)
				{
				}
			}
			showBar(false);
			itemBg = new Sprite();
			itemBg.x = _baseY;
			
			itemMask = new Sprite();
			asset.addChild(itemMask);
			
			itemMask2 = new Sprite();
			asset.addChild(itemMask2);
			
			asset.addChild(itemBg);
			asset.addChild(itemGetter);
			asset.addChild(mask_mc);
			
			_baseX = _bg.x + _itemX;
			_baseY = _bg.y + _bg.height + _itemY;

			
			itemGetter.x = _baseX;
			itemGetter.y = _baseY;
			
			mask_mc.x = _baseX;
			mask_mc.y = _baseY;
			mask_mc.mouseChildren = false;
			mask_mc.mouseEnabled = false;
			
			itemWidth = _bg.width;
			
			_titleTxt = getTextField(_defaultCopy, _titleFont, _titleSize, _titleColor);
			//			_titleTxt.x=-5;
			_titleTxt.y = -1;
			_bg.addChild(_titleTxt);
			
			setEvent();
		}

		/**
		 * 设置内容数组 [{name:name,data:data},......]
		 */
		public function set list(l : Array) : void
		{
			_list = l;
			reset();
			dispatchEvent(new ComboBoxEvent(ComboBoxEvent.CHANGED, _list));
		}

		public function get list() : Array
		{
			return _list;
		}

		//------选项展开 关闭 由场景关闭-----------
		private function setEvent() : void
		{
			_bg.addEventListener(MouseEvent.CLICK, clickHandler);
			_btn.addEventListener(MouseEvent.CLICK, clickHandler);
		}

		private function clickHandler(evt : MouseEvent) : void
		{
			if (!_openType)
			{
				expand();
			}
			else
			{
				close();
			}
		}

		private function expand() : void
		{
			if (!_openType)
			{
				if (_list.length == 0)
				{
					throw new Error("my list is empty::::myComboBox.list=[...]");
					return ;
				}
				var showNum : int = Math.min(maxShow, _list.length);
				//var g:Graphics = itemGetter.graphics;
				itemH = showNum * itemHeight;
				var g : Graphics = itemBg.graphics;
				g.lineStyle(1, 0xc8c6c5);
				g.beginFill(fillColor, fillAlpha);
//				g.beginFill(0xFF0000, 1);
				g.drawRect(_baseX, _baseY, _bg.width - 2, itemH);
				g.endFill();
				
				var gMask : Graphics = itemMask.graphics;
				gMask.beginFill(0x000000);
				gMask.drawRect(_baseX, _baseY, _bg.width - 2, itemH);
				gMask.endFill();
				
				var gMask2 : Graphics = itemMask2.graphics;
				gMask2.beginFill(0x000000);
//				gMask2.drawRect(_baseX, _baseY, _bg.width - 2, itemH);
				gMask2.drawRect(_baseX, _baseY, _bg.width - 0, itemH + 2);
				gMask2.endFill();
				
				var j : int = 0;
				
				for (var i:String in _list)
				{
					var it : Sprite = buildItem(_list[i], j);
					it.name = i;
					it.y = itemHeight * Number(i);
					itemGetter.addChild(it);
					if( j <= availableIdx)
					{
						it.addEventListener(MouseEvent.MOUSE_OVER, itemOverHandler);
						it.addEventListener(MouseEvent.MOUSE_OUT, itemOutHandler);
						it.addEventListener(MouseEvent.CLICK, itemClick);
					}
					j++;
				}
				
				_openType = true;
				
				if ((Number(i) + 1) > maxShow)
				{
					buildScrollBar();
				}else
				{
					itemGetter.mask = itemMask;
				}
				itemMask.visible = false;
				itemMask2.visible = false;
				
				itemBg.mask = itemMask2;
				itemBg.y = itemGetter.y = _baseY - itemH;
				TweenLite.to(itemBg, 0.5, { y:0 });
				TweenLite.to(itemGetter, 0.5, { y:_baseY });
				
				//				itemMask.y = _baseY-itemH;

				
				/*TweenLite.to( itemMask, 0.5, { y:0 } );
				TweenLite.to( itemMask2, 0.5, { y:0 } );*/
				
				StageReference.getStage().addEventListener(MouseEvent.MOUSE_DOWN, stageClose);
			}
		}

		
		private function close() : void
		{
			if (_openType)
			{
				_openType = false;
				asset.graphics.clear();
				mask_mc.graphics.clear();
				itemBg.graphics.clear();
				if (_scroll != null )
				{
					_scroll.clear();
				}
				do
				{
					var t : Sprite = itemGetter.getChildAt(0) as Sprite;
					
					clearItemEvent(t);
					itemGetter.removeChild(t);
				}while (itemGetter.numChildren != 0);
				
				StageReference.getStage().removeEventListener(MouseEvent.MOUSE_DOWN, stageClose);

				showBar(false);
			}
		}

		private function stageClose(evt : MouseEvent) : void
		{
			if (_bar != null)
			{
				if (_bar.hitTestPoint(StageReference.getStage().mouseX, StageReference.getStage().mouseY, false) )
				{
					return;
				}
			}
			if (_barBg != null )
			{
				if (_barBg.hitTestPoint(StageReference.getStage().mouseX, StageReference.getStage().mouseY, false))
				{
					return;
				}
			}
			if (mask_mc.hitTestPoint(StageReference.getStage().mouseX, StageReference.getStage().mouseY, false))
			{
				return;
			}
			if (itemGetter.hitTestPoint(StageReference.getStage().mouseX, StageReference.getStage().mouseY, false))
			{
				return;
			}
			close();
		}

		//-----建立选项-------
		private function buildItem(obj : Object, idx : int) : Sprite
		{
			var name : String = String(obj["name"]);
			if (obj["name"] == null || obj["name"] == "undefined")
			{
				throw new Error("选项数组中的每个对象都必须有 name属性  {name:myName,data:myData}");
				return;
			}
			
			
			
			var t : Sprite = new Sprite();
			var bm : Bitmap = new Bitmap(new BitmapData(itemWidth, itemHeight, false, hightLightColor));
			bm.alpha = 0;
			bm.name = "bm";
			t.addChild(bm);
			var tx : TextField;
			if( idx <= availableIdx )
			{
				tx = getTextField(name, itemFont, itemSize, itemColor);
			}
			else
			{
				tx = getTextField(name, itemFont, itemSize, unavailableFontColor);
			}
			tx.name = "text_txt";
			t.addChild(tx);
			tx.x = 2;
			return t;
		}

		//-----建立 scrollBar------
		private function buildScrollBar() : void
		{
			if (_bar != null )
			{
				drawMask();
				goBack();
				showBar(true);
				if (_barBg != null)
				{
					//_barBg.height=mask_mc.height
					_barBg.height = itemH;
				}
				_scroll = new LiRoll(itemGetter, mask_mc, _bar);
			}
			else
			{
				throw new Error("请设置 scrollBar----格式为: yourComboBox.scrollBar = yourScrollBar_mc");
			}
		}

		//----设置 bar的可见-----
		private function showBar(b : Boolean) : void
		{
			if (_bar != null )
			{
				_bar.visible = b;
			}
			if (_barBg != null)
			{
				_barBg.visible = b;
			}
		}

		//-----还原 getter mask bar -----
		private function goBack() : void
		{
			//			trace("_baseY::::"+_baseY);
			itemGetter.x = _baseX;
			itemGetter.y = _baseY;
			
			mask_mc.x = _baseX;
			mask_mc.y = _baseY;
			
			_bar.x = _barBaseX;
			_bar.y = _barBaseY;
		}

		//------画出mask------
		private function drawMask() : void
		{
			var m : Graphics = mask_mc.graphics;
			var dy : int = 4;
			m.clear();
			m.beginFill(0xffffff, 1);
			m.drawRect(0, dy, itemWidth, (itemHeight * maxShow) - (dy * 2));
			m.endFill();
		}

		//------选项鼠标事件-------
		private function itemOverHandler(evt : MouseEvent) : void
		{
			var t : Sprite = evt.currentTarget as Sprite;
			var bm : Bitmap = t.getChildByName("bm") as Bitmap;
			bm.alpha = hightLightAlpha;
			
			var tx : TextField = t.getChildByName("text_txt") as TextField;
			var tf : TextFormat = new TextFormat();
			tf.color = itemCopyHightLightColor;
			tx.setTextFormat(tf);
		}

		private function itemOutHandler(evt : MouseEvent) : void 
		{
			var t : Sprite = evt.currentTarget as Sprite;
			var bm : Bitmap = t.getChildByName("bm") as Bitmap;
			bm.alpha = 0;
			var tx : TextField = t.getChildByName("text_txt") as TextField;
			var tf : TextFormat = new TextFormat();
			tf.bold = true;
			tf.color = itemColor;
			tx.setTextFormat(tf);
		}

		private function itemClick(evt : MouseEvent) : void
		{
			close();
			getAnswer(Number(evt.currentTarget.name));
		}

		//-----从点击获得结果--------
		private function getAnswer(i : int) : void
		{
			_answer = _list[i];
			updateTitle(_answer.name);
			var myData : String = String(_answer.data);
			if (myData == null || myData == "undefined")
			{
				myData = String(_answer.name);
			}
			var myEvt : ComboBoxEvent = new ComboBoxEvent(ComboBoxEvent.HAVE_ANSWER, myData);
			dispatchEvent(myEvt);
		}

		private function clearItemEvent(it : Sprite) : void
		{
			it.removeEventListener(MouseEvent.MOUSE_OVER, itemOverHandler);
			it.removeEventListener(MouseEvent.MOUSE_OUT, itemOutHandler);
			it.removeEventListener(MouseEvent.CLICK, itemClick);
		}

		//---------输出txt-----------
		private function getTextField(str : String,font : String = "宋体",size : int = 12,color : int = 0xcdcdcd) : TextField
		{
			var temp_txt : TextField = new TextField();
			temp_txt.height = itemHeight;
			temp_txt.width = itemWidth;
			var tf : TextFormat = new TextFormat(font, size, color);
			tf.bold = true;
			temp_txt.text = str;
			temp_txt.selectable = false;
			temp_txt.setTextFormat(tf);
			return temp_txt;
		}

		//------更新显示-----
		private function updateTitle(str : String = null ) : void
		{
			if (_answer == null)
			{
				str = (str == null ) ? defaultCopy : str;
			}
			else
			{
				str = (str == null ) ? _answer.name : str;
			}
			_titleTxt.text = str;
			var tf : TextFormat = new TextFormat(_titleFont, _titleSize, _titleColor);
			tf.bold = true;
			tf.align = TextFormatAlign.CENTER;
			_titleTxt.setTextFormat(tf);
			bitmapTxt(_titleTxt);
		}

		/**
		 * 设置title默认文字
		 */
		public function set defaultCopy(str : String) : void
		{
			_defaultCopy = str;
			updateTitle(str);
		}

		public function get defaultCopy() : String
		{
			return _defaultCopy;
		}

		/**
		 * 返回所选项的值
		 */
		public function get answer() : String
		{
			if (_answer != null )
			{
				if (_answer.data != null )
				{
					return String(_answer.data);
				}
				else
				{
					return String(_answer.name);
				}
			}
			else
			{
				return null;
			}
		}

		/**
		 * 设置所选项
		 * @param	n 选项序号
		 */
		public function  setAnswer(n : int) : void
		{
			if (n < _list.length)
			{
				getAnswer(n);
			}
			else
			{
				throw new Error("索引超出范围");
			}
		}

		/**
		 * 重置
		 */
		public function reset() : void
		{
			close();
			updateTitle(_defaultCopy);
			_answer = null;
			if (_scroll != null )
			{
				_scroll.clear();
				_scroll = null;
			}

			mask_mc.graphics.clear();
		}

		/**
		 * 设置title 内容
		 */
		public function get titleTxt() : TextField
		{
			return _titleTxt;
		}

		public function set titleTxt(txt : TextField) : void
		{
			throw new Error("titleTxt is read only");
		}

		/**
		 * 设置ttile字体
		 */
		public function get titleFont() : String
		{
			return _titleFont;
		}

		public function set titleFont(str : String) : void
		{
			_titleFont = str;
			updateTitle();
		}

		/**
		 * 设置title颜色
		 */
		public function get titleColor() : int
		{
			return _titleColor;
		}

		public function set titleColor(n : int) : void
		{
			_titleColor = n;
			updateTitle();
		}

		/**
		 * 设置title 文字字号
		 */
		public function get titleSize() : uint
		{
			return _titleSize;
		}

		public function set titleSize(n : uint) : void
		{
			_titleSize = n;
			updateTitle();
		}

		/**
		 * 设置下拉项相对于 bg 的位置
		 */
		public function set itemX(n : Number) : void
		{
			_itemX = n;
			_baseX = _bg.x + _itemX;

			itemGetter.x = _baseX;
		}

		public function get itemX() : Number
		{
			return _baseX;
		}

		/**
		 * 设置下拉项相对于 bg 的位置
		 */
		public function set itemY(n : Number) : void
		{
			_itemY = n;
			_baseY = _bg.y + _bg.height + _itemY;
			itemGetter.y = _baseY;
		}

		public function get itemY() : Number
		{
			return _baseY;
		}

		/**
		 * 将txt设置为bitmap
		 * @param	tf 需cache的txt
		 */
		private function bitmapTxt(tf : TextField) : void
		{
			tf.filters = [new BlurFilter(0, 0, 0)];
		}

		override public function set asset( s : Sprite ) : void
		{
			super.asset = s;
			
			init();
		}
	}
}