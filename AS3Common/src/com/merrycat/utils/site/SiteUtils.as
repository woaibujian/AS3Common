package com.merrycat.utils.site 
{

	import org.casalib.util.LocationUtil;
	import org.casalib.util.StageReference;

	import flash.external.ExternalInterface;
	/**
	 * @author Jan.Bu
	 */
	public class SiteUtils 
	{
		private static var instance : SiteUtils;
		
		//for debug
		public static var isRuningInShell:Boolean = false;
		
		public static var siteTitle:String = "";
		public static var bgmPath:String = "";
		
		private static var _siteURL : String = "";
		
		public function SiteUtils( pw : PrivateClass ) : void
		{
		}
		
		public static function getInstance() : SiteUtils
		{
			if ( instance == null )
				instance = new SiteUtils( new PrivateClass());
				
			return instance;
		}
		
		/**
		 * 是否在浏览器中运行
		 */
		public static function get isRunInBroswer() : Boolean
		{
			return !( LocationUtil.isIde() || LocationUtil.isStandAlone() );
		}
		
		/**
		 * 返回完整URL地址，包括锚点
		 * @example http://localhost/#/Works/AL-1
		 */
		public static function getFullURL() : String
		{
			if(isRunInBroswer)
				return ExternalInterface.call("function getURL(){return window.location.href;}");
				
			return "";
		}
		
		/**
		 * 获得网站根目录(index.swf)的实际URL地址。
		 * 注意，自动获取的地址最后没有"/"
		 */
		public function get siteURL() : String
		{
			if(_siteURL == "")
			{
				setURL();
			}
			return _siteURL;
		}
		
		/**
		 * 设置网站根目录(index.swf)的实际URL地址，如不传入参数则直接使用默认方法自动获取地址
		 * 注意，自动获取的地址最后没有"/"
		 * @example
		 * SiteUtils.getInstance().setURL(); //  http://www.merrycat.com.cn
		 * SiteUtils.getInstance().setURL("http://www.merrycat.com.cn");
		 */
		public function setURL(url:String = "") : void
		{
			if(url == "")
			{
				var swfURL:String = StageReference.getStage().loaderInfo.url;
				_siteURL = swfURL.substr(0, swfURL.lastIndexOf("/"));
			}else
			{
				_siteURL = url;
			}
		}
	}
}
class PrivateClass{}