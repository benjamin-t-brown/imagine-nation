'use strict';

var fs = require( 'fs' );
var SPLSTR = 'AdalaisEldridge';
var NEWLINE = 'NEWLINE';
var args = process.argv.slice( 2 );

var compile = function( text ) {
	var matches = text.match( /\- (.*) \-/g );
	var contents = text.split( /\- .*? \-/g ).slice( 1 );

	contents.forEach( function( subtext, index ) {
		subtext = subtext
			.replace( /\r/g, '' )
			.replace( /\n\n/g, SPLSTR )
			.replace( /\n/g, NEWLINE );

		var ret = 'return function() \nreturn {\n ' + subtext.split( SPLSTR ).slice( 1 ).map(
			function( dialogue, i ) {
				return '[ ' + ( i + 1 ) + ' ] = { [[' + dialogue.replace( /NEWLINE/g, '\n' ) + ']] }\n';
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
