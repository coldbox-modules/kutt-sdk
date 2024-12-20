component extends="coldbox.system.testing.BaseTestCase" {

	variables.envUtil = new coldbox.system.core.delegates.Env();

	function beforeAll(){
		super.beforeAll();
		var qUser = queryExecute( "SELECT * from users WHERE email = 'info@ortussolutions.com'" );
		if ( !qUser.recordCount ) {
			queryExecute(
				"
				INSERT INTO ""public"".""users"" (""id"", ""apikey"", ""banned"", ""banned_by_id"", ""cooldowns"", ""email"", ""password"", ""reset_password_expires"", ""reset_password_token"", ""change_email_expires"", ""change_email_token"", ""change_email_address"", ""verification_expires"", ""verification_token"", ""verified"", ""created_at"", ""updated_at"")
				VALUES (1, '#envUtil.getSystemSetting( "KUTT_AUTHTOKEN" )#', 'f', NULL, NULL, 'info@ortussolutions.com', '$2a$12$bNyOHO6onA6lvyyZNWGj6uWvM/ZLKrYQZfU3CRGqyGX1zIkeHsV9i', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 't', '2024-12-19 18:01:54.515789+00', '2024-12-19 18:02:49.362+00');
			"
			);
		} else {
			queryExecute(
				"
				UPDATE ""public"".""users"" SET ""apikey"" = '#envUtil.getSystemSetting( "KUTT_AUTHTOKEN" )#' WHERE ""email"" = 'info@ortussolutions.com'
			"
			);
		}

		variables.model = getWirebox().getInstance( "URLService@kutt" );
	}

	function afterAll(){
		if ( !isNull( variables.model ) ) {
			variables.model
				.list( all = true )
				.data
				.each( ( link ) => {
					variables.model.delete( id = link.id );
				} );
		}
	}

	function run(){
		describe( "Link CRUD", function(){
			it( "Can create a new tiny url", function(){
				var response = variables.model.create(
					target = "https://www.ortussolutions.com?foo=bar",
					reuse  = false
				);
				expect( response )
					.toBeStruct()
					.toHaveKey( "id" )
					.toHaveKey( "link" )
					.toHaveKey( "target" );
			} );

			it( "Can get a list of tiny urls", function(){
				var newLink = variables.model.create(
					target  = "https://www.ortussolutions.com?foo=tiny",
					expires = "1 hours",
					reuse   = false
				);
				var linkList = variables.model.list();

				expect( linkList )
					.toBeStruct()
					.toHaveKey( "limit" )
					.toHaveKey( "skip" )
					.toHaveKey( "total" )
					.toHaveKey( "data" );
				expect( linkList.data ).toBeArray();
				expect( linkList.data.len() ).toBeGTE( 1 );
			} );

			it( "Can delete a tiny url", function(){
				var newLink = variables.model.create(
					target  = "https://www.ortussolutions.com?foo=deletion",
					expires = "1 hours",
					reuse   = false
				);
				expect( newLink )
					.toBeStruct()
					.toHaveKey( "id" )
					.toHaveKey( "link" )
					.toHaveKey( "target" )
					.toHaveKey( "expire_in" );

				var linkId = newLink.id;

				var deleteResult = variables.model.delete( id = linkId );

				expect( deleteResult ).toBeStruct().toHaveKey( "message" );
				expect( deleteResult.message ).toContain( "deleted successfully" );
			} );


			it( "Can update a tiny url", function(){
				var newLink = variables.model.create(
					target  = "https://www.ortussolutions.com?foo=blah",
					expires = "1 hours",
					reuse   = false
				);

				expect( newLink )
					.toBeStruct()
					.toHaveKey( "id" )
					.toHaveKey( "link" )
					.toHaveKey( "target" )
					.toHaveKey( "expire_in" );

				expect( newLink.expire_in ).toBeDate();
				expect( dateDiff( "d", now(), newLink.expire_in ) ).toBeLT( 2 );

				var linkId = newLink.id;

				var updatedLink = variables.model.update(
					id      = linkId,
					target  = "https://www.ortussolutions.com?foo=blah",
					address = listLast( newLink.link, "/" ),
					expires = "1 days"
				);

				expect( updatedLink )
					.toBeStruct()
					.toHaveKey( "id" )
					.toHaveKey( "link" )
					.toHaveKey( "target" )
					.toHaveKey( "expire_in" );
				expect( updatedLink.expire_in ).toBeDate();

				expect( dateDiff( "d", now(), updatedLink.expire_in ) ).toBeLT( 31 );
			} );
		} );
	}

}
