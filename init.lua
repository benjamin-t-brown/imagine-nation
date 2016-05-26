local utils = require( 'illuamination/utils' );
local display = require( 'illuamination/display' );
local c = require( 'illuamination/common' );

require( 'illuamination/data' );
local input = require( 'illuamination/input' );

-- function Tile:new( pic )
-- 	local o = {
-- 		pic = pic
-- 	}
-- 	setmetatable(o, self)
-- 	self.__index = self
-- 	return o
-- end

local route = require( 'routes/menu' );
local route2 = nil;
local has_route = true;

if( arg[1] == '1' ) then
	input.set_input_mode( 1 );
end;

main = {

	set_route = function( route_name )
		if( route_name ) then
			main.data.route_name = route_name;
			route2 = require( 'routes/' .. route_name );
		else
			route2 = nil;
			has_route = false
		end
	end,

	data = require( 'illuamination/data' )( );

};

local save = require( 'illuamination/data' )( );
--save.conscience.in_party = true;
--save.conscience.standing = 11;
--table.insert( save.inventory, 1, 'Dry Wood' );
--save.route_name = 'power-mountain/outside-temple-snowy';
--save.route_name = 'power-mountain/cave/main-cave';
--c.load_save( save, main );

while has_route do
	if( route2 ~= nil ) then
		route = route2;
		route2 = nil;
	end
	route( main );
end

c.dialogue( {
	'PROGRAM OVER' ,
	'...Or is it?'
}, true );

