
print( 'Print test.' );
io.write( 'IO test 1.\n' );
io.write( 'IO test 2.\n\n' );

local display = require( 'display' );
local c = require( 'common' );
local logo = require( 'pics/logo' );

print( 'Logo test:' );
c.pic( logo.logo() );

print( 'Dialogue test:' );
c.dialogue( {
	'This is some dialogue.',
	'This is another paragraph of dialogue.'
} );

print( 'Dialogue input test:' );
c.dialogue( {
	'Read this dialogue and then press enter to continue testing.' 
}, true );

print( 'Choice input test:' );
local ind, previous_choice = c.choose( {
	'Pick this choice.',
	'Or maybe pick this choice.',
	'You could also pick this choice.'
} );
c.dialogue( {
	'You chose choice ' .. tonumber( ind ) .. ': "' .. previous_choice .. '"'
}, true );

print( 'Clear screen test.' );
display.clear();
c.dialogue( {
	'The screen should have been cleared, and this should be the only text you see.'
}, true );
