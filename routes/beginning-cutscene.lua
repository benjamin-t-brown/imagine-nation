local display = require( 'display' );
local c = require( 'common' );
local utils = require( 'utils' );
local portalpic = require( 'pics/portal' );
local txt = require( 'routes/_beginning-cutscene-text' )();

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

	c.dialogue( txt[ 1 ], true );

	c.setup();
	c.pic( portalpic.far() );
	c.dialogue( txt[ 2 ], true );
	c.dialogue( txt[ 3 ], true );
	c.dialogue( txt[ 4 ], true );
	c.setup();
	c.pic( portalpic.close() );
	c.dialogue( txt[ 5 ], true );
	c.dialogue( txt[ 6 ], true );

	portal( WIDTH, HEIGHT );
	c.setup();

	main.set_route( 'power-mountain/cave/start' );

end