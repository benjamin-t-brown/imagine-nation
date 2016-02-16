local display = require( 'illuamination/display' );
local c = require( 'illuamination/common' );
local conscience = require( 'pics/conscience' );

local function with_conscience_in_party( main )
	c.dialogue( {
		'You stand in the cave where you first found Conscience.  She gives you a confused look.',
		'CONSCIENCE: "Why are we back in this place?  I told you to go to the left!"  She looks warily at the crumbled wall of rocks ahead.'
	} );
	local ind, previous_choice = c.choose( {
		'Go back.'
	} );
	main.set_route( 'power-mountain/golem-temple/choice-fork' );
end

local function without_conscience_in_party( main )
	c.dialogue( {
		'As you make your way down the passage, you stumble and kick a rock that goes clattering ahead of you.',
		'VOICE: "Is someone there?"',
		'The voice comes from just further down the passage and around a corner.  It sounds like a little girl.  She seems desperate.  You freeze and consider what to do.'
	} );
	local ind, previous_choice = c.choose( {
		'Go back, it is simply not worth taking chances in a place like this.',
		'Respond to the girl\'s voice.'
	} );
	c.setup( previous_choice );

	local choices = {
		'What are you doing down here?',
		'Are you stuck?'
	};
	if( ind == 1 ) then
		c.modify_standing( -1, 'conscience', main );
		c.dialogue( {
			'You turn around and begin to sneak back the way you came, trying not to make a sound.',
			'VOICE: "I definately heard something, so you better come out and show yourself!"',
			'Out from behind you, a small rock comes flying through the air and hits you squarely in the back of the head.  It hurts a lot, and you rub it furiously.  At this point your emotions take over, and you go stomping back in the direction of the thrown rock.'
		}, true );

		c.dialogue( {
			'You come around a corner in the passage and immediately spot the culprit: a young girl is laying on her back on the floor of the cave, but she appears to be stuck beneath a large rock. When she spots you, her face is half relief and half anger.',
			'GIRL: "Why didn\'t you respond to me before!  Are you afraid of a little girl or something?"'
		} );

		choices[ #choices + 1 ] = 'That rock really hurt you know!';
	elseif( ind == 2 ) then
		c.modify_standing( 2, 'conscience', main );
		c.dialogue( {
			'You shout down the passage and run around the corner.  Immediately you spot the owner of the voice: a young girl is laying on her back on the floor of the cave, but she appears to be stuck beneath a large rock. When she spots you, her face is full of relief.',
			'GIRL: "Thank goodness!  Somebody came."'
		} );
	end

	::conversation_beginning::

	local ind, previous_choice = c.choose( choices );
	c.setup( previous_choice );

	if( ind == 1 or ind == 2 ) then
		c.modify_standing( -1, 'conscience', main ); -- she notices you aren't very stronk
		c.dialogue( {
			'The girl struggles to move, but clearly cannot even budge an inch.  Annoyed, she slumps back and looks up at you.',
			'GIRL: "Could you just help me lift this rock?  Then I can talk to you."',
			'You go over to the girl and try to lift the rock that is pinning her to the floor, but it is much too heavy and you collapse on the ground out of effort.',
			'GIRL: "You aren\'t very strong are you?"',
			'You choose to ignore her candid comment.'
		} );
	elseif( ind == 3 ) then
		c.modify_standing( -1, 'conscience', main );
		c.dialogue( {
			'The girl gives you a very irritated look.',
			'GIRL: "Well I don\'t feel like being stuck down here for all of eternity, and I\'m not gonna let some idiot who is a afraid of little girls extend my stay."',
			'You stare at her angirly and she blushes.',
			'GIRL: "I\'m... I\'m sorry. But you really should have responded.  I won\'t hurt you I promise.'
		} );
		choices[ #choices ] = nil;
		goto conversation_beginning;
	end

	local ind, previous_choice = c.choose( {
		'We have to do it together.  On three, okay?'
	} );
	c.setup( previous_choice );
	c.dialogue( { 
		'The girl agrees, and when you count to three, the two of you manage to lift the rock just enough for her to skitter out of the hole. You drop the rock noisily to the floor when she is safely out of the crevice.',
		'The girl sighs in relief.',
		'GIRL: "Thank you, I was beginning to think I would never get out."'
	}, true );

	c.setup();
	c.pic( conscience.happy() );
	c.dialogue( { 
		'She looks up at you with big eyes and a smile.',
		'GIRL: "My name is Conscience, what\'s yours?"'
	}, true );

	c.dialogue( { 
		'You pause to decide how to respond.'
	} );

	local choices = {
		'It\'s a pleasure to meet you, Conscience, my name is ' .. main.data.player_name .. '.',
		'Call me ' .. main.data.player_name .. '.',
		'Conscience?  That\'s a weird name.'
	};

	::conversation_ask_for_name:: 

	local ind, previous_choice = c.choose( choices );
	c.setup( previous_choice );
	if( ind == 1 ) then
		c.modify_standing( 3, 'conscience', main );
		c.pic( conscience.happy() );
		c.dialogue( { 
			'CONSCIENCE: "Such wonderful manners!  I believe you and I will get along nicely."'
		}, true );		
	elseif( ind == 2 ) then
		c.pic( conscience.normal() );
		c.dialogue( { 
			'CONSCIENCE: "Is that your real name, or some kind of weird alias?"',
		}, true );
		c.dialogue( {
			'She shakes her head.',
			'CONSCIENCE: "Nevermind, I don\'t really want to know.'
	    }, true );
	elseif( ind == 3 ) then
		c.modify_standing( -1, 'conscience', main );
		c.pic( conscience.unamused() );
		c.dialogue( { 
			'CONSCIENCE: "Let\'s hear your name before any rash judgements are made."'
		} );
		choices[ #choices ] = nil;
		goto conversation_ask_for_name;
	end

	c.setup();
	c.pic( conscience.talking() );
	c.dialogue( {
		'CONSCIENCE: "So I suppose you\'re wondering how I got myself stuck."',
		'She says this rather matter-of-factly.',
	}, true );

	c.dialogue( {
		'CONSCIENCE: "Well if you must know, I am not certain where I am.  I think I got lost and ended up in this cave somehow.  When I was trying to figure out how to get out, I came across this door that I couldn\'t get past and so I was looking for a way around it when I crawled into that space and got stuck."',
		'Her words speed up as she finishes and she blushes furiously.'
	} );

	local choices = {		
		'Actually, I\'m not certain where I am either...',
		'Wow you\'re kind of clumsy.'
	};

	if( c.is_trigger( 'saw_door_left_fork', main ) ) then
		choices[ #choices + 1 ] = 'I saw a door in another place that was locked.';
	end

	local ind, previous_choice = c.choose( choices );
	c.setup( previous_choice );

	if( ind == 3 ) then
		c.pic( conscience.talking() );
		c.dialogue( {
			'CONSCIENCE: "Well it may be the same door.  It was pretty close to here; but where did you see it?"'
		}, true );
		c.setup( previous_choice );	
	end

	if( ind == 2 ) then
		c.modify_standing( -3, 'conscience', main );
		c.pic( conscience.angry() );
		c.dialogue( {
			'CONSCIENCE: "Hey now, I was terrified.  I have never been in a stranger place than this.  I don\'t even know how I got here!"',
		}, true );

		c.dialogue( { 'She looks on the verge of tears.' } );

		local ind, previous_choice = c.choose( {
			'Actually, I\'m not certain where I am either...',
		} );
		c.setup( previous_choice );
	end

	c.dialogue( { 
		'You tell her about getting sucked into the portal and how you got past the cavern with the pool.'
	}, true );
	c.pic( conscience.scared() );
	c.dialogue( {
		'CONSCIENCE: "Wow that\'s pretty intense.  But I suppose in a place like this, anything is possible."',
	}, true );
	c.dialogue( {
		'She appears to believe your story, at least for the time being, but she is also utterly unphased by it.  Maybe where she comes from, this kind of thing happens often.'
	}, true );

	c.setup();
	c.pic( conscience.talking() );
	c.dialogue( {
		'CONSCIENCE: "Well then, it seems to me that we both have the same problem: we are both lost."'
	}, true );
	c.dialogue( {
		'CONSCIENCE: "So whether you like it or not, you\'re coming with me, and we are both going to figure a way out of here."',
		'Without warning, she grabs your wrist and pulls you in the opposite direction.  You stumble after her, having been unprepared for her gusto.'
	}, true );

	c.add_party_member( 'conscience', main );
	main.set_route( 'power-mountain/golem-temple/choice-fork' );
end

return function( main )
	c.setup();

	if( c.has_party_member( 'conscience', main ) ) then
		with_conscience_in_party( main );
	else
		without_conscience_in_party( main );
	end
end
