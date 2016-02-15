local display = require( 'display' );
local c = require( 'common' );
local utils = require( 'utils' );
local cave = require( 'pics/cave' );

return function( main )
	c.setup();

	c.dialogue( {
		'It is silent.  The howling vortex of noise that had been nearly tearing apart your ears just a moment ago has stopped.',
		'You stand at a dead end in a cave, dimly lit by glowing mushrooms and other fungus. The walls are made of rounded rocks, and are wet to the touch.  You can barely make out a way through the cave just ahead of you, although it seems rather dangerous.'
	} );

	::beginning::

	local ind, previous_choice = c.choose( {
		'Attempt to make your way out of the cave.',
		'Call for help.'
	} )
	c.setup( previous_choice );

	if ind == 1 then
		c.dialogue( {
			'You make your way forward slowly, tripping on outcropped rocks at every step, but you have just enough vision to see where you are going.  The cave walls around you slowly start to widen until they eventually give way to a large cave.'
		}, true );

		c.pic( cave.cave() );
		c.dialogue( { 'The Temple of Power' }, true );

		main.set_route( 'power-mountain/cave/main-cave' );
	elseif ind == 2 then
		c.dialogue( {
			'You yell for help as loud as you can, and your voice echoes all around.  Nothing else appears to happen.'
		}, true );

		goto beginning
	end

end