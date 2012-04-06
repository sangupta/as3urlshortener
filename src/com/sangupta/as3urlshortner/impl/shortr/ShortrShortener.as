/**
 *
 * as3urlshortner - URL shortening library for ActionScript
 * Copyright (C) 2011-2012, Sandeep Gupta
 * http://www.sangupta.com/projects/as3urlshortener
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

package com.sangupta.as3urlshortner.impl.shortr {
	
	import com.sangupta.as3extensions.web.URLService;
	import com.sangupta.as3urlshortner.IUrlShortner;
	import com.sangupta.as3urlshortner.UrlShortenerResponse;
	import com.sangupta.as3utils.AssertUtils;
	import com.sangupta.as3utils.WebUtils;
	
	import flash.errors.IllegalOperationError;
	
	/**
	 * Implementation of <code>IUrlShortner</code> that uses <code>http://shortr.info</code> service
	 * for url shortening. 
	 * 
	 * More information on the API homepage at http://shortr.info/api.php
	 * 
	 * @author Sandeep Gupta
	 * @since 1.0
	 */
	public class ShortrShortener implements IUrlShortner {
		
		private static const VERSION:String = "v1";
		
		private static const API_END_POINT:String = 'http://shortr.info/make-shortr.php?url=';
		
		public function ShortrShortener() {
			super();
		}
		
		/**
		 * The API does not require authentication and hence, is not supported.
		 * 
		 * @param username <i>not used</i>
		 * @param password <i>not used</i>
		 * @throw IllegalOperationError for authentication is not supported.
		 */
		public function authenticate(username:String, password:String):void {
			throw new IllegalOperationError('is.gd shortner not yet supports shortening.');
		}
		
		public function shortenUrl(url:String, onComplete:Function=null, onError:Function=null):void {
			if(AssertUtils.isEmptyString(url)) {
				throw new ArgumentError('Url to be shortened cannot be empty/null.');
			}
			
			var url:String = API_END_POINT + encodeURIComponent(url);
			new URLService(url, handleShorteningResponse).executeGET( { longUrl: url, onComplete : onComplete, onError : onError } );
		}
		
		/**
		 * Handle webservice response for shortening.
		 */
		private function handleShorteningResponse(data:String, callbackData:Object):void {
			var shortUrl:String = data.substr('SUCCESS::'.length);
			var response:UrlShortenerResponse = new UrlShortenerResponse(shortUrl, callbackData.longUrl as String);
			var onComplete:Function = callbackData.onComplete as Function;
			if(onComplete != null) {
				onComplete(response);
			}
		}
		
		public function expandUrl(shortUrl:String, onComplete:Function=null, onError:Function=null):void {
			if(AssertUtils.isEmptyString(shortUrl)) {
				throw new ArgumentError('Url to be shortened cannot be empty/null.');
			}
			
			new URLService(shortUrl, handleResponse).executeHEAD( { shortUrl: shortUrl, onComplete: onComplete, onError: onError }, false);
		}
		
		private function handleResponse(statusCode:int, headers:Array, callbackData:Object):void {
			if(statusCode == 301 || statusCode == 302) {
				var location:String = WebUtils.getHeader(headers, 'location');
				
				callbackData.onComplete(new UrlShortenerResponse(callbackData.shortUrl as String, location));
				return;
			}
			
			callbackData.onError();
		}
		
		public function get supportsShortening():Boolean {
			return true;
		}
		
		public function get supportsExpansion():Boolean {
			return true;
		}
		
		public function get version():String {
			return 'default';
		}
		
		public function get supportsAnonymousShortening():Boolean {
			return true;
		}
	}
}
