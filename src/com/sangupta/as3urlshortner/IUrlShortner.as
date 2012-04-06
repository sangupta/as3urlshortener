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

package com.sangupta.as3urlshortner {
	
	
	/**
	 * Contract for all implementations that provide URL shortening service.
	 * 
	 * @author Sandeep Gupta
	 * @since 1.0
	 */
	public interface IUrlShortner {

		/**
		 * Provide authentication parameters in case either the API does not support anonymous shortening,
		 * or one wishes to use their registered account.
		 */
		function authenticate(username:String, password:String):void;
		
		/**
		 * Given a long URL, return the short URL.
		 */
		function shortenUrl(url:String, onComplete:Function = null, onError:Function = null):void;
		
		/**
		 * Given a short URL, return the actual long URL.
		 */
		function expandUrl(shortUrl:String, onComplete:Function = null, onError:Function = null):void;
		
		/**
		 * Indicates whether the implementing class/service supports shortening of URLs.
		 */
		function get supportsShortening():Boolean;
		
		/**
		 * Indicates whether the implementing class/service supports expansion of short URLs.
		 */
		function get supportsExpansion():Boolean;
		
		/**
		 * Returns the version of the API that the implementation supports.
		 */
		function get version():String;
		
		/**
		 * Returns whether the implementation supports anonymous shortening of a URL or not.
		 */
		function get supportsAnonymousShortening():Boolean;

	}
}
