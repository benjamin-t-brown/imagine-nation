'use strict';

var fs = require( 'fs' );
var SPLSTR = 'AdalaisEldridge';
var args = process.argv.slice( 2 );

function addslashes( str ) {
	return ( str + '' ).replace( /[\\"']/g, '\\$&' ).replace( /\u0000/g, '\\0' );
}

var compile = function( text ) {
	var matches = text.match( /\- (.*) \-/g );
	var contents = text.split( /\- .*? \-/g ).slice( 1 );

	contents.forEach( function( subtext, index ) {
		subtext = subtext
			.replace( /\r/g, '' )
			.replace( /\n\n/g, SPLSTR )
			.replace( /\n/g, '' );

		var ret = 'return function() \nreturn {\n ' + subtext.split( SPLSTR ).slice( 1 ).map(
			function( dialogue, i ) {
				return '[ ' + ( i + 1 ) + ' ] = { "' + addslashes( dialogue ) + '" }\n';
			} ) + '} \nend';

		var filename = __dirname.replace( /\\/g, '/' ) + '/routes/' + matches[ index ].replace(
			'- ', '' ).replace( ' -', '' ) + '-text.lua';
		var spl = filename.split( '/' );
		spl[ spl.length - 1 ] = '_' + spl[ spl.length - 1 ];
		filename = spl.join( '/' );
		console.log( filename );
		fs.writeFileSync( filename, ret );
	} );
};

for ( var i in args ) {
	compile( fs.readFileSync( args[ i ] ).toString() );
}
