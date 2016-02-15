local display = require( 'display' )

return {

wait_for_choice = function( numchoices )
	local choices = ''
	for i = 1, numchoices, 1 do
		choices = choices .. i
	end

	choices = choices .. '0' 

	local index = -1
	_, _, index = os.execute( 'CHOICE /C ' .. choices .. ' /N' )
	io.write( '\r' )
	return index
end,

wait_for_input = function()
	local ret = io.read()
	return ret
end,

wait_for_enter = function()
	display.draw_string( '\nPress enter to continue...\n' )
	io.read()
end

}
