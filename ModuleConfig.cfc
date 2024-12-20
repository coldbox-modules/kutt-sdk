/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 */
component {

	// Module Properties
	this.title 				= "Kutt SDK";
	this.author 			= "Ortus Solutions";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "Tiny URL SDK for kutt.it";
	this.version 			= "@build.version@+@build.number@";

	// Model Namespace
	this.modelNamespace		= "Kutt";

	// CF Mapping
	this.cfmapping			= "Kutt";

	// Dependencies
	this.dependencies 		= [];

	/**
	 * Configure Module
	 */
	function configure(){
		// module settings - stored in modules.name.settings
		settings = {
			"enabled" : getSystemSetting( "TINYURL_ENABLED", true ),
			"endpoint" : getSystemSetting( "KUTT_ENDPOINT", "" ),
			"authToken" : getSystemSetting( "KUTT_AUTHTOKEN", "" ),
			"defaultExipration" : "30 days",
			"throwOnError" : getSystemSetting( "KUTT_THROWONERROR", false )
		};

		if( !len( settings.endpoint ) ){
			log.error( "The tiny-url module requires an endpoint to be set in the configuration.  Module functionality has been deactivated" );
			settings.enabled = false;
		}
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){

	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){

	}

}
