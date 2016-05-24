'use strict';

var winston = require( 'winston' );
var http_server = require( './http-server' );
var io_server = require( './io-server' );
var exec = require( 'child_process' ).exec;

var games = {};

var IS_WINDOWS = process.env.NODE.search( 'exe' ) > -1;

winston.debug( 'WINDOWS?', IS_WINDOWS );

var Game = function( socket ) {
	this.socket = socket;
	var cmd = 'cd ' + __dirname + '\\..\\..\\ && ' + ( IS_WINDOWS ? 'lua-interpreter.exe' : 'lua' ) + ' init.lua 1';
	console.log( 'EXEC', cmd );
	this.child = exec( cmd );
	this.child.stdout.on( 'data', function( data ) {
		var str = data.toString();
		if( str.indexOf( '♀' ) > -1 ) {
			winston.info( 'CLEAR' );
			io_server.send( this.socket, 'clear' );
		}

		winston.debug( 'str', str );

		io_server.send( this.socket, 'output', str );
		io_server.send( this.socket, 'readyForInput', true );
	}.bind( this ) );

	this.child.stderr.on( 'data', function( data ) {
		io_server.send( this.socket, 'output', data.toString() );
	}.bind( this ) );
};

Game.prototype.write = function( key ) {
	if( '0123456789'.indexOf( key ) > -1 ) {
		this.child.stdin.write( key + '\r\n' );
	} else {
		this.child.stdin.write( '\r\n' );
	}
};

Game.prototype.end = function() {
	console.log( 'Game stopped', this.socket.id );
	this.child.stdin.write( 'exit\r\n' );
};

var PORT = 8080;
var hs = http_server.start( PORT );
io_server.start( null, hs );

winston.info( 'Now listening on port: ' + PORT );

io_server.on( 'connection', function( _, socket ) {
	if( games[ socket.id ] ) {
		games[ socket.id ].end();
		delete games[ socket.id ];
	}
	games[ socket.id ] = new Game( socket );
} );

io_server.on( 'disconnection', function( _, socket ) {
	if( games[ socket.id ] ) {
		games[ socket.id ].end();
		delete games[ socket.id ];
	}
} );

io_server.on( 'keypress', function( key, socket ) {
	if( games[ socket.id ] ) {
		games[ socket.id ].write( key );
	}
} );

