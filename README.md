as3urlshortener
---------------

URL Shortening library for ActionScript. Provides convenience classes to shorten URLs via the implemented services, or to expand a given shortened URL.

Currently implementations are available for the following services:

* http://bit.ly
* http://cli.gs
* http://goo.gl
* http://is.gd
* http://shortr.net
* http://tinyurl.com
* http://t.co

Typical Usage
-------------

```actionscript
IUrlShortner shortener = new BitLyShortner(); // can be replaced with any shortening provider available
  
public function shortenUrl(url:String):void {
  // trace the version
  trace('Shortener API version: ' + shortener.version);

  if(!shortener.supportsAnonymousShortening) {
    shortener.authenticate(myUserName, myPasswordOrApiKey);
  }
  
  if(shortener.supportsShortening) {
    shortener.shortenUrl(url, successHandler, errorHandler);
  }
}

public function successHandler(response:UrlShortenerResponse):void {
  trace('Short url is: ' + response.shortUrl);
  
  // let's expand this to the full URL via the API
  if(shortener.supportsExpansion) {
    shortener.expandUrl(response.shortUrl, successHandler2, errorHandler);
  }
}

public function successHandler2(response:UrlShortenerResponse):void {
  trace('Original expanded url is: ' + response.longUrl);
}

public function errorHandler(event:Event):void {
  trace('error occured during url shortening/expansion.');
}
```

Versioning
----------

For transparency and insight into our release cycle, and for striving to maintain backward compatibility, **as3urlshortener** will be maintained under the Semantic Versioning guidelines as much as possible.

Releases will be numbered with the follow format:

`<major>.<minor>.<patch>`

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major
* New additions without breaking backward compatibility bumps the minor
* Bug fixes and misc changes bump the patch

For more information on SemVer, please visit http://semver.org/.

License
-------

Copyright 2011-2012, Sandeep Gupta

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
