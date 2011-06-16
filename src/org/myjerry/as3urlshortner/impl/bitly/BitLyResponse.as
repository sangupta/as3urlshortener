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
	
	import org.myjerry.as3urlshortner.UrlShortenerResponse;
	
	
	public class BitLyResponse extends UrlShortenerResponse {
		
		private var _hash:String = null;
		
		private var _globalHash:String = null;
		
		private var _newHash:Boolean = false;
		
		public function BitLyResponse(shortUrl:String, longUrl:String) {
			super(shortUrl, longUrl);
		}
		
		public function get hash():String {
			return this._hash;
		}
		
		public function get globalHash():String {
			return this._globalHash;
		}
		
		public function get newHash():Boolean {
			return this._newHash;
		}
		
		public static function parseShorteningResponse(xml:XML):BitLyResponse {
			if(xml == null) {
				return null;
			}
			
			var response:BitLyResponse = new BitLyResponse(xml.data.url, xml.data.long_url);
			response._hash = xml.data.hash;
			response._globalHash = xml.data.global_hash;
			response._newHash = (xml.data.new_hash == '1') ? true : false;

			return response;
		}

		public static function parseExpansionResponse(xml:XML):BitLyResponse {
			if(xml == null) {
				return null;
			}
			
			var response:BitLyResponse = new BitLyResponse(xml.data.entry.short_url, xml.data.entry.long_url);
			response._hash = xml.data.entry.user_hash;
			response._globalHash = xml.data.entry.global_hash;
			
			return response;
		}
	}
}
