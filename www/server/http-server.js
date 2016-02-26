'use strict';

var winston = require( 'winston' );
var http = require( 'http' );
var fs = require( 'fs' );

var get_mime_type = function( extension ) {
	var mimes = {
		js: 'text/javascript',
		html: 'text/html',
		css: 'text/css',
		png: 'image/png',
		gif: 'image/gif',
		jpeg: 'image/jpeg',
		jpg: 'image/jpeg',
		bmp: 'image/bmp'
	};

	return mimes[ extension ] || 'text/plain';
};

var parse_url = function( url ) {
	var path = url.split( /\/|\\/ );
	var ret = {
		extension: '',
		filename: '',
		url: path.join( '/' )
	};

	if( path[ 1 ].toLowerCase() === 'server' ) {
		ret.url = '/topkek';
		return ret;
	}

	var match = path.slice( -1 )[ 0 ].match( /\.(.*?)$/ );
	if( match ) {
		ret.extension = ( match[ 1 ] || '' ).toLowerCase();
	}

	ret.filename = path.slice( -1 )[ 0 ];

	if( path.length === 2 && path.slice( -1 )[ 0 ].length <= 1 ) {
		ret.extension = 'html';
		ret.filename = 'index';
		ret.url = '/index.html';
	}

	return ret;
};

var GET_handlers = {};

module.exports = {
	start: function( port ) {
		return http.createServer( function( request, response ) {
			var url_obj = parse_url( request.url );
			if( request.method.toUpperCase() === 'GET' ) {
				var new_url = __dirname + '/..' + url_obj.url;
				winston.info( 'GET', url_obj.url, new_url );
				if( url_obj.extension ) {
					fs.exists( new_url, function( exists ) {
						if( exists ) {
							fs.readFile( new_url, function( err, data ) {
								if( err ) {
									response.statusCode = 500;
									response.end( err );
									return;
								}
								response.statusCode = 200;
								response.writeHead( 200, {
									'content-type': get_mime_type( url_obj.extension )
								} );
								response.end( data );
							} );
						} else {
							response.statusCode = 404;
							response.end( 'Not Found: ' + url_obj.url );
						}
					} );
				} else {
					if( GET_handlers[ url_obj.url ] ) {
						GET_handlers[ url_obj.url ]( response );
					} else {
						response.statusCode = 404;
						response.end( 'Not Found: ' + url_obj.url );
					}
				}
			} else {
				response.statusCode = 400;
				response.end( 'Forbidden: ' + url_obj.url );
			}
		} ).listen( port );
	},
	respond: function( response, code, json ) {
		response.statusCode = code;
		response.writeHead( code, {
			'content-type': 'text/plain'
		} );
		response.end( JSON.stringify( json ) );
	},
	on: function( url, cb ) {
		GET_handlers[ url ] = cb;
	}
};
