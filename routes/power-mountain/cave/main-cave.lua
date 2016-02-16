local display = require( 'illuamination/display' );
local c = require( 'illuamination/common' );
local utils = require( 'illuamination/utils' );

return function( main )
	local txt = require( 'routes/power-mountain/cave/_main-cave-text' )();
	c.setup();

	local text = txt[ 1 ];

	if( main.data.conscience.in_party ) then
		text[ #text ] = nil;
	end

	::initial_choice::

	c.dialogue( text );
	local ind, previous_choice = c.choose( {
		'Cross the pool of water to the exit on the other side.',
		'Go further underground.'
	} );
	c.setup( previous_choice );

	if( ind == 1 ) then
		::pool_choice::

		c.dialogue( txt[ 2 ] );
		local ind, previous_choice = c.choose( {
			'Eh, too scary, go back.',
			'Throw a rock into the pool.',
			'Try to swim across anyway.'
		} );
		c.setup( previous_choice );

		if( ind == 1 ) then
			c.setup( previous_choice );
			goto initial_choice;
		elseif( ind == 2 ) then
			c.dialogue( txt[ 3 ], true );
			goto pool_choice
		elseif( ind == 3 ) then
			if( utils.index_of( 'Dry Wood', main.data.inventory ) > 0 ) then
				c.dialogue( txt[ 4 ], true );
				main.set_route( 'power-mountain/golem-temple/start' );
			else
				c.dialogue( txt[ 5 ], true );
				main.set_route( 'power-mountain/cave/underground-waterfall' );
			end
		end
	elseif( ind == 2 ) then
		main.set_route( 'power-mountain/cave/underground-atrium' );
	end

end
