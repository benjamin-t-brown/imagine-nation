local conscience = require( '../pics/conscience' )
local c = require( '../common' )

return function( main )
	c.setup( nil )

	c.dialogue( {
		'CONSCIENCE: "So what should we do next?"'
	} );

	local ind, previous_choice = c.choose( {
		'Continue on.',
		'Eat pizza.',
		'Wallow in misery.'
	} )
	if ind == 1 then
		c.setup( previous_choice )
		c.dialogue( {
			'CONSCIENCE: "That seems like a reasonable course of action!"'
		}, true );

		c.setup( previous_choice )
		c.dialogue( {
			'CONSCIENCE: "Let\'s go!"'
		}, true )

		main.set_route( nil )
	elseif ind == 2 then
		c.setup( previous_choice )
		c.dialogue( {
			'CONSCIENCE: "Eat pizza? What a bizarre thing to say...'
		}, true );
		c.setup( previous_choice )
		c.dialogue( {
			'CONSCIENCE: "I mean, I don\'t have any pizza."'
		}, true );
		c.setup( previous_choice )
		c.dialogue( {
			'CONSCIENCE: "Do you have any pizza?"'
		} );

		local ind, previous_choice = c.choose( {
			'Yes.',
			'No.'
		} )

		if ind == 1 then
			c.setup( previous_choice )
			c.dialogue( {
				'CONSCIENCE: "No you don\'t"',
				'"You\'re a bad liar."'
			}, true );
		elseif ind == 2 then
			c.setup( previous_choice )
			c.dialogue( {
				'CONSCIENCE: "So then why did you even mention it???"',
			}, true );
		end

		c.dialogue( {
			'Conscience sighs.',
			'CONSCIENCE: "Let\'s try this again, shall we?"'
		}, true );
	elseif ind == 3 then
		c.setup( previous_choice )
		c.dialogue( {
			'CONSCIENCE: "Ha ha ha very funny."',
			'"If you were truly that despicible I would have left you alone a while ago."'
		}, true );

		c.dialogue( {
			'Conscience sighs.',
			'CONSCIENCE: "Let\'s try this again, shall we?"'
		}, true );
	end
end
