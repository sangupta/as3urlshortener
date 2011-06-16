/**
 *
 * as3urlshortner - URL shortening library for ActionScript
 * Copyright (C) 2011, myJerry Developers
 * http://www.myjerry.org/as3urlshortner
 *
 * The file is licensed under the the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package org.myjerry.as3urlshortner.impl.cligs {
	
	import org.myjerry.as3extensions.web.URLService;
	import org.myjerry.as3extensions.web.XMLService;
	import org.myjerry.as3urlshortner.IUrlShortner;
	import org.myjerry.as3urlshortner.UrlShortenerResponse;
	import org.myjerry.as3utils.AssertUtils;
	
	/**
	 * Implementation of <code>IUrlShortner</code> that uses <code>http://cli.gs/</code> service
	 * for url expansion. URL shortening is not supported by this implementation. More information
	 * on the API is available at http://blog.cli.gs/api
	 *   
	 * @author Sandeep Gupta
	 * @since 1.0
	 */
	public class CligsShortener implements IUrlShortner {
		
		private static const VERSION:String = "v1";
		
		private static const API_END_POINT:String = 'http://cli.gs/api/';
		
		private var _apiKey:String = null;
		
		private var _appID:String = null;

		public function CligsShortener() {
			super();
		}
		
		public function authenticate(username:String, password:String):void {
			this._appID = encodeURIComponent(username);
			this._apiKey = password;
		}
		
		public function shortenUrl(url:String, onComplete:Function=null, onError:Function=null):void {
			if(AssertUtils.isEmptyString(url)) {
				throw new ArgumentError('Url to be shortened cannot be empty/null.');
			}
			
			var url:String = API_END_POINT + VERSION + '/cligs/create?appid=' + this._appID + '&key=' + this._apiKey + '&url=' + encodeURIComponent(url);
			new URLService(url, handleShorteningResponse).executeGET( { longUrl: url, onComplete : onComplete, onError : onError } );
		}
		
		public function expandUrl(shortUrl:String, onComplete:Function=null, onError:Function=null):void {
			if(AssertUtils.isEmptyString(shortUrl)) {
				throw new ArgumentError('Url to be shortened cannot be empty/null.');
			}
			
			var url:String = API_END_POINT + VERSION + '/cligs/expand?clig=' + encodeURIComponent(shortUrl);
			new URLService(url, handleExpansionResponse).executeGET( { shortUrl: shortUrl, onComplete : onComplete, onError : onError } );
		}
		
		/**
		 * Handle webservice response for shortening.
		 */
		private function handleShorteningResponse(data:String, callbackData:Object):void {
			var response:UrlShortenerResponse = new UrlShortenerResponse(data, callbackData.longUrl as String);
			var onComplete:Function = callbackData.onComplete as Function;
			if(onComplete != null) {
				onComplete(response);
			}
		}
		
		/**
		 * Handle webservice response for expansion.
		 */
		private function handleExpansionResponse(data:String, callbackData:Object):void {
			var response:UrlShortenerResponse = new UrlShortenerResponse(callbackData.shortUrl as String, data);
			var onComplete:Function = callbackData.onComplete as Function;
			if(onComplete != null) {
				onComplete(response);
			}
		}
		
		public function get supportsShortening():Boolean {
			return true;
		}
		
		public function get supportsExpansion():Boolean {
			return true;
		}
		
		public function get version():String {
			return VERSION;
		}
		
		public function get supportsAnonymousShortening():Boolean {
			return false;
		}
	}
}
