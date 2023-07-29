-- KawaiiCraft Game mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into doc/lua_api.txt

-- Definitions made by this mod that other mods can use too
local Cesc = minetest.get_color_escape_sequence
default = {
	colors = {
		grey = Cesc("#9d9d9d"),
		green = Cesc("#1eff00"),
		gold = Cesc("#ffdf00"),
		white = Cesc("#ffffff"),
		emerald = Cesc("#00e87e"),
		ruby = Cesc("#d80a1b")
	}
}

minetest.register_craftitem("default:cell", {
	inventory_image = "formspec_cell.png"
})

default.gui_bg = "bgcolor[#08080880;true]"
default.listcolors = "listcolors[#9990;#FFF7;#FFF0;#160816;#D4D2FF]"
default.gui = "size[9,8.75]" ..
	default.gui_bg ..
	default.listcolors ..
	"background[0,0;0,0;formspec_backround.png;true]" ..
	"background[0,0;0,0;formspec_inventory_alt.png;true]" ..
	"image_button_exit[8.55,-0.25;0.75,0.75;blank.png;exit;;true;false;blank.png]" ..
	"list[current_player;main;0.01,4.51;9,3;9]" ..
	"list[current_player;main;0.01,7.75;9,1;]"

-- Load files
local default_path = minetest.get_modpath("default")

dofile(default_path .. "/functions.lua")
dofile(default_path .. "/trees.lua")
dofile(default_path .. "/nodes.lua")
dofile(default_path .. "/chests.lua")
dofile(default_path .. "/furnace.lua")
dofile(default_path .. "/torch.lua")
dofile(default_path .. "/tools.lua")
dofile(default_path .. "/craftitems.lua")
dofile(default_path .. "/crafting.lua")
dofile(default_path .. "/mapgen.lua")

