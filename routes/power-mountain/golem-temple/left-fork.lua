local display = require( 'display' );
local c = require( 'common' );
local door = require( 'pics/door' );
local cave = require( 'pics/cave' );
local conscience = require( 'pics/conscience' );

local function with_conscience_in_party( main )
	c.pic( door.door_closed() );

	c.dialogue( {
		'You walk for a few minutes with Conscience happily skipping at your side.  She seems thrilled to have a traveling companion, and you have to admit you feel better not having to be alone anymore.  You eventually come upon a closed metal door that does not have a handle.'
	}, true );

	c.dialogue( {
		'CONSCIENCE: "This is the door I found!"',
		'She rushes over to it, but her excitement turns to dejection in the blink of an eye.',
		'CONSCIENCE: "But I still don\'t know how to get past it."',
		'You walk up next to her and survey the door for yourself.'
	} );

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
		c.dialogue( {
			'You decide that you cannot pass this door at the moment.'
		}, true );
		return main.set_route( 'power-mountain/golem-temple/choice-fork' );
	elseif( key == 2 ) then
		c.pic( conscience.unamused() );
		c.dialogue( {
			'CONSCIENCE: "Of course I tried that.  It\'s locked though, you can see for yourself."',
		}, true );	
		c.dialogue( {
			'You put some force on the door, which doesn\'t budge, and note that you probably could not push your way past it.'
		} );
		choices[ 2 ] = nil;	
		goto beginning_of_sequence;
	elseif( key == 3 ) then
		-- this is the correct choice
	elseif( key == 4 ) then
		c.pic( conscience.talking() );
		c.dialogue( {
			'CONSCIENCE: "I don\'t have the slightest clue who put them up or what keeps them lit."',
		}, true );
		c.dialogue( {
			'CONSCIENCE: "Like I said, I am just as lost in this place as you are."',
		} );
		choices[ 4 ] = nil;
		goto beginning_of_sequence;
	end

	c.pic( conscience.confused() );
	c.dialogue( {
		'CONSCIENCE: "I noticed that too.  Maybe you aren\'t supposed to open it with a handle?"',
	}, true );
	c.dialogue( {
		'She pauses a moment to consider the door, and then her face lights up.',
		'CONSCIENCE: "That must be it!  Maybe we just have to ask it?"',
		'Before you can stop her from undertaking such ridiculousness, Conscience has alread laid a hand on the outside of the door.',
		'CONSCIENCE: "Hello? Mr. Door? It would be super great if you could please open up for us?"'
	}, true );
	c.dialogue( {
		'The door doesn\'t do anything.  You don\'t want to admit it, but for a moment there you thought that it might have been that easy.'
	} );

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
		c.dialogue( {
			'CONSCIENCE: "Thanks, ' .. main.data.player_name .. '.  We\'ll get through eventually!"'
		}, true );	
	elseif( key == 2 ) then
		c.pic( conscience.unamused() );
		c.dialogue( {
			'CONSCIENCE: "If it had worked, I doubt you would be complaining about its silliness."'
		}, true );		
	elseif( key == 3 ) then 
		c.pic( conscience.angry() );
		c.modify_standing( -3, 'conscience', main );
		c.dialogue( {
			'CONSCIENCE: "I don\'t see *you* coming up with any good ideas!"'
		}, true );	
	end

	c.dialogue( {
		'At that moment the wall next to the door begins to move. It extrudes out steadily, the rocks grinding together with echoing crumbles.  You and Conscience are too surprised to move as you watch the wall slide out and then slowly come to a stop.  Then you notice that it is shaped vaugely humanoid: Something like a big, rocky head is lowering down to the both of you, two sockets with glowing gems and a mouth of cobbled together stones.  Whatever the thing is, it moves slowly and deliberately, gazing at the two of you for a long moment before speaking in a hoarse, but loud voice.',
	}, true );

	c.setup();
	c.pic( cave.rockCreature() );
	c.dialogue( {
		'ROCK CREATURE: "Why do you make such noise?  I require silence for my slumber.  It has been agreed."'
	}, true );

	c.dialogue( {
		'You are shocked for only a moment before you manage to regain your composure.  When you do, you find Conscience clutching your arm and standing behind you.'
	} );

	local choices = {
		[1] = '(Conscience, what is this thing?)',
		[2] = 'What the hell are you?',
		[3] = '...sorry about that.'
	};
	::rock_creature_enters::
	local key, previous_choice = c.choose_keys( choices );
	c.setup( previous_choice );

	if( key == 1 ) then
		c.dialogue( {
			'Conscience is too terrified to be of any assistance.  Her eyes are wide and her mouth trembles and she cannot seem to say a word.'
		} );
		choices[1] = nil;
		goto rock_creature_enters;
	elseif( key == 2 ) then 
		c.setup();
		c.pic( cave.rockCreature() );
		c.dialogue( {
			'The creature does not appear to understand your queston.',
			'ROCK CREATURE: "I am here.  I am always here.  It has been agreed."'
		} );
		choices[2] = nil;
		goto rock_creature_enters;
	elseif( key == 3 ) then 
		--continue onward
	end

	c.dialogue( {
		'The creature heaves a sigh, which involves much grinding of boulders and the sound of a wind that you do not feel.  It sends shivers down your spine nonetheless.',
	}, true );
	c.setup();
	c.pic( cave.rockCreature() );
	c.dialogue( {
		'ROCK CREATURE: "I am not to be disturbed.  It has been agreed."',
	}, true );
	c.dialogue( {
		'It moves its face right next to the both of you; Conscience\'s fingernails cut into your arm painfully.  However, the pose isn\'t threatening, but seems... considering.'
	}, true );

	c.setup();
	c.pic( cave.rockCreature() );
	c.dialogue( {
		'ROCK CREATURE: "Anger does not befit me.  You will leave this temple now.  You will not come back.  It has been agreed."'
	}, true );

	c.dialogue( {
		'It turns to the door that you and Conscience could not get past and with an effortless nudge, swings it open, slamming it against something on the other side.'
	}, true );
	c.dialogue( {
		'Without another word it swoops the two of you up in its other hand and ushers you out.  The door slams shut behind you, the metal ringing loudly, echoing all around.',
		'The light of the outside temporarily blinds you and you shield your eyes.  When they finally adjust to the sun...'
	}, true );

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

	c.dialogue( {
		'You walk for a few minutes past row after row of torches until you are forced to stop: the passage onward is marred by a large, metal door.  This door, like the previous one you saw, does not appear to have a handle.  It looms down on you as if daring you to touch it.',
	}, true );
	c.dialogue( {
		'You notice that the cave floor beneath your feet has turned into a cobblestone path.' 
	} );

	::beginning_of_sequence::

	local key, previous_choice = c.choose_keys( choices );
	c.setup( previous_choice );

	if( key == 1 ) then
		c.dialogue( {
			'You decide that you cannot pass this door at the moment.'
		}, true );
		main.set_route( 'power-mountain/golem-temple/choice-fork' );
	elseif( key == 2 ) then
		c.dialogue( {
			'At first you nudge the door and find that it is locked tight.  You then push harder and harder, but your feet slip on the rock beneath you.  It looks like you are\'t strong enough to push it open.'
		}, true );
		choices[ 2 ] = nil;
		goto beginning_of_sequence;
	elseif( key == 3 ) then
		c.dialogue( {
			'You kick the door and receive a throbbing pain in your toe, accomplishing little else.  The door remains as tightly shut as when you first saw it.'
		}, true );
		choices[ 3 ] = nil;
		goto beginning_of_sequence;
	elseif( key == 4 ) then
		c.dialogue( {
			'You chuck the plank of wood at the door.  It makes a loud "clank" and falls to the floor.',
			'You swear you hear a breif sound, like the grinding of rocks, but when you freeze and look around, you do not see anything.'
		}, true );
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