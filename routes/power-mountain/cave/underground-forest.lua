local display = require( 'display' );
local c = require( 'common' );
local utils = require( 'utils' );

return function( main )
	local txt = require( 'routes/power-mountain/cave/_underground-forest-text' )();
	c.setup();

	::initial_choice::

	c.dialogue( txt[ 1 ] );
	local ind, previous_choice = c.choose( {
		'Leave.',
		'Cross the stream.',
		'Approach the tree.'
	} );
	c.setup( previous_choice );

	if( ind == 1 ) then
		main.set_route( 'power-mountain/cave/underground-atrium' );
	elseif( ind == 2 ) then
		c.dialogue( txt[ 2 ], true );
		c.setup();		
		goto initial_choice;
	elseif( ind == 3 ) then
		local text = txt[ 3 ];
		local choices = {
			'Go back.'
		};

		if( utils.index_of( 'Dry Wood', main.data.inventory ) == 0 ) then
			text[ #text + 1 ] = txt[ 4 ][ 1 ];
			choices[ #choices + 1 ] = 'Inspect the root.';
		end

		c.dialogue( text );

		local ind, previous_choice = c.choose( choices );
		c.setup( previous_choice );

		if( ind == 1 ) then -- Go Back
			goto initial_choice;
		elseif( ind == 2 ) then -- Get Plank
			c.dialogue( txt[ 5 ], true );
			c.inventory_add( 'Dry Wood', main );
			c.setup();
			goto initial_choice;
		end		
	end

end
