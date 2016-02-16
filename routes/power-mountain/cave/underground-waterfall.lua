local display = require( 'illuamination/display' );
local c = require( 'illuamination/common' );
local utils = require( 'illuamination/utils' );
local txt = require( 'routes/power-mountain/cave/_underground-waterfall-text' )();

return function( main )
	c.setup();

	c.dialogue( txt[ 1 ] );

	local ind, previous_choice = c.choose( {
		'Leave.'
	} );
	c.setup( previous_choice );

	if( ind == 1 ) then
		main.set_route( 'power-mountain/cave/underground-atrium' );
	end
end
