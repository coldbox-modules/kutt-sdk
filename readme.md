# Coldbox Kutt SDK module

This module provides a simple SDK for creating and managing Tiny URLs using the open-source [Kutt](https://kutt.it/) application.

## Module Configuration:

### Environment variables

* `TINYURL_ENABLED` - can be used to disable the module
* `KUTT_ENDPOINT` - This is full URL to your Kutt server
* `KUTT_AUTHTOKEN` - This is the API token used to access the Kutt server API
* `KUTT_THROWONERROR` - When set to true, errors will be thrown on link creation if there is a failure from the Kutt API server

In your `config/modules/kutt-sdk.cfc` file you use some or all of the following settings. The defaults are provided below:

```javascript
function configure(){
	return {
		// When not enabled, the original URL will be returned
		"enabled" : getSystemSetting( "TINYURL_ENABLED", true ),
		// This is full URL to your Kutt server
		"endpoint" : getSystemSetting( "KUTT_ENDPOINT", "" ),
		// This is the API token used to access the Kutt server API
		"authToken" : getSystemSetting( "KUTT_AUTHTOKEN", "" ),
		// The default URL expiration.  Must be a number followed by the plural time interval ( e.g. 1 days, 24 hours, 3 minutes, 1 months, etc )
		"defaultExipration" : "30 days",
		// Whether to throw on error when communication with the Kutt API fails
		"throwOnError" : getSystemSetting( "KUTT_THROWONERROR", false )
	};
}
```

## Methods

### Create a Tiny URL

#### Method signature
```javascript
create(
	  required string target, // the URL to shorten
	  string description, // an optional description for the link
	  string expires, // an optional number and interval for the URL to expire ( e.g. 30 days, 10 minutes, 2 hours, etc )
	  boolean reuse = true, // whether or not to reuse the same short URL for the same target.  If passed as false a new short URL will be created for each request.
	  string password, // an optional password to protect the short URL
	  string domain // an optional domain to use for the short URL
)
```

#### Example

```java
var urlService = getInstance( "URLService@kutt" );
// create a basic link
var tiny1 = urlService.create( "https://www.ortussolutions.com" );
// When reuse is set to false it will always create a new tinyURL
var tiny1 = urlService.create( target="https://www.ortussolutions.com", reuse=false );
```



----
## Ortus Sponsors

ColdBox is a professional open-source project and it is completely funded by the [community](https://patreon.com/ortussolutions) and [Ortus Solutions, Corp](https://www.ortussolutions.com).  Ortus Patreons get many benefits like a cfcasts account, a FORGEBOX Pro account and so much more.  If you are interested in becoming a sponsor, please visit our patronage page: [https://patreon.com/ortussolutions](https://patreon.com/ortussolutions)

### THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
