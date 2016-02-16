local display = require( '../display' );
local c = require( '../common' );

return function( main )
	local txt = require( 'routes/power-mountain/golem-temple/_choice-fork-text' )();
	c.setup();
	local text = txt[ 1 ]

	if( main.data.conscience.in_party == false ) then
		text[ #text + 1 ] = txt[ 2 ][ 1 ];
	elseif( c.is_trigger( 'conscience_choice_fork', main ) ) then
		text[ #text + 1 ] = txt[ 3 ][ 1 ]
		c.disable_trigger( 'conscience_choice_fork', main ) ;
	end

	c.dialogue( text );

	local ind, previous_choice = c.choose( {
		'Take the left fork.',
		'Take the right fork.'
	} )
	c.setup( previous_choice );

	if ind == 1 then
		c.dialogue( txt[ 4 ], true );
		main.set_route( 'power-mountain/golem-temple/left-fork' );
	elseif ind == 2 then
		c.dialogue( { 'You take the right fork.' }, true );
		main.set_route( 'power-mountain/golem-temple/right-fork' );
	end
end
