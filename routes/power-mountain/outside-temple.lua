local display = require( 'illuamination/display' );
local c = require( 'illuamination/common' );

return function( main )
	c.setup();
	local text = {
		'You stand at a fork between two identical passages: both clearly man-made. Torches line the walls, draping flickering shadows of rocks across the floor.'
	};

	if( main.data.conscience.in_party == false ) then
		text[ #text + 1 ] = 'The voice you heard in the large cavern has stopped.';

	elseif( c.is_trigger( 'conscience_choice_fork', main ) ) then
		text[ #text + 1 ] = 'CONSCIENCE: "The door I found is just over to the left, once we get there we can figure out how to get through it!" She seems a bit too excited for this sort of thing.';
		c.disable_trigger( 'conscience_choice_fork' , main );
	end

	c.dialogue( text );

	local ind, previous_choice = c.choose( {
		'Take the left fork.' ,
		'Take the right fork.'
	} );
	c.setup( previous_choice );

	if ind == 1 then
		c.dialogue( { 
			'You take the left fork and begin going down a walkway of torches.'
		}, true );
		main.set_route( 'power-mountain/golem-temple/left-fork' );
	elseif ind == 2 then
		c.dialogue( { 'You take the right fork.' }, true );
		main.set_route( 'power-mountain/golem-temple/right-fork' );
	end
end

