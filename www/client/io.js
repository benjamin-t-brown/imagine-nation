'use strict';

var EventEmitter = require( 'events' ).EventEmitter;
var socket_io = global.io;
var io = new EventEmitter();

module.exports = io;
global.io = io;

var connection = socket_io( 'http://' + window.location.hostname + ':8080', {
	reconnection: false
} );
connection.on( 'connect', function() {
	console.log( 'Socket connected.' );
	io.send( 'start' );

	connection.on( 'disconnect', function() {
		console.log( 'Socket disconnected.' );
		io.emit( 'text', 'Disconnected.' );
	} );

	connection.on( 'error', function( err ) {
		console.error( 'Socket error.', err );
		io.emit( 'text', 'Connection Error.' );
	} );

	connection.on( 'message', function( message ) {
		try {
			if( message && message.event_name ) {
				io.emit( message.event_name, message.payload );
			} else {
				console.log( 'Message thrown out from socket' );
			}
		} catch( e ) {
			console.error( e.stack );
		}
	} );
} );

io.send = function( event_name, payload ) {
	connection.emit( 'message', {
		event_name: event_name,
		payload: payload
	} );
};

var queue = [];
io.queue = function( event_name, payload ) {
	queue.push( {
		event_name: event_name,
		payload: payload
	} );
};
io.drain_queue = function( ) {
	queue.forEach( function( packet ) {
		io.send( packet.event_name, packet.payload );
	} );
	queue = [];
};

