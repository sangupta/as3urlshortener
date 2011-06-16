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

package org.myjerry.as3urlshortner.impl.bitly {
	
	import flash.errors.IllegalOperationError;
	
	import org.myjerry.as3extensions.web.XMLService;
	import org.myjerry.as3urlshortner.UrlShortenerResponse;
	import org.myjerry.as3urlshortner.IUrlShortner;
	import org.myjerry.as3utils.AssertUtils;
	import org.myjerry.as3utils.StringUtils;
	
	/**
	 * Implementation of <code>IUrlShortner</code> that uses <code>http://bit.ly</code> service
	 * for url shortening. Currently, OAuth support is not available.
	 * 
	 * @author Sandeep Gupta
	 * @since 1.0
	 */
	public class BitLyShortner implements IUrlShortner {
		
		private static const VERSION:String = "v3";
		
		private static const API_END_POINT:String = 'http://api.bit.ly/';
		
		private var _loginName:String = null;
		
		private var _apiKey:String = null;
		
		private var _onComplete:Function = null;
		
		private var _onError:Function = null;
		
		public function BitLyShortner() {
			super();
		}
		
		/**
		 * Authenticate using the supplied parameters against the service when invoking various webservices.
		 * 
		 * @param username the login name for the http://bit.ly service
		 * @param password the API key for password service
		 */
		public function authenticate(username:String, password:String):void {
			this._loginName = username;
			this._apiKey = password;
		}
		
		/**
		 * Given a long URL, return the shortened URL.
		 * 
		 * @param url the URL to be shortened. Throws <code>ArgumentError</code> in case the value is <code>empty/null</code>.
		 * @param onComplete callback function when URL has been shortened. The callback function must take a single argument of type <code>UrlShortenerResponse<code>.
		 * @param onError callback function in case of failure
		 */
		public function shortenUrl(url:String, onComplete:Function = null, onError:Function = null):void {
			if(AssertUtils.isEmptyString(url)) {
				throw new ArgumentError('Url to be shortened cannot be empty/null.');
			}
			
			var url:String =  buildUrl('shorten', 'longUrl=' + encodeURIComponent(url));
			new XMLService(url, handleShorteningResponse).execute( { onComplete : onComplete, onError : onError } );
		}
		
		/**
		 * Given a short URL, return the expanded URL
		 * 
		 * @param shortUrl URL to be expanded.  Throws <code>ArgumentError</code> in case the value is <code>empty/null</code>.
		 * @param onComplete callback function when URL has been expanded. The callback function must take a single argument of type <code>UrlShortenerResponse<code>.
		 * @param onError callback function in case of failure
		 */
		public function expandUrl(shortUrl:String, onComplete:Function = null, onError:Function = null):void {
			if(AssertUtils.isEmptyString(shortUrl)) {
				throw new ArgumentError('Url to be shortened cannot be empty/null.');
			}
			
			var url:String =  buildUrl('expand', 'shortUrl=' + encodeURIComponent(shortUrl));
			new XMLService(url, handleExpansionResponse).execute( { onComplete : onComplete, onError : onError } );
		}
		
		/**
		 * Return the version of the API that this implementation supports.
		 */
		public final function get version():String {
			return VERSION;
		}
		
		public final function get supportsShortening():Boolean {
			return true;
		}
		
		public final function get supportsExpansion():Boolean {
			return true;
		}
		
		/**
		 * Returns if the implementation supports anonymous shortening of URLs.
		 */
		public function get supportsAnonymousShortening():Boolean {
			return false;
		}
		
		/**
		 * Handle webservice response for shortening.
		 */
		private function handleShorteningResponse(xml:XML, callbackData:Object):void {
			var response:UrlShortenerResponse = BitLyResponse.parseShorteningResponse(xml);
			var onComplete:Function = callbackData.onComplete as Function;
			if(onComplete != null) {
				onComplete(response);
			}
		}
		
		/**
		 * Handle webservice response for expansion.
		 */
		private function handleExpansionResponse(xml:XML, callbackData:Object):void {
			var response:UrlShortenerResponse = BitLyResponse.parseExpansionResponse(xml);
			var onComplete:Function = callbackData.onComplete as Function;
			if(onComplete != null) {
				onComplete(response);
			}
		}

		/**
		 * Utility method to build the API URL from given parameters.
		 */
		protected function buildUrl(method:String, paramString:String):String {
			if(this._loginName == null || this._apiKey == null) {
				throw new IllegalOperationError('Anonymous support is not available.');
			}
			
			return API_END_POINT + VERSION + '/' + method + '?format=xml&login=' + this._loginName + '&apiKey=' + this._apiKey + '&' + paramString;
		}
	}
}
