local display = require( 'illuamination/display' )

local INPUT_MODE = 0;

local exp = {};
local _tmp = {

set_input_mode = function( n )
	INPUT_MODE = n;
	display.set_input_mode( n );
end,

wait_for_choice = function( numchoices )
	if( INPUT_MODE == 0 ) then
		local choices = ''
		for i = 1, numchoices, 1 do
			choices = choices .. i
		end

		choices = choices .. '0' 

		local index = -1
		_, _, index = os.execute( 'CHOICE /C ' .. choices .. ' /N' )
		io.write( '\r' )
		return index
	else
		local _is_valid_choice = function( c )
			local choices = ''
			for i = 1, numchoices, 1 do
				if(  tostring( i ) == c ) then
					return true;
				end
			end
			return false;
		end;
		local ret = exp.wait_for_input();
		while _is_valid_choice( ret ) == false do
			ret = exp.wait_for_input();
		end;
		return tonumber( ret );
	end
end,

wait_for_input = function()
	local ret = io.read();
	if( ret == 'exit' ) then
		os.exit();
	end;
	return ret;
end,

wait_for_enter = function()
	display.draw_string( '\nPress enter to continue...\n' )
	exp.wait_for_input();
end

};

exp = _tmp;

return exp;
