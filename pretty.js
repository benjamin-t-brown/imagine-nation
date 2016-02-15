/* eslint no-regex-spaces: 0, no-return-assign: 0 */
'use strict';

var fs = require( 'fs' );
var url = process.argv[ 2 ];

var NEWLINE = '\n';
var INDENT = '\t';

var random_id = function( len ) {
	var str = '';
	for( var i = 0; i < len; i++ ) {
		str += String.fromCharCode( Math.floor( Math.random() * 24 + 97 ) );
	}
	return str;
};

var pretty_string = function( string ) {
	console.log( 'INPUT:\n' + string, '\n--------------' );
	var ret = '';
	var maps = {};

	var current_indentation_level = 0;
	var next_indentation_level = 0;
	var current_consecutive_newlines = 0;

	//config
	var config = {
		max_consecutive_newlines: 1,
		spaces_per_tab: 1,
		no_spaces_before_parens: true,
		spaces_in_parens: true
	};

	var _add_newline = function( str, ind ) {
		var regex = new RegExp( NEWLINE );
		if( !( regex.test( str.slice( ind - 1, ind + 1 ) ) ) ) { //If there isn't a newline already there
			return str.slice( 0, ind ) + NEWLINE + str.slice( ind );
		} else {
			return str;
		}
	};
	var _get_indentation = function( level ) {
		var ret = '';
		for( var i = 0; i < level; i++ ) {
			ret += INDENT;
		}
		return ret;
	};
	var _apply_indentation = function( line, level ) {
		return _get_indentation( level ) + line; //indent line
	};
	var _find_all = function( line, regex, cb ) {
		var i = 0;
		var match = line.match( regex );
		while( match ) {
			var modified_line = cb( match[ 0 ], match.index + i, match );
			i = i + match.index + match[ 0 ].length + ( modified_line.length - line.length );
			line = modified_line;
			var match = line.slice( i ).match( regex );
		}
	};

	var _map_expression = function( str, regex, pattern_index ) {
		var obj = {};
		_find_all( str, regex, function( match, _, patterns ) {
			var id = random_id( 15 );
			var mapped_value = pattern_index ? patterns[ pattern_index ] : match;
			str = str.replace( mapped_value, ' ' + id + ' ' );
			console.log( 'MAP', mapped_value, 'to', id, 'via', regex.toString() );
			obj[ id ] = mapped_value;
			return str;
		} );
		return {
			str: str,
			mapping: obj
		};
	};
	var _unmap_expression = function( str, mapping ) {
		for( var i in mapping ) {
			console.log( 'UNMAP "' + ' ' + i + ' ' + '"' );
			var regex = new RegExp( ' ?' + i + ' ?' );
			str = str.replace( regex, mapping[ i ] );
		}
		return str;
	};

	//extract all dash comments
	var obj = _map_expression( string, /--(.)*/ );
	string = obj.str;
	maps.COMMENTS = obj.mapping;
	//extract all quoted strings
	var obj = _map_expression( string, /(["'])(?:(?=(\\?))\2.)*?\1/ );
	string = obj.str;
	maps.STRINGS = obj.mapping;
	//extract all multiline strings
	var obj = _map_expression( string, /\[\[([\s\S]*?)\]\];?/ );
	string = obj.str;
	maps.MULTI_STRINGS = obj.mapping;

	//make sure all loops reside on the same line, otherwise parsing is dumb (also add semi colon for newline generation)
	string = string.replace( /(for|while)(.*?)do/g, function( match ){
		return match.replace( '\n', ' ' );
	} );
	//extract for loops (can probably be combined with previous expression)
	var obj = _map_expression( string, /(for|while)(.*?)do/, 2 );
	string = obj.str;
	maps.FOR_LOOPS = obj.mapping;

	//STEP 1: Preformat and add newlines where necessary, but keep newline spacing if it's there
	string.split( '\n' ).forEach( function( line ) {
		line = line.trim(); //remove all spaces on both ends
		line = line.replace( /\(/g, ' (' ); //add a space before open parantheses to make parsing easier
		line = line.replace( /(=|\+|-|\*|\/)/g, ' $1 ' ); //add a space around all operators to make parsing easier
		line = line.replace( /\t+/g, '' ); //remove all tabs
		line = line.replace( /( ; )|(; )|( ;)/g, '; ' ); //replace all whitespace around semis with semi plus whitespace
		line = line.replace( /\};/, '\} ;' ); //add a space before semis after brackets for easier parsing
		line = line.replace( /  +/g, ' ' ); //replace all whitespaces with one space
		line = line.replace( /= =/, '==' ); //fix the stupid thing that happens sometimes
		console.log( '.)', "'" + line + "'" );

		var _add_newline_after_match = function( match, match_index ) {
			//console.log( 'MATCH FOUND', match, match_index, match.length, match_index + match.length, line.length );
			if( match_index + match.length < line.length ) {
				//remove the space after the match
				//line = line.slice( 0, match_index + match.length ) + line.slice( match_index + match.length + 1 );
				line = _add_newline( line, match_index + match.length );
			}
			return line;
		};
		var _isolate_match = function( match, match_index ) {
			if( line.length === match.length ) { //The match is already isolated
				//dont do anything
			} else if( match_index + match.length >= line.length ) { //The match is at the end of the line
				line = _add_newline( line, match_index );
			} else if( match_index === 0 ) { //The match is at the beginning of the line
				line = _add_newline( line, match_index + match.length );
			} else { //The match is somewhere in the middle
				line = _add_newline( line, match_index + match.length );
				line = _add_newline( line, match_index );
			}
			return line;
		};
		var _variable_decl = function( match, match_index, patterns ) {
			if( match_index + match.length >= line.length ) { //end of line
				//dont do anything, a new line is added at the end of this function
			} else if( patterns[ 3 ].indexOf( ' = ' ) > -1 ) { //two variables declared on the same line without separators
				line = _add_newline( line, match_index + match.length - patterns[ 3 ].length );
			} else {
				line = _add_newline( line, match_index + match.length );
			}
			return line;
		};
		var _newline_before = function( match, match_index ) {
			if( line[ match_index ] !== NEWLINE && match_index !== 0 ) {
				line = _add_newline( line, match_index );
			}
			return line;
		};

		//there should be a newline after every semi or comma
		_find_all( line, /(;)/, _add_newline_after_match );
		//there should be a newline after every do
		_find_all( line, / do /, _add_newline_after_match );
		//traditional function declaration: "function t(a, b)"
		_find_all( line, /function \(.*\)/, _add_newline_after_match );
		//function declarations as variables: "local t = function(a, b)"
		_find_all( line, /function [\w]+ \(.*\)/, _add_newline_after_match );
		//if/elseif declarations
		_find_all( line, /(else)?(if)(.*?)(then|$)/, _add_newline_after_match );

		//isolate all instance of 'end'
		_find_all( line, /end[\);]*/, _isolate_match );
		//isolate all declaration of objects
		_find_all( line, /(local )?[\w] = \{/, _isolate_match );
		//one variable declaration per line
		_find_all( line, /(local )?[\w] = (.*?)(( local )?\w = |$|;)/, _variable_decl );
		//add newline after functions with a comma or semi
		_find_all( line, /[\w] \((.*?)\)(;)/, _add_newline_after_match );
		//put a newline before ending objects
		_find_all( line, /\}/, _newline_before );

		//limit the number of consecutive newlines
		if( line.length ) {
			ret += line + NEWLINE;
			current_consecutive_newlines = 0;
		} else {
			current_consecutive_newlines++;
			if( current_consecutive_newlines <= config.max_consecutive_newlines ) {
				ret += line + NEWLINE;
			}
		}
	} );

	//STEP 2: Add indentation
	ret = ret.split( '\n' ).map( function( line ) {
		//clean up trimming
		line = line.trim();
		if( /elseif/.test( line ) ) {
			current_indentation_level--;
			next_indentation_level = current_indentation_level + 1;
		} else if( /function|\{/.test( line ) || /if(.*?)(then|$)/.test( line ) || / do/.test( line ) ) {
			next_indentation_level++;
		} else if( /(end)|(\})/.test( line ) ) {
			current_indentation_level--;
			next_indentation_level = current_indentation_level;
		}

		line = _apply_indentation( line, current_indentation_level );
		current_indentation_level = next_indentation_level;
		return line;
	} ).join( '\n' );

	if( config.no_spaces_before_parens ) {
		ret = ret.replace( / \(/g, '(' ); //remove space before open parentheses
	}

	if( config.spaces_in_parens ){
		ret = ret.replace( /\( \)/g, '()' );
		ret = ret.replace( /\(([^\n]+)\)/g, '( $1 )' );
	}

	ret = _unmap_expression( ret, maps.MULTI_STRINGS );
	ret = ret.replace( /\[\[/, ' [[' ); // do i need to do this?

	ret = _unmap_expression( ret, maps.COMMENTS );
	ret = _unmap_expression( ret, maps.STRINGS );
	ret = _unmap_expression( ret, maps.FOR_LOOPS );

	return ret;
};

console.log( 'PRETTY', url );
fs.readFile( url, function( err, data ) {
	if( err ) {
		throw err;
	}

	console.log( '--------------\nRESULT:\n' + pretty_string( data.toString() ) );
} );

