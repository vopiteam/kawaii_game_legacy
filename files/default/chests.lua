local neighbor = {
	[0] = {{x =  1, z =  0}, {x = -1, z =  0}},
	[1] = {{x =  0, z = -1}, {x =  0, z =  1}},
	[2] = {{x = -1, z =  0}, {x =  1, z =  0}},
	[3] = {{x =  0, z =  1}, {x =  0, z = -1}}
}

-- Chests formspecs
local chest_cells = ""
local large_chest_cells = ""
for x = 1, 9 do
for y = 1, 6 do
	if y < 4 then
		chest_cells = chest_cells ..
			"item_image[" .. x - 1 .. "," .. y - 0.15 .. ";1,1;default:cell]"
	end
	large_chest_cells = large_chest_cells ..
		"item_image[" .. x - 1 .. "," .. y - 0.15 .. ";1,1;default:cell]"
end
end

local chest_formspec = default.gui ..
	"image[-0.23,-0.26;9,1;small_chest_header.png]" ..
	"image[7.95,3.1;1.1,1.1;^[colorize:#ffafca]]" ..
	chest_cells ..
	"list[current_name;main;0,0.85;9,3;]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]"

local large_chest_formspec = "size[9,11.6]" ..
	"bgcolor[#08080880;true]" ..
	default.listcolors ..
	"background[-0.2,-0.35;9.42,12.46;formspec_chest_large.png]" ..
	"background[-0.19,2.68;9.4,9.43;formspec_inventory_alt.png]" ..
	"image_button_exit[8.4,-0.2;0.75,0.75;blank.png;exit;;true;false;blank.png]" ..
	"image[7.95,6;1.1,1.1;^[colorize:#ffafca]]" ..
	large_chest_cells ..
	"list[current_player;main;0.01,7.4;9,3;9]" ..
	"list[current_player;main;0.01,10.62;9,1;]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]"

local function set_large_chest(pos_l, pos_r)
	local meta_l = minetest.get_meta(pos_l)
	local meta_r = minetest.get_meta(pos_r)

	local chest_l = pos_r.x .. "," .. pos_r.y .. "," .. pos_r.z
	local formspec_l = large_chest_formspec ..
		"list[nodemeta:" .. chest_l .. ";main;0.01,3.85;9,3;]" ..
		"list[current_name;main;0.01,0.85;9,3;]" ..
		"listring[nodemeta:" .. chest_l .. ";main]"
	local chest_r = pos_l.x .. "," .. pos_l.y .. "," .. pos_l.z
	local formspec_r = large_chest_formspec ..
		"list[nodemeta:" .. chest_r .. ";main;0.01,0.85;9,3;]" ..
		"list[current_name;main;0.01,3.85;9,3;]" ..
		"listring[nodemeta:" .. chest_r .. ";main]"
	meta_l:set_string("formspec", formspec_l)
	meta_r:set_string("formspec", formspec_r)

	local infotext = Sl("Large Chest")
	meta_l:set_string("infotext", infotext)
	meta_r:set_string("infotext", infotext)
end

local function on_construct(pos)
	local param2 = minetest.get_node(pos).param2
	local meta = minetest.get_meta(pos)
	local pos1 = {x = pos.x + neighbor[param2][1].x, y = pos.y, z = pos.z + neighbor[param2][1].z}
	local pos2 = {x = pos.x + neighbor[param2][2].x, y = pos.y, z = pos.z + neighbor[param2][2].z}

	if minetest.get_node(pos1).name == "default:chest" then
		minetest.set_node(pos, {name="default:chest_left", param2 = param2})
		minetest.swap_node(pos1, {name = "default:chest_right", param2 = param2})
		set_large_chest(pos, pos1)
	elseif minetest.get_node(pos2).name == "default:chest" then
		minetest.set_node(pos, {name = "default:chest_right", param2 = param2})
		minetest.swap_node(pos2, {name = "default:chest_left", param2 = param2})
		set_large_chest(pos2, pos)
	else
		meta:set_string("formspec", chest_formspec)
		meta:set_string("infotext", Sl("Chest"))
		meta:set_string("version", "2")
	end

	meta:get_inventory():set_size("main", 9*3)
end

local function on_rightclick(pos)
	minetest.sound_play("default_chest_open", {gain = 0.3,
		pos = pos, max_hear_distance = 10})
end

local function on_receive_fields(pos, _, fields)
	if fields.quit then
		minetest.sound_play("default_chest_close", {gain = 0.3,
			pos = pos, max_hear_distance = 10})
	end
end

local function allow_take_put(pos, _, _, stack, player)
	if minetest.is_protected(pos, player and player:get_player_name() or "") then
		return 0
	end
	return stack:get_count()
end

