'use strict';

var io = require( 'socket.io' );
var winston = require( 'winston' );
var EventEmitter = require( 'events' ).EventEmitter;

var server = new EventEmitter();

var LOG_IO_MESSAGES = false;

var events = {
	disconnect: function( socket ) {
		try {
			server.emit( 'disconnection', {}, socket );
		} catch( e ) {
			winston.error( e.stack );
		}
	},
	error: function( socket, err ) {
		winston.error( err );
	},
	message: function( socket, message ) {
		try {
			if( message && message.event_name ) {
				if( LOG_IO_MESSAGES ) {
					winston.info( 'IO EVENT', message.event_name, message.payload, socket.id );
				}
				server.emit( message.event_name, message.payload, socket );
			} else {
				winston.info( 'Message thrown out for socket: ', socket.id );
			}
		} catch( e ) {
			winston.error( e.stack );
		}
	},
};

server.start = function( port, http_server ) {
	var io_server = io( http_server || port, {
		'pingTimeout': 15000,
		'pingInterval': 3000
	} );

	io_server.on( 'connection', function( socket ) {
		try {
			for( var event_name in events ) {
				socket.on( event_name, events[ event_name ].bind( null, socket ) );
			}

			server.emit( 'connection', {}, socket );
		} catch( e ) {
			winston.error( e.stack );
		}
	} );
	return io_server;
};
server.destroy_socket = function( socket ) {
	socket.removeAllListeners();
	socket.disconnect();
};
server.send = function( socket, event_name, payload ) {
	socket.emit( 'message', {
		event_name: event_name,
		payload: payload
	} );
};

module.exports = server;

