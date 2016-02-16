local display = require( 'illuamination/display' );
local c = require( 'illuamination/common' );
local utils = require( 'illuamination/utils' );
local txt = require( 'routes/power-mountain/cave/_underground-atrium-text' )();

return function( main )
	
	c.setup();

	c.dialogue( txt[ 1 ] );

	local ind, previous_choice = c.choose( {
		'Go up.',
		'Go to the passage with rushing water.',
		'Go to the passage ahead.'
	} );
	c.setup( previous_choice );

	if( ind == 1 ) then
		main.set_route( 'power-mountain/cave/main-cave' );
	elseif( ind == 2 ) then
		main.set_route( 'power-mountain/cave/underground-waterfall' );
	elseif( ind == 3 ) then
		main.set_route( 'power-mountain/cave/underground-forest' );
	end

end
