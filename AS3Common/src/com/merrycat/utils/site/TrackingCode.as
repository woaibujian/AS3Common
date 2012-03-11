package com.merrycat.utils.site
{
	import org.casalib.util.ArrayUtil;
//	import nl.demonsters.debugger.MonsterDebugger;

//	import com.asual.swfaddress.SWFAddress;
	
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	import org.casalib.events.LoadEvent;
	import org.casalib.load.DataLoad;
	import org.casalib.time.Interval;
	import org.casalib.util.LocationUtil;
	
	public class TrackingCode
	{
		private static var instance : TrackingCode;

		public static const TXT : int = 0;
		public static const SWF_ADDRESS : int = 1;
		public static const JS_CALL : int = 2;
		public static const SPOT_LIGHTS : int = 3;
		
		//txt基础目录
		public var basePathTxt : String;
		//聚光灯基础目录
		public var baseUrlSpotLisghts:String;
		
		//已经发送过的txt地址，注：短地址，不含http和基础目录
		private var _txtsHasSent : Array = [];
		
		private var _dictID : int = 0;
		
		//Interval
		private var _sendIntervalDict: Dictionary;
		
		public var dubugMode : Boolean = false;
		
		public var waitTime : Number = 1;

		public function TrackingCode( pw : PrivateClass ) : void
		{
			_sendIntervalDict = new Dictionary( true );
		}

		public static function getInstance() : TrackingCode
		{
			if ( instance == null )
				instance = new TrackingCode( new PrivateClass());
				
			return instance;
		}
		
		public function send( url : String , type : int = TXT, time : Number = -1 ) : void
		{
			var sendInterval : Interval;
			
			if( time == -1 ) time = waitTime;
			
			switch( type )
			{
				case TXT:
					
					var realUrl : String;
					
					if( url.slice( 0, 4 ) == "http" )
						realUrl = url;
					else
						realUrl = basePathTxt + url;
					
					if( time != 0 ) 
						sendInterval = Interval.setInterval( doSend, time * 1000, realUrl, _dictID );
					else
						doSend( realUrl, -1 );
						
					_txtsHasSent.push(url);
					_txtsHasSent = ArrayUtil.removeDuplicates(_txtsHasSent);
					
					break;
					
				case SWF_ADDRESS:
					
					if( !( LocationUtil.isIde() || LocationUtil.isStandAlone() ) )
					{ 
//						SWFAddress.setValue( "?page=" + url );
//						
//						SWFAddress.href("javascript:__ozflash('" + url + "');" , "_self" );
						
						sendInterval = Interval.setInterval( doJsSend, 50, _dictID );
					}
					
					dubugMode && debug( "TrackingCode: js " + url + " send complete" );
					
					break;
					
				case JS_CALL:
				
					if( ( !( LocationUtil.isIde() || LocationUtil.isStandAlone() ) ) && ExternalInterface.available )
					{
						sendInterval = Interval.setInterval( doCallJsSend, 200, _dictID, url );
					}
					
					dubugMode && debug( "TrackingCode: js " + url + " send complete" );
				
					break;
				
				case SPOT_LIGHTS:
					
					sendInterval = Interval.setInterval( doSpotLightsSend, time * 1000, _dictID, url );
					
					break;
			}
			
			if( sendInterval )
			{
				_sendIntervalDict[ _dictID ] = sendInterval;
				
				_dictID++;
					
				sendInterval.start();
			}
		}
		
		private function doSend( realUrl : String, dictID : int ):void
		{
			if( dictID != -1 )
			{
				var sendInterval : Interval = _sendIntervalDict[ dictID ] as Interval;
				sendInterval.destroy();
				
				_sendIntervalDict[ dictID ] = null;
			}
			
			var dataLoad : DataLoad = new DataLoad( realUrl );
			dataLoad.preventCache = true;
            dataLoad.addEventListener( LoadEvent.COMPLETE,  onComplete );
            dataLoad.addEventListener( IOErrorEvent.IO_ERROR, ioError );
            dataLoad.start();
		}
		
		private function doJsSend( dictID : int ):void
		{
			var sendInterval : Interval = _sendIntervalDict[ dictID ] as Interval;
			sendInterval.destroy();
			
			_sendIntervalDict[ dictID ] = null;
			
//			SWFAddress.href("javascript:__ozfac();","_self");
		}
		
		private function doCallJsSend( dictID : int, url:String ):void
		{
			var sendInterval : Interval = _sendIntervalDict[ dictID ] as Interval;
			sendInterval.destroy();
			
			_sendIntervalDict[ dictID ] = null;
			
			ExternalInterface.call( url );
			
//			MonsterDebugger.trace(this, url)
		}
		
		private function doSpotLightsSend( dictID : int, url:String ):void
		{
			if( dictID != -1 )
			{
				var sendInterval : Interval = _sendIntervalDict[ dictID ] as Interval;
				sendInterval.destroy();
				
				_sendIntervalDict[ dictID ] = null;
			}
			
			var rand:Number = Math.random() * 10000000000000;
			
			var results:Array = url.split( "|" ); 
			
			var tag_url: String = baseUrlSpotLisghts + results[ 0 ] + ";ord=" + rand + "?";
			var pvDataLoad : DataLoad = new DataLoad( tag_url );
			pvDataLoad.addEventListener( LoadEvent.COMPLETE,  onComplete );
			pvDataLoad.addEventListener( IOErrorEvent.IO_ERROR, ioError );
			pvDataLoad.start();
			
			tag_url = baseUrlSpotLisghts + results[ 1 ] + ";ord=1;num=" + rand + "?";
			
			var uvDataLoad : DataLoad = new DataLoad( tag_url );
			uvDataLoad.addEventListener( LoadEvent.COMPLETE,  onComplete );
			uvDataLoad.addEventListener( IOErrorEvent.IO_ERROR, ioError );
			uvDataLoad.start();
		}
		
		private function onComplete( e : LoadEvent ):void
		{
			dubugMode && debug( "TrackingCode: " + ( e.target as DataLoad ).url + " load complete" );
		}
		
		private function debug( info : String ):void
		{
			trace( info );
//			MonsterDebugger.trace( this, info );
		}
		
		/**
		 * 判断txt是否已被发送过一次
		 * @param url 		短地址
		 * 
		 * @example 
		 * 
		 * if(TrackingCode.getInstance().isTxtHasSent("Nav1/Camp.txt"))
				TrackingCode.getInstance().send("Nav2/Camp.txt");
			else
				TrackingCode.getInstance().send("Nav1/Camp.txt");
		 */
		public function isTxtHasSent(url:String) : Boolean
		{
			if (ArrayUtil.contains(_txtsHasSent, url))
				return true;
			else
				return false;	
		}
		
		/**
		 * 对第一次发送和第一次之后发送进行判断，发送到不同的地址
		 * @param firstTxt 		第一次的短地址
		 * @param secondTxt 	第一次之后的短地址
		 * 
		 * @example 
		 * 
		 * TrackingCode.getInstance().sendDiffTxt("Nav1/School-below.txt", "Nav2/School-below.txt");
		 */
		public function sendDiffTxt(firstTxt:String, secondTxt:String) : void
		{
			if(isTxtHasSent(firstTxt))
				send(secondTxt);
			else
				send(firstTxt);
		}
		
		/**
		 * 只发送一次的地址
		 * @param url 			短地址
		 * 
		 * @example 
		 * 
		 * TrackingCode.getInstance().sendOnce("Nav1/School-below.txt");
		 */
		public function sendOnce(url:String) : void
		{
			if(!isTxtHasSent(url))
				send(url);
		}
		
		private function ioError( e : IOErrorEvent ):void
		{
			dubugMode && debug( e.toString() );
		}
	}
}

class PrivateClass{}