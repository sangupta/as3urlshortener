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

package org.myjerry.as3urlshortner.impl.twitter {
	
	import flash.errors.IllegalOperationError;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import org.myjerry.as3extensions.web.URLService;
	import org.myjerry.as3urlshortner.IUrlShortner;
	import org.myjerry.as3urlshortner.UrlShortenerResponse;
	import org.myjerry.as3utils.AssertUtils;
	import org.myjerry.as3utils.WebUtils;
	
	/**
	 * Implementation of <code>IUrlShortner</code> that uses Twitter's <code>http://t.co</code> service
	 * for url expansion. URL shortening is not supported by this implementation. 
	 * 
	 * @author Sandeep Gupta
	 * @since 1.0
	 */
	public class TwitterShortner implements IUrlShortner {
		
		public function TwitterShortner() {
			super();
		}
		
		/**
		 * As Twitter does not allow shortening of URLs, authentication is not needed.
		 * 
		 * @param username <i>not used</i>
		 * @param password <i>not used</i>
		 * @throw IllegalOperationError for authentication is not supported.
		 */
		public function authenticate(username:String, password:String):void {
			throw new IllegalOperationError('Twitter shortner not yet supports shortening.');
		}
		
		public function shortenUrl(url:String, onComplete:Function = null, onError:Function = null):void {
			throw new IllegalOperationError('Twitter shortner not yet supports shortening.');
		}
		
		public function expandUrl(shortUrl:String, onComplete:Function = null, onError:Function = null):void {
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
		
		public function get version():String {
			return 'all';
		}
		
		public final function get supportsShortening():Boolean {
			return false;
		}
		
		public final function get supportsExpansion():Boolean {
			return true;
		}
		
		public function get supportsAnonymousShortening():Boolean {
			return false;
		}
		
	}
}
