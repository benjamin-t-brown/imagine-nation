local display = require( '../display' );
local c = require( '../common' );
local utils = require( '../utils' );
local portalpic = require( '../pics/portal' );

WIDTH = 20;
HEIGHT = 20;

local function snake( w, h )
	local function rtl( n )
		local ret = '';
		for i = 1, w, 1 do 
			if i >= w - n then
				ret = ret .. '#';
			else
				ret = ret .. ' ';
			end
		end 
		return ret;
	end

	local function ltr( n )
		local ret = '';
		for i = 1, w, 1 do 
			if i <= n then
				ret = ret .. '#';
			else
				ret = ret .. ' ';
			end
		end 
		return ret;
	end

	for row = 1, h, 1 do
		for i = 1, w, 1 do
			if row % 2 == 0 then
				display.redraw_string( ltr( i ) );
			else 
				display.redraw_string( rtl( i ) );
			end
			utils.sleep( 0.005 );
		end
		display.draw_string( '\n' );
	end
end

local function portal( w, h )
	local function zero( n )
		local ret = '';
		for row = 1, h, 1 do
			for i = 1, w, 1 do
				if row == 1 + n or row == h - n or i == 1 + n or i == w - n or
					row == 1 or row == h or i == 1 or i == w then
					ret = ret .. '#';
				else 
					ret = ret .. ' ';
				end
			end
			ret = ret .. '\n';
		end
		return ret;
	end

	for i = 1, HEIGHT*3, 1 do
		display.clear();
		display.draw_string( zero( i % ( h ) - 1 ) );
		utils.sleep( 0.05 );
	end

end

return function( main )
	c.setup();

	c.dialogue( {
		'Something does not feel quite right.',
		'You had been dozing off, in the intermediate state between asleep and awake, but just now something has made you feel a bit strange.',
		'You slowly open your eyes, and to your alarm you discover that you are not in the same place you were when you first closed them.  In fact, you have no idea where you are.  You cannot remember anything.'
	}, true );

	c.setup();
	c.pic( portalpic.far() );
	c.dialogue( {
		'You stand on a large set of rolling plains, the sky above you is speckled with numerous stars that dimly light up the landscape.  At a point in the distance you see shimmering light.'
	}, true );

	c.dialogue( {
		'As you appear to have no other recourse, you begin to walk toward this light, although it seems very far away.  In fact, your steps do not appear to make a difference in how bright it becomes.  It still looms just as far away from when you first perceived it, even as you walk more and more.'
	}, true );

	c.dialogue( {
		'After some time you begin to doubt that you will ever reach the source of that light. You stop and look back into pitch black darkness.  It seems your only hope is to continue toward the point and perhaps, eventually, you will you reach it.'
	}, true );

	c.setup();
	c.pic( portalpic.close() );
	c.dialogue( {
		'When you turn forward again, you are shocked to see that the light has, somehow, gone from very far away to very close.'
	}, true );

	c.dialogue( {
		'You can see it clearly now.  The light comes from what looks like a doorway, but across the threshold is a thin material that seems to shimmer.  This is the source of the light.',
		'You find it difficult to look away from this gateway.  It is enthralling, but somehow it demands your attention.  You notice too late that something is pulling you into it, an invisible force, grabing at you and forcing you forward inch by inch.',
		'You try to resist, but your efforts are fruitless.  The force grows stronger and stronger and you begin to realize that you can do nothing to stop it.  It lifts you off of the air, and sucks you into the shimmering surface of the portal...' 
	}, true );

	portal( WIDTH, HEIGHT );
	c.setup();

	main.set_route( 'power-mountain/cave/start' );

end