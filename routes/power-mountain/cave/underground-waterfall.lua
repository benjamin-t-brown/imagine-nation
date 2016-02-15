local display = require( 'display' );
local c = require( 'common' );
local utils = require( 'utils' );

return function( main )
	c.setup();

	c.dialogue( {
		'In this cavern, a small waterfall comes out of the ceiling and pushes water into stream that goes into the cave wall.  You do not think you could you could force your way through the stream, as the hole is too small and the rocks around it look rather sharp.',
		'You can only see one way out.'
	} );

	local ind, previous_choice = c.choose( {
		'Leave.'
	} );
	c.setup( previous_choice );

	if( ind == 1 ) then
		main.set_route( 'power-mountain/cave/underground-atrium' );
	end
end
