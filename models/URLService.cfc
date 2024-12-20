component {

	property name="hyperBuilder"   inject="HyperBuilder@hyper";
	property name="moduleSettings" inject="coldbox:moduleSettings:kutt-sdk";
	property name="log"            inject="logbox:logger:{this}";


	function newHyperRequest(){
		return hyperBuilder
			.new()
			.setBodyFormat( "json" )
			.withHeaders( {
				"X-API-KEY" : variables.moduleSettings.authToken,
				"Accept"    : "text/json"
			} );
	}

	function list( numeric offset, numeric limit, boolean all ){
		return newHyperRequest()
			.setMethod( "GET" )
			.setURL( variables.moduleSettings.endpoint & "/api/v2/links" )
			.when( !isNull( arguments.offset ), ( req ) => {
				req.setQueryParam( "skip", offset );
			} )
			.when( !isNull( arguments.limit ), ( req ) => {
				req.setQueryParam( "limit", limit );
			} )
			.when( !isNull( arguments.all ), ( req ) => {
				req.setQueryParam( "all", true );
			} )
			.send()
			.json();
	}

	/**
	 * Create a short URL using the Kutt API.
	 *
	 * @target      the URL to shorten
	 * @description an optional description for the URL
	 * @expires     an optional number and interval for the URL to expire ( e.g. 30 days, 10 minutes, 2 hours, etc )
	 * @reuse       whether or not to reuse the same short URL for the same target.  If passed as false a new short URL will be created for each request.
	 * @password    an optional password to protect the short URL
	 * @domain      an optional domain to use for the short URL
	 */
	function create(
		required string target,
		string description,
		string expires,
		boolean reuse = true,
		string password,
		string domain
	){
		if ( !moduleSettings.enabled ) {
			return target;
		}

		var urlResponse = newHyperRequest()
			.setMethod( "POST" )
			.setURL( variables.moduleSettings.endpoint & "/api/v2/links" )
			.setBody( {
				"target"      : arguments.target,
				"description" : arguments.description ?: javacast( "null", 0 ),
				"expire_in"   : arguments.expires ?: variables.moduleSettings.defaultExipration,
				"reuse"       : arguments.reuse,
				"password"    : password ?: javacast( "null", 0 ),
				"domain"      : domain ?: javacast( "null", 0 )
			} )
			.send();

		if ( !urlResponse.isSuccess() ) {
			if ( moduleSettings.throwOnError ) {
				throw(
					message      = "An error occurred while attempting to create the short URL.",
					type         = "KuttSDK.URLCreationException",
					extendedInfo = serializeJSON( urlResponse.getMemento() )
				);
			} else {
				log.error(
					"An error occurred while attempting to create the short URL: #urlResponse.getStatus()# #urlResponse.getStatusText()#",
					urlResponse.getMemento()
				);
				return target;
			}
		} else {
			return urlResponse.json();
		}
	}

	/**
	 * Update a short URL using the Kutt API.
	 *
	 * @id          the id of the short URL to update
	 * @target      the URL to shorten
	 * @description an optional description for the URL
	 * @expires     an optional number and interval for the URL to expire ( e.g. 30 days, 10 minutes, 2 hours, etc )
	 * @reuse       whether or not to reuse the same short URL for the same target.  If passed as false a new short URL will be created for each request.
	 * @password    an optional password to protect the short URL
	 * @domain      an optional domain to use for the short URL
	 */
	function update(
		required string id,
		required string target,
		required string address,
		string description,
		string expires,
		boolean reuse = true,
		string password,
		string domain
	){
		return newHyperRequest()
			.setMethod( "PATCH" )
			.setURL( variables.moduleSettings.endpoint & "/api/v2/links/" & arguments.id )
			.setBody( {
				"target"      : arguments.target,
				"address"     : arguments.address,
				"description" : arguments.description ?: javacast( "null", 0 ),
				"expire_in"   : arguments.expires ?: variables.moduleSettings.defaultExipration,
				"reuse"       : arguments.reuse,
				"password"    : password ?: javacast( "null", 0 ),
				"domain"      : domain ?: javacast( "null", 0 )
			} )
			.send()
			.json();
	}

	/**
	 * Delete a short URL by its id.
	 *
	 * @id
	 */
	function delete( required string id ){
		return newHyperRequest()
			.setMethod( "DELETE" )
			.setURL( variables.moduleSettings.endpoint & "/api/v2/links/#arguments.id#" )
			.send()
			.json();
	}

	/**
	 * Retrieves the statistics for a short URL by its id.
	 *
	 * @id the id of the short URL
	 */
	function stats( required string id ){
		return newHyperRequest()
			.setMethod( "GET" )
			.setURL( variables.moduleSettings.endpoint & "/api/v2/links/#arguments.id#/stats" )
			.send()
			.json();
	}

}


