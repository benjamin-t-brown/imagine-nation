local display = require( 'display' );
local c = require( 'common' );
local cave = require( 'pics/cave' );
local conscience = require( 'pics/conscience' );

return function( main )
	c.setup();
	c.pic( cave.outside() );
	c.dialogue( {''}, true );
	c.dialogue( { 
		'You find yourself standing in a valley of gigantic mountains, each peak you look at is taller than the last.  A stone stairway, ripened with age, leads further down the mountainside before disappearing into thick pine forest. Light snowflakes tap your nose as they fall lazily to the ground, but they do not stick, instead vanishing on impact.  It is a tad bit chilly and you are uncomfortably aware that you have no jacket.',
		'The door behind you, even though you just saw it open, now looks like it shall be shut for a very long time.'
	}, true );

	if( c.get_standing( 'conscience', main ) > 10 ) then
		c.dialogue( { 
			'The sunlight makes Conscience finally come to her senses.  She stops clutching your arm and takes a step away from you.  She glances at your face and when she sees your eyes, she looks away hurridly.'
		}, true );
		c.setup();
		c.pic( conscience.bashful() );
		c.dialogue( { 
			'CONSCIENCE: "I\'m sorry for breaking down in there. I was very freightened."'
		}, true );
		c.dialogue( { 
			'CONSCIENCE: "I appreciate that you at least kept your head."'
		} );
	else
		c.dialogue( { 
			'The sunlight makes Conscience finally come to her senses.  She immediately lets go of your arm and flinches back.'
		}, true );
		c.setup();
		c.pic( conscience.talking2() );
		c.dialogue( { 
			'CONSCIENCE: "Well... That was not very fun."'
		} );
	end

	local ind, previous_choice = c.choose( {
		'Are you okay?',
		'You were pretty useless...',
		'Let\'s just move on.'
	} );
	c.setup();

	if( ind == 1 ) then
		c.pic( conscience.kinda_happy() );
		c.modify_standing( 3, 'conscience', main );
		c.dialogue( { 
			'CONSCIENCE: "Yes, I\'m alright.  Thanks for asking."'
		}, true );
	elseif( ind == 2 ) then
		c.pic( conscience.unamused() );
		c.modify_standing( -1, 'conscience', main );
		c.dialogue( { 
			'CONSCIENCE: "Yes well... I apologize for that.  But you have to admit that creature was rather terrifying."'
		}, true );
	elseif ( ind == 3 ) then
		--continue forward
	end

	c.dialogue( {
		'Conscience takes a look at your surroundings for the first time.  Her eyes widening at the scope of the mountain range around the both of you.'
	}, true );
	c.setup();
	c.pic( conscience.worried() );
	c.dialogue( {
		'CONSCIENCE: "I still don\'t know where we are."'
	}, true );
	c.dialogue( {
		'Then she spots something that you did not.  She indicates a sign post erected at the point where the stairway flattens out to the dais you stand upon now.',
		'CONSICNECE: "What\'s that?"',
		'You both hustle over to it.'
	}, true );
	c.dialogue( {
		'It\'s an old, wooden sign that looks to have been well-polished at one point, but now is rotting, and barely legible.',
		'It reads: "THE TEMPLE OF POWER"',
		'You have no idea what that means, but you turn to Consicence and see that the blood has drained from her face.'
	}, true );

	c.pic( conscience.scared() );
	c.dialogue( {
		'CONSCIENCE: "This is..."'
	}, true );
	c.dialogue( {
		'She tries to speak, but the words dont\'t come out in anything you can understand.  She is too terrified.  It takes several minutes before she is able to calm down.',
	}, true );
	c.dialogue( {
		'CONSCIENCE: "This is the Temple of Power!?"'
	} );

	local ind, previous_choice = c.choose( {
		'What is that?',
		'What\'s so scary about this place?'
	} );
	c.setup( previous_choice );
	c.pic( conscience.surprised() );
	c.dialogue( { 
		'CONSCIENCE: "You don\'t know what this means?"'
	}, true );
	c.dialogue({
		'CONSCIENCE: "It\'s OFF LIMITS.  We aren\'t supposed to be here!  If somebody found out that we\'d been snooping around the Temple of Power, we would be in so much trouble!',
		'She shivers at the thought.',
	} );

	local choices =  {
		[1] = 'Trouble?  From whom?',
		[2] = 'I still don\'t understand what this place is.',
		--[3] this choice is added at the end of key 2
	};
	::trouble_choice::
	local key, previous_choice = c.choose_keys( choices );
	c.setup( previous_choice );

	if( key == 1 ) then
		c.pic( conscience.talking2() );
		c.dialogue( { 
			'CONSCIENCE: "Anybody!  Logos would be furious, and Amber would be disappointed...'
		}, true );
		c.dialogue( { 
			'Then something else occurs to her and she squeaks.',
			'CONSCIENCE: "And if Venom found out...  I don\'t know if I want to think about that."'
		});

		local ind2, previous_choice = c.choose( {
			'I don\'t even know who any of those people are.',
			'Sounds like a pretty strict bunch.',
			'Are they your friends or something?'
		} );
		c.setup( previous_choice );

		if( ind2 == 1 ) then
			c.pic( conscience.talking() );
			c.dialogue( { 
				'CONSCIENCE: "Well, I think you might like Logos, he\'s very terse and to the point..."',
			}, true );
			c.dialogue( {
				'She pauses and blinks.'
			});
		elseif( ind2 == 2 ) then
			c.pic( conscience.worried() );
			c.dialogue( { 
				'CONSCIENCE: "Yes.  Very strict.  Sometimes I feel too much so..."',
			}, true );
			c.dialogue( {
				'Her brow is furrowed and she is temporarily lost in thought, but after only a moment she has regained herself.'
			});
		elseif( ind2 == 3 ) then
			c.pic( conscience.unamused() );
			c.dialogue( { 
				'CONSCIENCE: "Well, \'friends\' is not really the right term.  More like, \'caretakers\'."'
			}, true );
		end;

		c.dialogue( { 
			'CONSCIENCE: "But we don\'t have time to talk about them now!  You can meet them later.  That is, if we manage to get out of this place unseen."'
		} );

		choices[ 1 ] = nil;

		goto trouble_choice;	
	elseif( key == 2 ) then
		c.pic( conscience.worried() );
		c.dialogue( { 
			'CONSCIENCE: "It\'s just... A place that is important to the world."'
		}, true );
		c.dialogue( { 
			'CONSCIENCE: "Nobody has really told me how, but the Temple of Power is what makes this world keep living, and it would be easy to accidently mess something up here. Then a whole lot of stuff could go wrong.  So, everybody says that nobody should come here, ever.  That way, nothing accidental happens.  Nothing bad happens."'
		}, true );
		c.dialogue( { 
			'You look up at the mountains around you, and the door you just came from, wondering what could be in this place, this Temple of Power, that people would be afraid of disturbing.  Perhaps that ugly rock monster had something to do with it.'
		} );
		choices[ 2 ] = nil;
		choices[ 3 ] = 'So then, let\'s get out of here.'
		goto trouble_choice;
	elseif( key == 3 ) then
		--continue
	end

	c.pic( conscience.normal() );
	c.dialogue( { 
		'CONSCIENCE: "Yes. Let\'s go."'
	}, true );
	c.dialogue( { 
		'CONSCIENCE: "I just hope that nobody sees us leaving."'
	}, true );

	main.set_route( nil );
end
