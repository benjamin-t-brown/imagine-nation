local logo = require( 'pics/logo' );
local display = require( 'display' );
local c = require( 'common' );

return function( main )
	c.setup();
	c.pic( logo.logo() );

	c.dialogue( {
		'Press the corresponding number to make a choice.'
	} );

	local ind, previous_choice = c.choose( {
		'New Game',
		'Exit'
	} );
	if ind == 1 then
		main.set_route( 'beginning-cutscene' );
	elseif ind == 2 then
		main.set_route( nil );
	end
end
