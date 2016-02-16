local display = require( 'display' );
local c = require( 'common' );
local utils = require( 'utils' );
local cave = require( 'pics/cave' );
local txt = require( 'routes/power-mountain/cave/_start-text' )();

return function( main )
	c.setup();

	c.dialogue( txt[ 1 ] );

	::beginning::

	local ind, previous_choice = c.choose( {
		'Attempt to make your way out of the cave.',
		'Call for help.'
	} )
	c.setup( previous_choice );

	if ind == 1 then
		c.dialogue( txt[ 2 ], true );

		c.pic( cave.cave() );
		c.dialogue( { 'The Temple of Power' }, true );

		main.set_route( 'power-mountain/cave/main-cave' );
	elseif ind == 2 then
		c.dialogue( txt[ 3 ], true );

		goto beginning
	end

end