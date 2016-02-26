'use strict';

var winston = require( 'winston' );

'use strict';

var _fix_type = function( maybe_num ) {
	var num = Number( maybe_num );
	return isNaN( num ) ? String( maybe_num ).toLowerCase() : num;
};
var _chunkify = function( str ) {
	return String( str ).match( /(\d+\.?\d*|\D+)/g ).map( _fix_type );
};
var _natsort = function( dir, a, b ) {
	var ac = _chunkify( a ),
		bc = _chunkify( b );
	for( var i = 0; ac[ i ] && bc[ i ]; ++i ) {
		if( ac[ i ] !== bc[ i ] ) {
			if( typeof ac[ i ] === 'number' && typeof bc[ i ] === 'number' ) {
				if( dir === 'asc' ) {
					return ac[ i ] - bc[ i ];
				} else if( dir === 'desc' ) {
					return bc[ i ] - ac[ i ];
				}
			} else {
				if( dir === 'asc' ) {
					return ( ac[ i ] > bc[ i ] ) ? 1 : -1;
				} else if( dir === 'desc' ) {
					return ( ac[ i ] < bc[ i ] ) ? 1 : -1;
				}
			}
		}
	}
	if( dir === 'asc' ) {
		return ac.length - bc.length;
	} else if( dir === 'desc' ) {
		return bc.length - ac.length;
	}
};

var _fn = function( dir, a, b ) {
	if( arguments.length === 2 ) {
		var _get;
		if( typeof a === 'string' ) {
			_get = function( obj ) {
				return obj[ a ];
			};
		} else {
			_get = a;
		}
		return function( a, b ) {
			return _natsort( dir, _get( a ), _get( b ) );
		};
	} else {
		return _natsort( dir, a, b );
	}
};

var _asc = _fn.bind( null, 'asc' ),
	_desc = _fn.bind( null, 'desc' );
_asc.asc = _asc;
_asc.desc = _desc;

module.exports = {
	log: function() {
		var args = Array.prototype.slice.call( arguments );
		winston.info.apply( winston, args );
	},
	error: function() {
		var args = Array.prototype.slice.call( arguments );
		winston.error.apply( winston, args );
	},
	random_numeric_id: function( len ) {
		var text = '';
		var possible = '1234567890';
		for( var i = 0; i < len; i++ ) {
			text += possible.charAt( Math.floor( Math.random() * possible.length ) );
		}
		return parseInt( text );
	},
	normalize: function( x, A, B, C, D ) {
		return C + ( x - A ) * ( D - C ) / ( B - A );
	},
	natsort: _asc,
	get_uuid: function() {
		return module.exports.random_numeric_id( 15 );
		// return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace( /[xy]/g, function( c ) {
		// 	var r = Math.random() * 16 | 0,
		// 		v = c === 'x' ? r : ( r & 0x3 | 0x8 );
		// 	return v.toString( 16 );
		// } );
	}
};

