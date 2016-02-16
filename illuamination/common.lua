local display = require( 'illuamination/display' );
local utils = require( 'illuamination/utils' );
local input = require( 'illuamination/input' );
--http://asciiflow.com/
-- Dumb way I'm using to call functions in this file from this file
local ret = {};
local _tmp = {

load_save = function( save, main )
	main.data = save;
	main.set_route( main.data.route_name );
end,

setup = function( previous_choice )
	display.clear();

	if( previous_choice ) then
		display.draw_string( 'Previous Choice: ' .. previous_choice );
		display.ln();
	else 
		display.draw_title();
	end
	display.ln();
end,

pic = function( pic )
	display.draw_string( pic );
	display.ln();
end,

dialogue = function( lines, wait )
	for i = 1, #lines, 1 do
		display.draw_string( lines[ i ] );
		display.para();
	end

	if wait then
		input.wait_for_enter();
	end
end,

choose = function( choices, dont_draw )
	if( dont_draw == nil or dont_draw == false ) then
		display.draw_choices( choices );
	end

	local ch = input.wait_for_choice( #choices );
	if( ch == #choices + 1 ) then
		utils.print_r( main.data );
		return ret.choose( choices, true );
	else 
		return ch, choices[ ch ];
	end
end,

choose_keys = function( keyed_choices, dont_draw )
	local choices = {};
	local keys = {};
	for key, choice in next, keyed_choices, nil do
		if( choice ) then
			choices[ #choices + 1 ] = choice;
			keys[ #keys + 1 ] = key;
		end
	end

	local ind, previous_choice = ret.choose( choices, dont_draw );
	return keys[ ind ], previous_choice
end,

inventory_contains = function( item, main )
	return utils.index_of( item, main.data.inventory ) ~= 0;
end,

inventory_add = function( item, main )
	table.insert( main.data.inventory, 1, item );
	ret.dialogue( { 'You acquired: ' .. item }, true ); 
end,

inventory_remove = function( item, main )
	local ind = utils.index_of( item, main.data.inventory );
	if( ind > 0 ) then
		table.remove( main.data.inventory, ind );
		ret.dialogue( { 'You lost: ' .. item } );
	end
end,

is_trigger = function( trigger_name, main )
	if main.data.triggers[ trigger_name ] == nil then
		return true;
	else
		return main.data.triggers[ trigger_name ];
	end
end,

disable_trigger = function( trigger_name, main )
	main.data.triggers[ trigger_name ] = false;
end,

enable_trigger = function( trigger_name, main )
	main.data.triggers[ trigger_name ] = true;
end,

modify_standing = function( amount, character_name, main )
	local stramt = tonumber( amount );
	main.data[ character_name ].standing = main.data[ character_name ].standing + amount;
	if( amount >= 3 ) then
		ret.dialogue( { '!! Gained standing with ' .. string.upper( character_name ) .. '. (' .. stramt .. ') !!' } );
	elseif( amount <= -3 )  then
		ret.dialogue( { '!! Lost standing with ' .. string.upper( character_name ) .. '. (' .. stramt .. ') !!' } );
	end
end,

get_standing = function( character_name, main )
	return main.data[ character_name ].standing;
end;

has_party_member = function( character_name, main )
	return main.data[ character_name ].in_party;
end,

add_party_member = function( character_name, main )
	main.data[ character_name ].in_party = true;
	ret.dialogue( {
		string.upper( character_name ) .. ' has joined the party.'
	}, true );
end,

remove_party_member = function( character_name, main )
	main.data[ character_name ].in_party = false;
	ret.dialogue( {
		string.upper( character_name ) .. ' has left the party.'
	}, true );
end
};

ret = _tmp;

return ret;
