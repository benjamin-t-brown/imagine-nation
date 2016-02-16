display = {

clear = function()
	io.write( '♀' );
	io.flush();
	os.execute( 'cls' ); 
end,

para = function()
	io.write( '\n\n' );
	io.flush();
end,

ln = function()
	io.write( '\n' );
	io.flush();
end,

draw_title = function()
	display.draw_string( 'Powered by the ILUAmination Engine\n' );
end,

draw_string = function( str )
	io.write( str );
	io.flush();
end,

redraw_string = function( str )
	io.write( '\r' .. str );
	io.flush();
end,

draw_choices = function( choices )
	local final_string = ''
	local width = 50

	for i = 1, width, 1 do
		final_string = final_string .. '='
	end	

	final_string = final_string .. '\n'

	for i = 1, #choices, 1 do
		final_string = final_string .. tonumber(i) .. '.) ' .. choices[ i ] .. '\n'
	end

	for i = 1, width, 1 do
		final_string = final_string .. '='
	end

	final_string = final_string .. '\n'

	display.draw_string( final_string )	
end

}

return display
