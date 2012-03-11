package com.merrycat.utils {
	import flash.utils.Dictionary;
	/**
	 * @author buj
	 */
	public class ObjectPool {
		private static var _pool : Dictionary = new Dictionary(true);
		private var _template : Class;
		private var _list : Array;

		public function ObjectPool(value : Class) {
			_template = value;
			_list = new Array();
		}

		public function borrowObject() : Object {
			if (_list.length > 0) {
				return _list.shift();
			}
			return new _template();
		}

		public function returnObject(value : Object) : void {
			_list.push(value);
		}

		public static function getPool(value : Class) : ObjectPool {
			if (!_pool[value]) {
				_pool[value] = new ObjectPool(value);
			}
			return _pool[value];
		}
	}
}
