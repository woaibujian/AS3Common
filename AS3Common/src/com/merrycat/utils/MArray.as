package com.merrycat.utils 
{
	import flash.utils.ByteArray;
	/**
	 * @author jan.bu
	 */
	public class MArray 
	{
//			var unEquals : Array = ArrayUtil.removeDuplicates(dpArr);

		/**
		 * 将数组中相当的元素分组
		 * @example 
		 * @param dpArr 源数据
		 */
		public static function getEqualGroups(dpArr:Array):Array
		{
			var equalGroups:Array = [];
			

			var unEquals : Array = dpArr.filter(function (e:*, i:int, inArray:Array):Boolean
			{
				return (i == 0) ? true : inArray.lastIndexOf(e, i - 1) == -1;
			});
			
			var havEqualInGroup:Boolean = false;
			
			var equalVO:EqualVO;
			
			var idx:int;
			
			dpArr.forEach(function( a : *, idxa : int, ... param ) : void
			{
				unEquals.forEach(function( b : *, idxb : int, ... param ) : void
				{
					if(a == b)
					{
						havEqualInGroup = false;
						
						equalGroups.forEach(function( c : EqualVO, idxc : int, ... param ) : void
						{
							if(c.value == b)
							{
								havEqualInGroup = true;
								
								idx = idxc;
								
								return;
							}
						});
						
						if(!havEqualInGroup)
						{
							equalVO = new EqualVO();
							equalVO.value = b;
							equalVO.equals = [b];
							equalVO.orginIdx = [idxa];
							equalGroups.push(equalVO);
						}else
						{
							equalVO = equalGroups[idx];
							equalVO.equals.push(b);
							equalVO.orginIdx.push(idxa);
						}
						
						return;
					}
				});
			});
			
			return equalGroups;
		}

		public static function clone(srcArr:Array) : Array
		{
			var byteArr:ByteArray = new ByteArray();
			byteArr.writeObject(srcArr);
			byteArr.position = 0;
			
			return byteArr.readObject();
		}
	}
}
