local display = require( 'illuamination/display' );
local c = require( 'illuamination/common' );
local door = require( 'pics/door' );
local cave = require( 'pics/cave' );
local conscience = require( 'pics/conscience' );

local function with_conscience_in_party( main )
	local txt = require( 'routes/power-mountain/golem-temple/_left-fork-text' )();
	c.pic( door.door_closed() );

	c.dialogue( txt[ 1 ], true );

	c.dialogue( txt[ 2 ] );

	local choices = {
		[1] = 'Go back.',
		[2] = 'Did you try pushing it open?',
		[3] = 'Why isn\'t there any handle on this door?',
		[4] = 'Who put up all of these torches?'	
	};

	::beginning_of_sequence::

	local key, previous_choice = c.choose_keys( choices );
	c.setup( previous_choice );

	if( key == 1 ) then
		c.dialogue( txt[ 3 ], true );
		return main.set_route( 'power-mountain/golem-temple/choice-fork' );
	elseif( key == 2 ) then
		c.pic( conscience.unamused() );
		c.dialogue( txt[ 4 ], true );	
		c.dialogue( txt[ 5 ] );
		choices[ 2 ] = nil;	
		goto beginning_of_sequence;
	elseif( key == 3 ) then
		-- this is the correct choice
	elseif( key == 4 ) then
		c.pic( conscience.talking() );
		c.dialogue( txt[ 6 ], true );
		c.dialogue( txt[ 7 ] );
		choices[ 4 ] = nil;
		goto beginning_of_sequence;
	end

	c.pic( conscience.confused() );
	c.dialogue( txt[ 8 ], true );
	c.dialogue( txt[ 9 ], true );
	c.dialogue( txt[ 10 ] );

	local choices = {
		[1] = 'Nice try.',
		[2] = 'That was rather silly, don\'t you think?',
		[3] = 'Ha, what a stupid idea.'
	};
	local key, previous_choice = c.choose_keys( choices );
	c.setup( previous_choice );

	if( key == 1 ) then
		c.pic( conscience.determined() );
		c.modify_standing( 3, 'conscience', main );
		c.dialogue(txt[ 11 ], true );	
	elseif( key == 2 ) then
		c.pic( conscience.unamused() );
		c.dialogue( txt[ 12 ], true );		
	elseif( key == 3 ) then 
		c.pic( conscience.angry() );
		c.modify_standing( -3, 'conscience', main );
		c.dialogue( txt[ 13 ], true );	
	end

	c.dialogue( txt[ 14 ], true );

	c.setup();
	c.pic( cave.rockCreature() );
	c.dialogue( txt[ 15 ], true );

	c.dialogue( txt[ 16 ] );

	local choices = {
		[1] = '(Conscience, what is this thing?)',
		[2] = 'What the hell are you?',
		[3] = '...sorry about that.'
	};
	::rock_creature_enters::
	local key, previous_choice = c.choose_keys( choices );
	c.setup( previous_choice );

	if( key == 1 ) then
		c.dialogue( txt[ 17 ] );
		choices[1] = nil;
		goto rock_creature_enters;
	elseif( key == 2 ) then 
		c.setup();
		c.pic( cave.rockCreature() );
		c.dialogue( txt[ 18 ] );
		c.dialogue( txt[ 19 ] );
		choices[2] = nil;
		goto rock_creature_enters;
	elseif( key == 3 ) then 
		--continue onward
	end

	c.dialogue( txt[ 20 ], true );
	c.setup();
	c.pic( cave.rockCreature() );
	c.dialogue( txt[ 21 ], true );
	c.dialogue( txt[ 22 ], true );

	c.setup();
	c.pic( cave.rockCreature() );
	c.dialogue( txt[ 22 ], true );

	c.dialogue( txt[ 23 ], true );
	c.dialogue( txt[ 24 ], true );

	main.set_route( 'power-mountain/outside-temple-snowy' );
end

local function without_conscience_in_party( main )
	c.enable_trigger( 'saw_door_left_fork', main );

	local choices = {
		[1] = 'Go back.',
		[2] = 'Push the door open.',
		[3] = 'Kick the door open.'	
	};
	if( c.inventory_contains( 'Dry Wood', main ) ) then
		choices[ 4 ] = 'Throw the Dry Wood at the door.';
	end

	c.pic( door.door_closed() );

	c.dialogue( txt[ 25 ], true );
	c.dialogue( txt[ 26 ] );

	::beginning_of_sequence::

	local key, previous_choice = c.choose_keys( choices );
	c.setup( previous_choice );

	if( key == 1 ) then
		c.dialogue( txt[ 27 ], true );
		main.set_route( 'power-mountain/golem-temple/choice-fork' );
	elseif( key == 2 ) then
		c.dialogue( txt[ 28 ], true );
		choices[ 2 ] = nil;
		goto beginning_of_sequence;
	elseif( key == 3 ) then
		c.dialogue( txt[ 29 ], true );
		choices[ 3 ] = nil;
		goto beginning_of_sequence;
	elseif( key == 4 ) then
		c.dialogue( txt[ 30 ], true );
		choices[ 4 ] = nil;
		c.inventory_remove( 'Dry Wood', main );
		goto beginning_of_sequence;
	end
end

return function( main )
	c.setup();

	if( c.has_party_member( 'conscience', main ) ) then
		with_conscience_in_party( main );
	else
		without_conscience_in_party( main );
	end
end