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

package com.sangupta.as3urlshortner.impl.tinyurl {
	
	import com.sangupta.as3extensions.web.URLService;
	import com.sangupta.as3urlshortner.IUrlShortner;
	import com.sangupta.as3urlshortner.UrlShortenerResponse;
	import com.sangupta.as3utils.AssertUtils;
	import com.sangupta.as3utils.WebUtils;
	
	import flash.errors.IllegalOperationError;
	
	/**
	 * Implementation of <code>IUrlShortner</code> that uses <code>http://tinyurl.com</code> service
	 * for url expansion. URL shortening is not supported by this implementation. 
	 * 
	 * @author Sandeep Gupta
	 * @since 1.0
	 */
	public class TinyUrlShortener implements IUrlShortner {
		
		public function TinyUrlShortener() {
			super();
		}
		
		/**
		 * As Twitter does not allow shortening of URLs, authentication is not needed.
		 * 
		 * @param username <i>not used</i>
		 * @param password <i>not used</i>
		 */
		public function authenticate(username:String, password:String):void {
			throw new IllegalOperationError('TinyURL shortner does not supports authentication.');
		}
		
		public function shortenUrl(url:String, onComplete:Function=null, onError:Function=null):void {
			throw new IllegalOperationError('TinyURL shortner not yet supports shortening.');
		}
		
		public function expandUrl(shortUrl:String, onComplete:Function=null, onError:Function=null):void {
			if(AssertUtils.isEmptyString(shortUrl)) {
				throw new ArgumentError('Url to be shortened cannot be empty/null.');
			}
			
			new URLService(shortUrl, handleResponse).executeHEAD( { shortUrl: shortUrl, onComplete: onComplete, onError: onError }, false);
		}
		
		private function handleResponse(statusCode:int, headers:Array, callbackData:Object):void {
			if(statusCode == 301) {
				var location:String = WebUtils.getHeader(headers, 'location');
				
				callbackData.onComplete(new UrlShortenerResponse(callbackData.shortUrl as String, location));
				return;
			}
			
			callbackData.onError();
		}
		
		public function get supportsShortening():Boolean {
			return false;
		}
		
		public function get supportsExpansion():Boolean {
			return true;
		}
		
		public function get version():String {
			return 'all';
		}
		
		public function get supportsAnonymousShortening():Boolean {
			return true;
		}
	}
}
