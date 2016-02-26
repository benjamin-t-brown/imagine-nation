'use strict';

var React = require( 'react' );
var ReactDOM = require( 'react-dom' );
var io = require( './io' );

var ChoicesContainer = React.createClass( {
	displayName: 'ChoicesContainer',
	handleClick: function( choice_index, e ){
		io.send( 'keypress', String( choice_index ) );
		e.stopPropagation();
		e.preventDefault();
	},
	render: function(){
		var elems = this.props.choices.map( function( choice_text, i ){
			return React.DOM.div( {
				key: i,
				onClick: this.handleClick.bind( null, i + 1 ),
				onTouchEnd: this.handleClick.bind( null, i + 1 ),
				className: 'no-select button'
			}, choice_text );
		}.bind( this ) );
		return React.DOM.div( {
			className: 'no-select',
			style:{
				backgroundColor: '#555555',
				textAlign: 'center',
				cursor: 'pointer',
				width: '100%',
				height: '30%'
			}
		}, elems );
	}
} );

var MainContainer = React.createClass( {
	displayName: 'MainContainer',
	getInitialState: function() {
		io.on( 'clear', this.handleOutputChange );
		io.on( 'output', this.handleOutputChange );
		io.on( 'readyState', this.handleReadyStateChange );
		return {
			text: 'Connecting...',
			choices: [],
			readyForInput: true
		};
	},
	handleOutputClear: function() {
		this.setState( {
			text: ''
		} );
	},
	handleOutputChange: function( text ) {
		text = text || '';
		window.text = text;
		text = text.replace( /Press enter to continue.../g, '' );
		console.log( text );
		var old_text = this.state.text;
		if( old_text > 10000 ) {
			old_text = old_text.slice( text.length );
		}
		var choices_ind = text.indexOf( '==========' );
		var choices = [ 'Continue' ];
		if( choices_ind > -1 ) {
			choices = text.slice( choices_ind ).slice( 52, -53 ).split( '\n' );
			text = text.slice( 0, choices_ind );
		}
		this.setState( {
			text: old_text + text,
			choices: choices
		} );
	},
	handleReadyStateChange: function( state ) {
		this.setState( {
			readyForInput: state
		} );
	},
	handleKeyDown: function( e ) {
		if( this.state.readyForInput ) {
			io.send( 'keypress', String.fromCharCode( e.which ) );
		}
	},
	componentDidMount: function() {
		window.addEventListener( 'keydown', this.handleKeyDown );
	},
	render: function() {
		var html = '<pre style="white-space: pre-wrap">' + this.state.text + '</pre>';
		return React.DOM.div( {
				style: {
					height: '100%',
					backgroundColor: 'black',
					color: 'white'
				},
			},
			React.DOM.div( {
				ref: function( node ){
					if( node ){
						node.scrollTop = node.scrollHeight;
					}
				},
				style: {
					height: '70%',
					overflowY: 'scroll',
					fontFamily: 'monospace',
					marginLeft: '10px',
					marginRight: '10px',
					width: 'calc( 100% - 10px )',
					backgroundColor: 'black',
					color: 'white'
				},
				dangerouslySetInnerHTML: {
					__html: html
				}
			} ),
			React.createElement( ChoicesContainer, {
				choices: this.state.choices
			} )
		);
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

