package com.merrycat.cookie 
{ 
	import flash.net.SharedObject;  
	
	/**
	 * @author merrycat
	 * 
	 * Cookie类，用于读写持久变量
	 */
	public class Cookie 
	{ 
		/**
		 * 一年的秒数
		 */
		public static const YEAR_SEC:uint = 31536000;
		
		private var _time : uint;
		private var _name : String;
		private var _so : SharedObject;
		
		/**
		 * Cookie类构造函数
		 * 
		 * @param	flashcookie 			COOKIE设置的命名空间，默认为"flashcookie"
		 * @param	timeOut					COOKIE的过期时间，默认为3600秒，即1小时
		 */
		public function Cookie(name : String = "flashcookie", timeOut : uint = 3600) 
		{ 
			_name = name;
			_time = timeOut;
			_so = SharedObject.getLocal(name, "/");
		}

		/**
		 * 清除过期的COOKIE
		 */
		public function clearTimeOut() : void 
		{ 
			var obj : * = _so.data.cookie;
			if(obj == undefined)
			{ 
				return;
			} 
			for(var key:* in obj)
			{ 
				if(obj[key] == undefined || obj[key].time == undefined || isTimeOut(obj[key].time))
				{ 
					delete obj[key];
				} 
			} 
			_so.data.cookie = obj;
			_so.flush();
		} 

		/**
		 * 计算并返回COOKIE时间是否过期
		 * @param	time			过期时间
		 * @return 					COOKIE时间是否过期
		 */
		private function isTimeOut(time : uint) : Boolean 
		{ 
			var today : Date = new Date();        
			return time + _time * 1000 < today.getTime();
		} 

		/**
		 * 获得当前COOKIE的过期时间，单位秒
		 * @return				COOKIE的过期时间
		 */
		public function getTimeOut() : uint 
		{ 
			return _time;
		} 

		/**
		 * 获得当前COOKIE的命名空间
		 * @return				COOKIE的命名空间
		 */
		public function getName() : String 
		{ 
			return _name;
		} 

		/**
		 * 清楚所有COOKIE
		 */
		public function clear() : void 
		{ 
			_so.clear();
		} 

		/**
		 * 写入COOKIE变量
		 * @param	key			变量名
		 * @param	value		变量值
		 */
		public function put(key : String, value : *) : void 
		{ 
			var today : Date = new Date();
			key = "key_" + key;
			value.time = today.getTime();
			if(_so.data.cookie == undefined)
			{ 
				var obj : Object = {};
				obj[key] = value;
				_so.data.cookie = obj;
			}
			else
			{ 
				_so.data.cookie[key] = value;
			} 
			_so.flush();
		} 

		/**
		 * 根据变量名移除COOKIE变量
		 * @param	key			变量名
		 */
		public function remove(key : String) : void 
		{ 
			if (isExist(key)) 
			{ 
				delete _so.data.cookie["key_" + key];
				_so.flush();
			} 
		} 

		/**
		 * 根据变量名获取COOKIE变量值
		 * @param	key			变量名
		 * @return				COOKIE变量值
		 */
		public function get(key : String) : Object
		{     
			return isExist(key) ? _so.data.cookie["key_" + key] : null;
		} 

		/**
		 * 返回变量名是否存在
		 * @param	key			变量名
		 * @return 				变量名是否存在
		 */
		public function isExist(key : String) : Boolean
		{ 
			key = "key_" + key; 
			return _so.data.cookie != undefined && _so.data.cookie[key] != undefined;
		} 
	} 
}