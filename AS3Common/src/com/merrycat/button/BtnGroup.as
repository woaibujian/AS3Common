package com.merrycat.button
{
	/**
	 * @author merrycat
	 * 
	 * 按钮组，适用于导航类按钮集合，设置当前按钮选中，可以自动恢复之前被选按钮普通状态
	 */
	public class BtnGroup
	{
		private var _selectedIdx : int = -1;
		
		public static const SELECT_NONE:int = -1;
		
		//IBtn
        private var _btns:Array;
        
        /**
		 * 初始化
		 * 
		 * @param	btns			设置按钮租源数据数组
		 * @param	selectedIdx		设置默认选中索引值， -1为当前未选中任何按钮
		 */
		public function BtnGroup( btns : Array, selectedIdx : int = 0 )
		{
			_btns = btns;
			
			this.selectedIdx = selectedIdx;
		}
		
		private function updateEnable( lastIdx : int , currIdx : int ):void
        {
        	( lastIdx != -1 ) && ( ( _btns[ lastIdx ] as IBtn ).selected = false );
        	
			var currBtn : IBtn = ( _btns[ currIdx ] as IBtn );
        	if(currBtn)
        	{
        		currBtn.selected = true;
        	}
        }
		
		/**
		 * 设置当前按钮组被选择的索引值
		 */	
		public function set selectedIdx( idx : int ):void
		{
			if( idx != _selectedIdx )
			{
				updateEnable( _selectedIdx , idx );
				_selectedIdx = idx;
			}
		}
		
		/**
		 * 获得当前按钮组被选择的索引值
		 */	
		public function get selectedIdx():int
		{
			return _selectedIdx;
		}
		
		/**
		 * 不选择任何导航
		 */	
		public function selectNone() : void
		{
			selectedIdx = SELECT_NONE;
		}
	}
}