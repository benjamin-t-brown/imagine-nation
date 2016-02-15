local display = require( 'display' );
local c = require( 'common' );
local utils = require( 'utils' );

return function( main )
	c.setup();

	::initial_choice::

	c.dialogue( {
		'You see stream winding its way through this passage, extruding out of the left wall and continuing further on.  It seems to be the same water that was in the pool somewhere above you.  It blocks your path.',
		'A massive tree trunk grows out of one of the walls, its roots firmly entrenched between broken boulders and other thick rocks.  The stream goes directly underneath it at one point.'
	} );
	local ind, previous_choice = c.choose( {
		'Leave.',
		'Cross the stream.',
		'Approach the tree.'
	} );
	c.setup( previous_choice );

	if( ind == 1 ) then
		main.set_route( 'power-mountain/cave/underground-atrium' );
	elseif( ind == 2 ) then
		c.dialogue( {
			'The stream is very shallow and you have no problem skipping over it.  However, once you get to the other side you see clearly that the cave has a very sharp drop off.  You follow the stream down the cavern a ways and discover that it makes its way off of the cliff edge.  It seems you cannot continue this way.',
			'You go back to the entrance of the room.'
		}, true );
		c.setup();		
		goto initial_choice;
	elseif( ind == 3 ) then
		local text = {
			'You approach the tree.'
		};
		local choices = {
			'Go back.'
		};

		if( utils.index_of( 'Dry Wood', main.data.inventory ) == 0 ) then
			text[ #text + 1 ] = 'It appears to be dead. Its wood is dry, and its roots seem to be withering.  At second glance, though, you notice something rather odd: the stream brushes up against one of the tree\'s roots, yet somehow the root is still extremely dry.';

			choices[ #choices + 1 ] = 'Inspect the root.';
		end

		c.dialogue( text );

		local ind, previous_choice = c.choose( choices );
		c.setup( previous_choice );

		if( ind == 1 ) then -- Go Back
			goto initial_choice;
		elseif( ind == 2 ) then -- Get Plank
			c.dialogue( {
				'How strange!  Upon closer inspection, you see that the stream actually runs beneath the root, which is single-handedly holding up the cave floor above it by floating on the stream.  You wonder if there is another pool of water under your feet, and if this tree is the only thing keeping you dry.  Perhaps because the tree is so dry, it does not absorb the water and remains buoyant.',
				'A piece of the tree\'s bark juts out from the root. The wood\'s powerful buoyancy seems useful, so you break it off and carry it with you.'
			}, true );

			c.inventory_add( 'Dry Wood', main );
			c.setup();
			goto initial_choice;
		end		
	end

end
