/* eslint no-console: 0, no-process-exit: 0 */
'use strict';

var shell = require( 'child_process' );
var argv = require( 'minimist' )( process.argv.slice( 2 ) );
var fs = require( 'fs' );

var NODE_PATH = '';

var env = Object.create( process.env );
env.NPM_CONFIG_COLOR = 'always';
var _execute = function( cmd, cb ) {
	console.log( cmd );
	var obj = shell.exec( cmd, {
		'env': env
	}, cb );
	obj.stdout.pipe( process.stdout );
	obj.stderr.pipe( process.stderr );
};

var rules = {
	'test-dev': function( cb ) {
		var cmd = `echo "There are no tests :)"`;
		_execute( cmd, cb );
	},

	'build-vendor': function( cb ) {
		var vendor_bundle = process.env.npm_package_config_bundles_vendor;
		var cmd = `${NODE_PATH} browserify ${_vendor_exports().join(' ')} | uglifyjs -c --screw-ie8 > ${vendor_bundle}`;
		_execute( cmd, cb );
	},
	'build-prod': function( cb ) {
		rules[ 'build-vendor' ]( function( error ) {
			if( error ) {
				return cb( error );
			}
			var entry = process.env.npm_package_config_bundles_main_entry;
			var bundle = process.env.npm_package_config_bundles_main_out;
			var cmd = `${NODE_PATH} browserify ${_vendor_imports().join(' ')} ${entry} | uglifyjs -c --screw-ie8 > ${bundle}`;
			_execute( cmd, cb );
		} );
	},
	'build': function( cb ) {
		var entry = process.env.npm_package_config_bundles_main_entry;
		var bundle = process.env.npm_package_config_bundles_main_out;
		var cmd =
			`${NODE_PATH} browserify ${_dev_flags()} ${_vendor_imports().join(' ')} ${entry} -o ${bundle}`;
		_execute( cmd, cb );
	},

	'watch': function( cb ) {
		var entry = process.env.npm_package_config_bundles_main_entry;
		var bundle = process.env.npm_package_config_bundles_main_out;
		var cmd = `${NODE_PATH} watchify ${_dev_flags()} ${_vendor_imports().join(' ')} ${entry} -o ${bundle}`;
		_execute( cmd, cb );
	},

	'clean-dev': function( cb ) {
		var main_bundle = process.env.npm_package_config_bundles_main_out;
		var cmd = `rm -f ${main_bundle}`;
		_execute( cmd, cb );
	},
	'clean': function( cb ) {
		var vendor_bundle = process.env.npm_package_config_bundles_vendor;
		var main_bundle = process.env.npm_package_config_bundles_main_out;
		var cmd = `rm -f ${vendor_bundle} ${main_bundle}`;
		_execute( cmd, cb );
	}
};
var rule = argv._.shift();
if( rules[ rule ] ) {
	rules[ rule ]( function( error ) {
		if( error ) {
			return process.exit( error.code );
		} else {
			return process.exit( 0 );
		}
	} );
} else {
	console.log( 'Invalid rule in site/scripts.js :', rule, argv );
	console.log( 'Valid rules:', Object.keys( rules ) );
	process.exit( 1 );
}

function _vendor_modules() {
	var base = 'npm_package_config_vendor_modules_',
		out = [],
		i = 0;
	while( process.env[ base + i ] ) {
		out.push( process.env[ base + i ] );
		i += 1;
	}
	return out;
}

function _vendor_exports() {
	return _vendor_modules().map( function( m ) {
		return '-r ' + m;
	} );
}

function _vendor_imports() {
	return _vendor_modules().map( function( m ) {
		return '-x ' + m;
	} );
}

function _dev_flags() {
	return [
		'-v',
		'--debug',
		'--full-paths'
	].join( ' ' );
}

