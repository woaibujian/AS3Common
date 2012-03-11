package com.merrycat
{
	import flash.utils.*;

	public class ValueObject
	{
		public static var DELIMITER:String = "\n";

		public function ValueObject()
		{
		}

		public function toString():String
		{
			var varList:XMLList = describeType( this )..variable;
			var vars:Array = [ DELIMITER ];

			for ( var i:int ; i < varList.length() ; i++ )
			{
				vars.push( varList[ i ].@name + ' : ' + this[ varList[ i ].@name ]);
			}

			return vars.join( DELIMITER );
		}
	}
}