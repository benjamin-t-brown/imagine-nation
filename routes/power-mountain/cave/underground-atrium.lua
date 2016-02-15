local display = require( 'display' );
local c = require( 'common' );
local utils = require( 'utils' );

return function( main )
	c.setup();

	c.dialogue( {
		'You stand in a small cavern below the large pool of water in the large cavern above.  Water droplets drip noisily from the ceiling, and you get a foreboding sense that the ceiling could collapse on top of you at any moment.',
		'The noise of water rushing is coming from a passage to your left, but the passage ahead of you is silent.  You can also go up into the large cavern with the pool.'
	} );

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