local function on_destruct(pos, large)
	local inv = minetest.get_meta(pos):get_inventory()
	if inv and not inv:is_empty("main") then
		local stack
		for i = 1, inv:get_size("main") do
			stack = inv:get_stack("main", i)
			if stack:get_count() > 0 then
				minetest.item_drop(stack, nil, pos)
			end
		end
	end

	if large then
		local right = large == "right" and true
		local param2 = minetest.get_node(pos).param2
		local neighbor_pos = neighbor[param2][right and 2 or 1]
		local pos2 =
			{x = pos.x + neighbor_pos.x, y = pos.y, z = pos.z + neighbor_pos.z}
		local name = minetest.get_node(pos2).name

		if (right and name == "default:chest_left")
				or name == "default:chest_right" then
			local meta = minetest.get_meta(pos2)
			meta:set_string("formspec", chest_formspec)
			meta:set_string("infotext", Sl("Chest"))
			minetest.swap_node(pos2, {name = "default:chest", param2 = param2})
		end
	end
end

local def = {
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	drop = "default:chest",
	sounds = default.node_sound_wood_defaults(),
	on_rightclick = on_rightclick,
	on_receive_fields = on_receive_fields,
	allow_metadata_inventory_put = allow_take_put,
	allow_metadata_inventory_take = allow_take_put
}

local tcopy = table.copy
local def_chest = tcopy(def)
def_chest.tiles = {
	"default_chest_top.png", "default_chest_top.png", "default_chest_side.png",
	"default_chest_side.png", "default_chest_side.png", "default_chest_front.png"
}
def_chest.description = "Chest"
def_chest.on_construct = on_construct
def_chest.on_destruct = on_destruct
minetest.register_node("default:chest", def_chest)

local def_chest_left = tcopy(def)
def_chest_left.tiles = {
	"default_chest_top_big.png", "default_chest_top_big.png", "default_chest_side.png",
	"default_chest_side.png", "default_chest_side_big.png^[transformFX", "default_chest_front_big.png"
}
def_chest_left.groups.not_in_creative_inventory = 1
def_chest_left.on_destruct =  function(pos) on_destruct(pos, "left") end
minetest.register_node("default:chest_left", def_chest_left)

local def_chest_right = tcopy(def)
def_chest_right.tiles = {
	"default_chest_top_big.png^[transformFX", "default_chest_top_big.png^[transformFX", "default_chest_side.png",
	"default_chest_side.png", "default_chest_side_big.png", "default_chest_front_big.png^[transformFX"
}
def_chest_right.groups.not_in_creative_inventory = 1
def_chest_right.on_destruct = function(pos) on_destruct(pos, "right") end
minetest.register_node("default:chest_right", def_chest_right)

local w = "group:wood"
minetest.register_craft({
	output = "default:chest",
	recipe = {
		{w,  w, w},
		{w, "", w},
		{w,  w, w}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:chest",
	burntime = 15
})

-- LBM for updating Chest
minetest.register_lbm({
	label = "Chest updater",
	name = "default:chest_updater_v4",
	nodenames = "default:chest",
	action = function(pos)
		local meta = minetest.get_meta(pos)
		if meta:get_string("version") ~= "4" then
			meta:set_string("formspec", chest_formspec)
			meta:set_string("version", "4")
		end
	end
})

minetest.register_lbm({
	label = "Chest updater (large)",
	name = "default:chest_large_updater_v4",
	nodenames = {"default:chest_left", "default:chest_right"},
	action = function(pos, node)
		local meta = minetest.get_meta(pos)
		if meta:get_string("version") ~= "4" then
			local param2 = minetest.get_node(pos).param2

			if node.name == "default:chest_left" then
				local pos_r = {x = pos.x + neighbor[param2][1].x, y = pos.y, z = pos.z + neighbor[param2][1].z}
				local chest_l = pos_r.x .. "," .. pos_r.y .. "," .. pos_r.z

				local formspec_l = large_chest_formspec ..
					"list[nodemeta:" .. chest_l .. ";main;0.01,3.85;9,3;]" ..
					"list[current_name;main;0.01,0.85;9,3;]" ..
					"listring[nodemeta:" .. chest_l .. ";main]"
				meta:set_string("formspec", formspec_l)
			elseif node.name == "default:chest_right" then
				local pos_l = {x = pos.x + neighbor[param2][2].x, y = pos.y, z = pos.z + neighbor[param2][2].z}
				local chest_r = pos_l.x .. "," .. pos_l.y .. "," .. pos_l.z

				local formspec_r = large_chest_formspec ..
					"list[nodemeta:" .. chest_r .. ";main;0.01,0.85;9,3;]" ..
					"list[current_name;main;0.01,3.85;9,3;]" ..
					"listring[nodemeta:" .. chest_r .. ";main]"
				meta:set_string("formspec", formspec_r)
			end

			meta:set_string("version", "4")
		end
	end
})
