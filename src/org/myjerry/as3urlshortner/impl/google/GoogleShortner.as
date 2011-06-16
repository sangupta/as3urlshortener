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

package org.myjerry.as3urlshortner.impl.google {
	
	import org.myjerry.as3extensions.web.URLService;
	import org.myjerry.as3urlshortner.IUrlShortner;
	import org.myjerry.as3urlshortner.UrlShortenerResponse;
	import org.myjerry.as3utils.AssertUtils;
	
	/**
	 * Implementation of <code>IUrlShortner</code> that uses Google's <code>http://goo.gl</code> service
	 * for url shortening. API key authentication is recommended. OAuth authentication is currently not
	 * supported. 
	 * 
	 * @author Sandeep Gupta
	 * @since 1.0
	 */
	public class GoogleShortner implements IUrlShortner {
		
		private static const VERSION:String = "v1";
		
		private static const API_END_POINT:String = 'https://www.googleapis.com/urlshortener/';
		
		private var _apiKey:String = null;
		
		public function GoogleShortner() {
			super();
		}
		
		/**
		 * Authenticate using the supplied parameters against the service when invoking various webservices.
		 * 
		 * @param username the API key to be used when hitting the service. The value is optional.
		 * @param password <i>not used</i>
		 */
		public function authenticate(username:String, password:String):void {
			this._apiKey = username;
		}
		
		public function shortenUrl(url:String, onComplete:Function = null, onError:Function = null):void {
			if(AssertUtils.isEmptyString(url)) {
				throw new ArgumentError('Url to be shortened cannot be empty/null.');
			}
			
			var apiUrl:String = API_END_POINT + VERSION + '/url';
			if(this._apiKey != null) {
				apiUrl += '?key=' + this._apiKey;
			}
			
			var data:String = '{"longUrl": "' + url + '"}';
			new URLService(apiUrl, handleShorteningResponse).executePOST( data, 'application/json', { onComplete : onComplete, onError : onError } );
		}
		
		/**
		 * Handle webservice response for shortening.
		 */
		private function handleShorteningResponse(json:String, callbackData:Object):void {
			var shortUrl:String = getAttributeFromJSON(json, 'id');
			var longUrl:String = getAttributeFromJSON(json, 'longUrl');
			var response:UrlShortenerResponse = new UrlShortenerResponse(shortUrl, longUrl);
			var onComplete:Function = callbackData.onComplete as Function;
			if(onComplete != null) {
				onComplete(response);
			}
		}
		
		public function expandUrl(shortUrl:String, onComplete:Function = null, onError:Function = null):void {
			if(AssertUtils.isEmptyString(shortUrl)) {
				throw new ArgumentError('Url to be shortened cannot be empty/null.');
			}
			
			var apiUrl:String = API_END_POINT + VERSION + '/url';
			apiUrl += '?shortUrl=' + encodeURIComponent(shortUrl);
			if(this._apiKey != null) {
				apiUrl += '&key=' + this._apiKey;
			}
			
			
			new URLService(apiUrl, handleExpansionResponse).executeGET( { onComplete : onComplete, onError : onError } );
		}
		
		/**
		 * Handle webservice response for expansion.
		 */
		private function handleExpansionResponse(json:String, callbackData:Object):void {
			var shortUrl:String = getAttributeFromJSON(json, 'id');
			var longUrl:String = getAttributeFromJSON(json, 'longUrl');
			var response:UrlShortenerResponse = new UrlShortenerResponse(shortUrl, longUrl);
			var onComplete:Function = callbackData.onComplete as Function;
			if(onComplete != null) {
				onComplete(response);
			}
		}
		
		public final function get version():String {
			return VERSION;
		}
		
		public final function get supportsShortening():Boolean {
			return true;
		}
		
		public final function get supportsExpansion():Boolean {
			return true;
		}
		
		public function get supportsAnonymousShortening():Boolean {
			return true;
		}

		/**
		 * Fetch the given parent-level attribute from the JSON string representation.
		 */
		private function getAttributeFromJSON(json:String, attribute:String):String {
			var id:String = '"' + attribute + '": "';
			var index:int = json.indexOf(id);
			return json.substring(index + id.length, json.indexOf('"', index + id.length + 1));
		}
		
	}
}
