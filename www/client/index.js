'use strict';

var React = require( 'react' );
var ReactDOM = require( 'react-dom' );
var io = require( './io' );

var MainContainer = React.createClass( {
	displayName: 'MainContainer',
	getInitialState: function() {
		io.on( 'clear', this.handleOutputChange );
		io.on( 'output', this.handleOutputChange );
		io.on( 'readyState', this.handleReadyStateChange );
		return {
			text: 'Connecting...',
			readyForInput: true
		};
	},
	handleOutputClear: function() {
		this.setState( {
			text: ''
		} );
	},
	handleOutputChange: function( text ) {
		var old_text = this.state.text;
		if( old_text > 10000 ){
			old_text = old_text.slice( text.length );
		}
		text = text.replace( /Press enter to continue.../g, '' );
		this.setState( {
			text: old_text + text
		} );
	},
	handleReadyStateChange: function( state ) {
		this.setState( {
			readyForInput: state
		} );
	},
	handleKeyDown: function( e ) {
		console.log( 'KEYDOWN', String.fromCharCode( e.which ) );
		if( this.state.readyForInput ) {
			io.send( 'keypress', String.fromCharCode( e.which ) );
		}
	},
	componentDidMount: function() {
		window.addEventListener( 'keydown', this.handleKeyDown );
	},
	componentDidUpdate: function() {
		var node = ReactDOM.findDOMNode( this );
		document.body.scrollTop = node.scrollHeight;
	},
	render: function() {
		var html = '<pre style="white-space: pre-wrap">' + this.state.text + '</pre>';
		return React.DOM.div( {
			style: {
				minHeight: '100%',
				fontFamily: 'monospace',
				fontSize: '16px',
				width: '100%',
				backgroundColor: 'black',
				color: 'white'
			},
			dangerouslySetInnerHTML: {
				__html: html
			}
		} );
	}
} );

var container = document.createElement( 'div' );
document.body.appendChild( container );

var Main = global.Main = {};

var main_props = {
	main: Main
};
Main.render = function() {
	ReactDOM.render(
		React.createElement( MainContainer, main_props ),
		container
	);
};
Main.render();

var _resize_timeout = null;
window.addEventListener( 'resize', function() {
	if( _resize_timeout !== null ) {
		clearTimeout( _resize_timeout );
	}
	_resize_timeout = setTimeout( Main.render, 100 );
} );

