package com.merrycat.page 
{

	/**
	 * @author merrycat
	 * 分页类
	 */
	public class PageList 
	{
		/**
		 * 索引由0开始
		 */
		private var _currPageIdx : int = 0;
		
		private var _dpArr : Array;
		
		private var _itemPerPage : int = 10;

		private var _totalPage : int;

		private var _isLoop : Boolean = false;

		private var _currPageItems : Array;
		
		private var _startIdx : Number;

		/**
		 * @param	dpArr				源数据
		 * @param	itemPerPage			每页条目数
		 * @param	isLoop				上|下一页是否首尾循环
		 * @param	currPageIdx			当前页，索引由0开始
		 */
		public function PageList(dpArr : Array, itemPerPage : int = 10, isLoop : Boolean = false, currPageIdx : int = 0) 
		{
			this.dpArr = dpArr;
			
			if(dpArr.length == 0)
			{
				throw new Error("not data");
			}
			
			_itemPerPage = itemPerPage;
			
			_isLoop = isLoop;
			
			this.currPageIdx = currPageIdx;
			
			_totalPage = Math.ceil(dpArr.length / itemPerPage);
		}
		
		/**
		 * 下一页
		 */
		public function nextPage() : void 
		{
			if(hasNextPage)
			{
				currPageIdx++;
			}
			else
			{
				if(_isLoop)
				{
					currPageIdx = 0;
				}
			}
		}
		
		/**
		 * 上一页
		 */
		public function prevPage() : void 
		{
			if(hasPrevPage)
			{
				currPageIdx--;
			}
			else
			{
				if(_isLoop)
				{
					currPageIdx = totalPage - 1;
				}
			}
		}
		
		/**
		 * 当前页是否为第一页
		 */
		public function get isFirstPage() : Boolean 
		{
			return (currPageIdx == 0) ? true : false;
		}
		
		/**
		 * 当前页是否为最后一页
		 */
		public function get isLastPage() : Boolean 
		{
			return (currPageIdx == totalPage - 1) ? true : false;
		}
		
		/**
		 * 返回当前页所有条目
		 */
		public function get currPageItems() : Array 
		{
			if(!_currPageItems)
			{
				if(currPageIdx != totalPage - 1)
				{
					_startIdx = _itemPerPage * currPageIdx;
					_currPageItems = dpArr.slice(_startIdx, _startIdx + _itemPerPage);
				}
				else
				{
					var leftNum : int = dpArr.length % _itemPerPage;
					
					if(leftNum == 0)
					{
						leftNum = _itemPerPage;
					}
					
					_startIdx = _itemPerPage * currPageIdx;
					_currPageItems = dpArr.slice(_startIdx, _startIdx + leftNum);
				}
			}
			
			return _currPageItems;
		}
		
		/**
		 * 是否有上一页
		 */
		public function get hasPrevPage() : Boolean 
		{
			return (currPageIdx >= 1) ? true : false;
		}
		
		/**
		 * 是否有下一页
		 */
		public function get hasNextPage() : Boolean 
		{
			return (currPageIdx <= totalPage - 2) ? true : false;
		}
		
		/**
		 * 获得总页数
		 */
		public function get totalPage() : int 
		{
			return _totalPage;
		}

		public function set currPageIdx(value : int) : void 
		{
			_currPageIdx = value;
			
			_currPageItems = null;
		}

		public function get currPageIdx() : int 
		{
			return _currPageIdx;
		}

		public function set dpArr(value : Array) : void 
		{
			_dpArr = value;
		}

		public function get dpArr() : Array 
		{
			return _dpArr;
		}
	}
}
