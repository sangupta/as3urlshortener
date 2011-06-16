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

package org.myjerry.as3urlshortner {
	
	
	public class UrlShortenerResponse {
		
		private var _shortUrl:String;
		
		private var _longUrl:String;
		
		public function UrlShortenerResponse(shortUrl:String, longUrl:String) {
			super();
			this._shortUrl = shortUrl;
			this._longUrl = longUrl;
		}
		
		public function get shortUrl():String {
			return this._shortUrl;
		}
		
		public function get longUrl():String {
			return this._longUrl;
		}
		
	}
}
