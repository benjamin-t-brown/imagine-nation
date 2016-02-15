local display = require( 'display' );
local c = require( 'common' );
local utils = require( 'utils' );

return function( main )
	c.setup();

	local text = {
		'You stand inside of a massive cavern, cracks on the ceiling allowing slim rays of sunlight to cascade off of the walls.  Stalagmites line the ceiling above a pool of water that dominates the majority of the walking space.  You see an exit across the pool of water, and you also see a smaller path that leads further underground.'
	};

	if( main.data.conscience.in_party == false ) then
		text[ #text + 1 ] = 'You hear a very feint voice, almost not there, calling out from a passageway across the pool.';
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

		c.dialogue( {
			'You have no idea how deep this pool is.  It could be too deep to wade through.'
		} );
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
			c.dialogue( {
				'You find a pebble and toss it into the pool.  Eerily, it does not make a splashing sound or any ripples.  Something seems very off about this "water".'
			}, true );
			goto pool_choice
		elseif( ind == 3 ) then
			if( utils.index_of( 'Dry Wood', main.data.inventory ) > 0 ) then
				c.dialogue( {
					'You dive into the pool holding firmly onto the plank of dry wood you had found before.  It floats up and takes you with it, allowing you to use your feet to kick your way across the water.  After a bit of time you are safely on the other bank.  You get out of the water sopping wet and continue onward.',
					'To your surprise, the passage out is marked with a thick, wooden door that does not have a handle.  Luckily it is unlocked and you can push it open, but it is so heavy that it takes a lot of strength to do so.  When you finally get through, the door slams shut behind you and astonishingly seems to morph into the wall.  All you see now is a large wall of rock. You suppose you have no way back.'  
				}, true );
				main.set_route( 'power-mountain/golem-temple/start' );
			else
				c.dialogue( {
					'You dive into the pool and realize that this was a mistake. The pool is very deep, and something is not quite right about the water.  You cannot float on it; the pool pulls you under even as you are only a few feet from the bank.  You kick hard but you are unable to get enough force to float up.  You slip deeper and deeper into the water until you fall through a waterfall and land painfully on the cave floor.  Gasping for air, you stand up.'  
				}, true );
				main.set_route( 'power-mountain/cave/underground-waterfall' );
			end
		end
	elseif( ind == 2 ) then
		main.set_route( 'power-mountain/cave/underground-atrium' );
	end

end
