'use strict';

console.log( '[RUNNER] Node js LUA runner! Press enter to begin.\n' );

var proc = require( 'child_process' );

var is_lua_started = false;

var start_lua = function() {
	var lua = proc.spawn( 'lua-interpreter.exe', [ 'test.lua' ] );

	lua.stdout.setEncoding( 'utf-8' );
	lua.stdin.setEncoding( 'utf-8' );

	lua.stdout.on( 'data', ( data ) => {
		var str = data.toString();
		var ind = str.indexOf( '♀' );
		if( ind > -1 ) {
			console.log( "CLEAR SCREEN" );
			str = str.slice( ind );
		}
		process.stdout.write( data.toString() );
	} );

	lua.stderr.on( 'data', ( data ) => {
		process.stdout.write( data.toString() );
	} );

	lua.on( 'close', ( code ) => {
		console.log( `[RUNNER] LUA exicted with code ${code}` );
		lua.stdin.end();
		process.exit( 0 ); //eslint-disable-line no-process-exit
	} );

	return lua;
};

var capture_keypresses = function() {
	var lua = null;

	process.stdin.setRawMode( true );
	process.stdin.on( 'data', function( b ) {
		var str = b.toString();
		if( str.indexOf( '\n' ) > -1 || str.indexOf( '\r' ) > -1 || str.length === 0 ) {
			str = 'ENTER';
		}

		if( str === 'ENTER' && !is_lua_started ) {
			lua = start_lua();
			is_lua_started = true;
		} else {
			if( !isNaN( parseInt( str ) ) ) {
				lua.stdin.write( str );
			} else {
				lua.stdin.write( str + '\n' );
			}
		}
		//console.log( '[RUNNER]', str );
		if( b[ 0 ] === 3 ) {
			process.stdin.setRawMode( false );
			process.exit( 1 ); //eslint-disable-line no-process-exit
		}
	} );
	process.stdin.resume();
};

capture_keypresses();

