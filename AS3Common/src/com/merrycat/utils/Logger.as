package com.merrycat.utils
{
	import flash.utils.Dictionary;
	import flash.events.EventDispatcher;

	/**
	 * @author RobbyTheRobot
	 */
	public class Logger extends EventDispatcher 
	{
		
		
		public var logs    :Dictionary = null;
		public var enabled :Boolean    = true;
		private var dummyID:int        = 0;
		
		//-----------------------------------------
		// CONSTRUCTOR (SINGLETON)
		//----------------------------------------
		private static var _instance:Logger;
		public function Logger( $enforcer:Enforcer ){
			logs = new Dictionary();
		}
		public static function getInstance():Logger {
			if(!_instance) _instance = new Logger( new Enforcer );
			return _instance;
		}
		
		
		
		
		
		//-----------------------------------------
		// PUBLICS
		//----------------------------------------
		public function store( $log:String, $target:*, $id:String =""):void {
			if(!$target) $target = "";
			if($id.length < 1 ) $id = int(dummyID++).toString();
			logs[$id] = $target + " : "  + $log;
		}
		public function log( $log:String, $target:*, $id:String = "" ):void {
			if(!$target) $target = "";
			if($id.length < 1 ) $id = int(dummyID++).toString();
			store( $log, $target, $id );
			
			if(enabled)
				trace("[ LOGGER ] :log: --> " + $target + " : "  + $log );
		}
		public function readLogs():void {
			if(!enabled) 
				throw Error("[ LOGGER ] :readLogs: --> Logger is nog enabled to trace. Use Logger.getInstance().enabled = true")
			
			trace("\n[ LOGGER ] :START LOGS: ----------->");
			var i:String;
			for( i in logs){
				trace("[ LOGGER ] :read: --> |" + i +"| "+ logs[i]);
			}
			trace("[ LOGGER ] :END LOGS: ----------->\n");
		}
		public function readLogsFromID( $id:String ):void {
			if(!enabled) 
				throw Error("[ LOGGER ] :readLogsFromID: --> Logger is nog enabled to trace. Use Logger.getInstance().enabled = true")
			
			
			if($id=="") 
				throw Error("[ LOGGER ] :readLogsFromID: --> Plz specify an ID!");
				
				
			trace("\n[ LOGGER ] :START LOGS: ----------->");
			var i:String;
			for( i in logs){
				if(checkIDExcistence($id)){
					if( i == $id ) {
						trace("[ LOGGER ] :read: --> |" + i +"| "+ logs[i]);
					}
				}else{
					trace("[ LOGGER ] :readFromID: --> NO ENTRY FOUND UNDER ID");
				}
			}
			trace("[ LOGGER ] :END LOGS: ----------->\n");
		}
		public function readLogsFromObject( $obj:* = null):void {
			if(!enabled) 
				throw Error("[ LOGGER ] :readLogsFromObject: --> Logger is nog enabled to trace. Use Logger.getInstance().enabled = true")
			
			if(!$obj) 
				throw Error("[ LOGGER ] :readLogsFromObject: --> Plz specify an Object!");
			
			
			trace("\n[ LOGGER ] :START LOGS: ----------->");
			var objString:String = $obj.toString();
			objString = objString.substr(objString.indexOf(" ")+1, objString.length);
			objString = objString.substr(0, objString.indexOf("]"));
			var i:String;
			for( i in logs){
				var objID:String = String( logs[i] ).substr(8, String( logs[i] ).length);
				objID = objID.substr(0, objID.indexOf("]")-1);
				if( objString.indexOf( objID) > -1 )
					trace("[ LOGGER ] :readObj: --> |" + i +"| "+ logs[i]);
				
			}
			trace("[ LOGGER ] :END LOGS: ----------->\n");
		}
		public function checkIDExcistence($id:String):Boolean {
			for( var i:String in logs){
				if( i == $id ) 
					return true;
			}
			return false;
		}
		public function clean():void {
			logs    = null;
			logs    = new Dictionary();
			dummyID = 0;
		}
		
	}
}
internal class Enforcer{}
