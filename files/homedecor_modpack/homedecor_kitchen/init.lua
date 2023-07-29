-- This file supplies Kitchen stuff like refrigerators, sinks, etc.

-- support for MT game translation.
local translator = minetest.get_translator
local S = translator and translator("homedecor_kitchen") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

homedecor.faucet_work = false

--Refrigerator
local refrigerator_cells = ""
for x = 1, 9 do
for y = 1, 3 do
	refrigerator_cells = refrigerator_cells ..
		"item_image[" .. x - 1 .. "," .. y - 0.15 .. ";1,1;default:cell]"
end
end
local refrigerator_formspec = default.gui ..
	"image[-0.23,-0.26;9,1;formspec_refrigerator_icon.png]" ..
	"image[7.95,3.1;1.1,1.1;^[colorize:#ffafca]]" ..
	refrigerator_cells ..
	"list[current_name;main;0,0.85;9,3;]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]"
	
local function on_construct_refrigerator(pos)
	local meta = minetest.get_meta(pos)
	meta:set_string("formspec", refrigerator_formspec)
	meta:set_string("infotext", S("Refrigerator"))
	meta:set_string("version", "2")
	meta:get_inventory():set_size("main", 9*3)
end

local function on_rightclick_refrigerator(pos)
	minetest.sound_play("kitchen_fridge_open", {gain = 0.3,
		pos = pos, max_hear_distance = 10})
end

local function on_receive_fields_refrigerator(pos, _, fields)
	if fields.quit then
		minetest.sound_play("kitchen_fridge_close", {gain = 0.3,
			pos = pos, max_hear_distance = 10})
	end
end

local function allow_take_put_refrigerator(pos, _, _, stack, player)
	if minetest.is_protected(pos, player and player:get_player_name() or "") then
		return 0
	end
	local def = stack:get_definition()
	if def.groups.food ~= 1 then
		return 0
	end
	return stack:get_count()
end

--Kitchen Cabinet
local kitchen_cab_cells = ""
for x = 1, 9 do
for y = 1, 2 do
	kitchen_cab_cells = kitchen_cab_cells ..
		"item_image[" .. x - 1 .. "," .. y - 0.15 .. ";1,1;default:cell]"
end
end
local kitchen_cab_formspec = default.gui ..
	"image[-0.23,-0.26;9,1;formspec_kitchen_cab_icon.png]" ..
	"image[7.95,3.1;1.1,1.1;^[colorize:#ffafca]]" ..
	kitchen_cab_cells ..
	"list[current_name;main;0,0.85;9,3;]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]"
	
local function on_construct_kitchen_cab(pos)
	local meta = minetest.get_meta(pos)
	meta:set_string("formspec", kitchen_cab_formspec)
	meta:set_string("version", "2")
	meta:get_inventory():set_size("main", 9*2)
end

local function on_rightclick_kitchen_cab(pos)
	minetest.sound_play("kitchen_cab_open", {gain = 0.3,
		pos = pos, max_hear_distance = 10})
end

local function on_receive_fields_kitchen_cab(pos, _, fields)
	if fields.quit then
		minetest.sound_play("kitchen_cab_close", {gain = 0.3,
			pos = pos, max_hear_distance = 10})
	end
end

--Kitchen Cabinet(half)
local kitchen_cab_half_cells = ""
for x = 1, 9 do
for y = 1, 1 do
	kitchen_cab_half_cells = kitchen_cab_half_cells ..
		"item_image[" .. x - 1 .. "," .. y - 0.15 .. ";1,1;default:cell]"
end
end
local kitchen_cab_half_formspec = default.gui ..
	"image[-0.23,-0.26;9,1;formspec_kitchen_cab_icon.png]" ..
	"image[7.95,3.1;1.1,1.1;^[colorize:#ffafca]]" ..
	kitchen_cab_half_cells ..
	"list[current_name;main;0,0.85;9,3;]" ..
	"listring[current_name;main]" ..
	"listring[current_player;main]"
	
local function on_construct_kitchen_cab_half(pos)
	local meta = minetest.get_meta(pos)
	meta:set_string("formspec", kitchen_cab_half_formspec)
	meta:set_string("version", "2")
	meta:get_inventory():set_size("main", 9*1)
end
-------
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
end

-- steel-textured fridge
homedecor.register("refrigerator_steel", {
	mesh = "homedecor_refrigerator.obj",
	tiles = { "homedecor_refrigerator_steel.png" },
	inventory_image = "homedecor_refrigerator_steel_inv.png",
	description = S("Refrigerator (stainless steel)"),
	groups = {snappy=3},
	sounds = default.node_sound_stone_defaults(),
	selection_box = homedecor.nodebox.slab_y(2),
	collision_box = homedecor.nodebox.slab_y(2),
	expand = { top="placeholder" },
	infotext=S("Refrigerator"),
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.rotate_simple or nil,
	on_construct = on_construct_refrigerator,
	on_rightclick = on_rightclick_refrigerator,
	on_destruct = on_destruct,
	on_receive_fields = on_receive_fields_refrigerator,
	allow_metadata_inventory_put = allow_take_put_refrigerator,
	allow_metadata_inventory_take = allow_take_put_refrigerator,
})

-- white, enameled fridge
homedecor.register("refrigerator_white", {
	mesh = "homedecor_refrigerator.obj",
	tiles = { "homedecor_refrigerator_white.png" },
	inventory_image = "homedecor_refrigerator_white_inv.png",
	description = S("Refrigerator"),
	groups = {snappy=3},
	selection_box = homedecor.nodebox.slab_y(2),
	collision_box = homedecor.nodebox.slab_y(2),
	sounds = default.node_sound_stone_defaults(),
	expand = { top="placeholder" },
	infotext=S("Refrigerator"),
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.rotate_simple or nil,
	on_construct = on_construct_refrigerator,
	on_rightclick = on_rightclick_refrigerator,
	on_destruct = on_destruct,
	on_receive_fields = on_receive_fields_refrigerator,
	allow_metadata_inventory_put = allow_take_put_refrigerator,
	allow_metadata_inventory_take = allow_take_put_refrigerator,
})

minetest.register_alias("homedecor:refrigerator_white_bottom", "homedecor:refrigerator_white")
minetest.register_alias("homedecor:refrigerator_white_top", "air")

minetest.register_alias("homedecor:refrigerator_steel_bottom", "homedecor:refrigerator_steel")
minetest.register_alias("homedecor:refrigerator_steel_top", "air")

minetest.register_alias("homedecor:refrigerator_white_bottom_locked", "homedecor:refrigerator_white_locked")
minetest.register_alias("homedecor:refrigerator_white_top_locked", "air")
minetest.register_alias("homedecor:refrigerator_locked", "homedecor:refrigerator_white_locked")

minetest.register_alias("homedecor:refrigerator_steel_bottom_locked", "homedecor:refrigerator_steel_locked")
minetest.register_alias("homedecor:refrigerator_steel_top_locked", "air")

--kitchen

homedecor.register("dishwasher", {
	description = S("Dishwasher"),
	drawtype = "nodebox",
	tiles = {
		"homedecor_dishwasher_top.png",
		"homedecor_dishwasher_bottom.png",
		"homedecor_dishwasher_sides.png",
		"homedecor_dishwasher_sides.png^[transformFX",
		"homedecor_dishwasher_back.png",
		"homedecor_dishwasher_front.png"
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.4375},
			{-0.5, -0.5, -0.5, 0.5, 0.1875, 0.1875},
			{-0.4375, -0.5, -0.5, 0.4375, 0.4375, 0.4375},
		}
	},
	selection_box = { type = "regular" },
	sounds = default.node_sound_stone_defaults(),
	groups = { snappy = 3, not_cuttable = 1 },
})

local materials = { ["granite"] = S("granite"), ["marble"] = S("marble"), ["steel"] = S("steel"), ["wood"] = S("wood") }

for m, m_loc in pairs(materials) do
homedecor.register("dishwasher_"..m, {
	description = S("Dishwasher (@1)", m_loc),
	tiles = {
		"homedecor_kitchen_cabinet_top_"..m..".png",
		"homedecor_dishwasher_bottom.png",
		"homedecor_dishwasher_sides.png",
		"homedecor_dishwasher_sides.png^[transformFX",
		"homedecor_dishwasher_back.png",
		"homedecor_dishwasher_front.png"
	},
	groups = { snappy = 3, not_cuttable = 1 },
	sounds = default.node_sound_stone_defaults(),
})
end

local cabinet_sides = "(default_wood.png^[transformR90)^homedecor_kitchen_cabinet_bevel.png"
local cabinet_bottom = "(default_wood.png^[colorize:#000000:100)"
	.."^(homedecor_kitchen_cabinet_bevel.png^[colorize:#46321580)"

local function N_(x) return x end

local counter_materials = { "", N_("granite"), N_("marble"), N_("steel") }

for _, mat in ipairs(counter_materials) do

	local desc = S("Kitchen Cabinet")
	local material = ""

	if mat ~= "" then
		desc = S("Kitchen Cabinet (@1 top)", S(mat))
		material = "_"..mat
	end

	homedecor.register("kitchen_cabinet"..material, {
		description = desc,
		tiles = { 'homedecor_kitchen_cabinet_top'..material..'.png',
				cabinet_bottom,
				cabinet_sides,
				cabinet_sides,
				cabinet_sides,
				'homedecor_kitchen_cabinet_front.png'},
		groups = { snappy = 3, not_cuttable = 1 },
		sounds = default.node_sound_wood_defaults(),
		infotext=S("Kitchen Cabinet"),
		on_construct = on_construct_kitchen_cab,
		on_rightclick = on_rightclick_kitchen_cab,
		on_destruct = on_destruct,
		on_receive_fields = on_receive_fields_kitchen_cab,
		allow_metadata_inventory_put = allow_take_put,
		allow_metadata_inventory_take = allow_take_put,
	})
end

local kitchen_cabinet_half_box = homedecor.nodebox.slab_y(0.5, 0.5)
homedecor.register("kitchen_cabinet_half", {
	description = S('Half-height Kitchen Cabinet (on ceiling)'),
	tiles = {
		cabinet_sides,
		cabinet_bottom,
		cabinet_sides,
		cabinet_sides,
		cabinet_sides,
		'homedecor_kitchen_cabinet_front_half.png'
	},
	selection_box = kitchen_cabinet_half_box,
	node_box = kitchen_cabinet_half_box,
	groups = { snappy = 3, not_cuttable = 1 },
	sounds = default.node_sound_wood_defaults(),
	infotext=S("Kitchen Cabinet"),
	on_construct = on_construct_kitchen_cab_half,
	on_rightclick = on_rightclick_kitchen_cab,
	on_destruct = on_destruct,
	on_receive_fields = on_receive_fields_kitchen_cab,
	allow_metadata_inventory_put = allow_take_put,
	allow_metadata_inventory_take = allow_take_put,
})

homedecor.register("kitchen_cabinet_with_sink", {
	description = S("Kitchen Cabinet with sink"),
	mesh = "homedecor_kitchen_sink.obj",
	tiles = {
		"homedecor_kitchen_sink_top.png",
		"homedecor_kitchen_cabinet_front.png",
		cabinet_sides,
		cabinet_bottom
	},
	groups = { snappy = 3, not_cuttable = 1 },
	sounds = default.node_sound_wood_defaults(),
	infotext=S("Under-sink cabinet"),
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, -8/16, -8/16,  8/16, 6/16,  8/16 },
			{ -8/16,  6/16, -8/16, -6/16, 8/16,  8/16 },
			{  6/16,  6/16, -8/16,  8/16, 8/16,  8/16 },
			{ -8/16,  6/16, -8/16,  8/16, 8/16, -6/16 },
			{ -8/16,  6/16,  6/16,  8/16, 8/16,  8/16 },
		}
	},
	on_destruct = function(pos)
		homedecor.stop_particle_spawner({x=pos.x, y=pos.y+1, z=pos.z})
	end
})

local cp_cbox = {
	type = "fixed",
	fixed = { -0.375, -0.5, -0.5, 0.375, -0.3125, 0.3125 }
}

homedecor.register("copper_pans", {
	description = S("Copper pans"),
	mesh = "homedecor_copper_pans.obj",
	tiles = { "homedecor_polished_copper.png" },
	inventory_image = "homedecor_copper_pans_inv.png",
	groups = { snappy=3 },
	selection_box = cp_cbox,
	walkable = false,
	on_place = minetest.rotate_node
})

local kf_cbox = {
	type = "fixed",
	fixed = { -2/16, -8/16, 1/16, 2/16, -1/16, 8/16 }
}

homedecor.register("kitchen_faucet", {
	mesh = "homedecor_kitchen_faucet.obj",
	tiles = { "homedecor_generic_metal_bright.png" },
	inventory_image = "homedecor_kitchen_faucet_inv.png",
	description = S("Kitchen Faucet"),
	groups = {snappy=3},
	selection_box = kf_cbox,
	walkable = false,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)		
		local below = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
		if below and
		 	below.name == "homedecor:sink" or
			below.name == "homedecor:kitchen_cabinet_with_sink" or
		  	below.name == "homedecor:kitchen_cabinet_with_sink_locked" then
			local particledef = {
				outlet      = { x = 0, y = -0.19, z = 0.13 },
				velocity_x  = { min = -0.05, max = 0.05 },
				velocity_y  = -0.3,
				velocity_z  = { min = -0.1,  max = 0 },
				spread      = 0
			}
			homedecor.start_particle_spawner(pos, node, particledef, "homedecor_faucet")
		end
		
		return itemstack
	end,
	on_destruct = homedecor.stop_particle_spawner
})

if minetest.get_modpath("bucket") then
	local original_bucket_on_use = minetest.registered_items["bucket:bucket_empty"].on_use
	minetest.override_item("bucket:bucket_empty", {
		on_use = function(itemstack, user, pointed_thing)
			local inv = user:get_inventory()

			if pointed_thing.type == "node" and minetest.get_node(pointed_thing.under).name == "homedecor:kitchen_faucet" and homedecor.faucet_work == true then
				if inv:room_for_item("main", "bucket:bucket_river_water 1") then
					itemstack:take_item()
					inv:add_item("main", "bucket:bucket_river_water 1")
				else
					minetest.chat_send_player(user:get_player_name(), S("No room in your inventory to add a filled bucket!"))
				end
				return itemstack
			else if original_bucket_on_use then
				return original_bucket_on_use(itemstack, user, pointed_thing)
			else return end
		end
	end
	})
end

homedecor.register("paper_towel", {
	mesh = "homedecor_paper_towel.obj",
	tiles = {
		"homedecor_generic_quilted_paper.png",
		"default_wood.png"
	},
	inventory_image = "homedecor_paper_towel_inv.png",
	description = S("Paper towels"),
	groups = { snappy=3 },
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = { -0.4375, 0.125, 0.0625, 0.4375, 0.4375, 0.5 }
	},
})


-- kitchen "furnaces"
homedecor.register_furnace("oven", {
	description = S("Oven"),
	tile_format = "homedecor_oven_%s%s.png",
	output_slots = 4,
	output_width = 2,
	cook_speed = 1.25,
	groups = { cracky=2, not_cuttable = 1 },
})

homedecor.register_furnace("oven_steel", {
	description = S("Oven (stainless steel)"),
	tile_format = "homedecor_oven_steel_%s%s.png",
	output_slots = 4,
	output_width = 2,
	cook_speed = 1.25,
	groups = { cracky=2, not_cuttable = 1 },
})

homedecor.register_furnace("microwave_oven", {
	description = S("Microwave Oven"),
	tiles = {
		"homedecor_microwave_top.png", "homedecor_microwave_top.png^[transformR180",
		"homedecor_microwave_top.png^[transformR270", "homedecor_microwave_top.png^[transformR90",
		"homedecor_microwave_top.png^[transformR180", "homedecor_microwave_front.png"
	},
	tiles_active = {
		"homedecor_microwave_top.png", "homedecor_microwave_top.png^[transformR180",
		"homedecor_microwave_top.png^[transformR270", "homedecor_microwave_top.png^[transformR90",
		"homedecor_microwave_top.png^[transformR180", "homedecor_microwave_front_active.png"
	},
	output_slots = 2,
	output_width = 2,
	cook_speed = 1.5,
	extra_nodedef_fields = {
		node_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.125, 0.5, 0.125, 0.5 },
		},
	},
})

-- crafting

minetest.register_craft({
	output = "homedecor:refrigerator_steel",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot", },
		{"default:steel_ingot", "default:copperblock", "default:steel_ingot", },
		{"default:steel_ingot", "default:clay", "default:steel_ingot", },
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:refrigerator_white",
	recipe = {
		"homedecor:refrigerator_steel",
		"dye:white",
		"dye:white",
		"dye:white",
	}
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet",
        recipe = {
		{"group:wood", "group:stick", "group:wood", },
		{"group:wood", "group:stick", "group:wood", },
		{"group:wood", "group:stick", "group:wood", },
	}
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet_steel",
        recipe = {
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
			{"", "homedecor:kitchen_cabinet", ""},
	}
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet_marble",
        recipe = {
			{"default:marble"},
			{"homedecor:kitchen_cabinet"},
	}
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet_granite",
        recipe = {
			{"default:granite"},
			{"homedecor:kitchen_cabinet"},
	}
})

minetest.register_craft({
	type = "shapeless",
        output = "homedecor:kitchen_cabinet_half 2",
        recipe = { "homedecor:kitchen_cabinet" }
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet_with_sink",
        recipe = {
		{"group:wood", "default:steel_ingot", "group:wood", },
		{"group:wood", "default:steel_ingot", "group:wood", },
		{"group:wood", "group:stick", "group:wood", },
	}
})

minetest.register_craft( {
    output = "homedecor:dishwasher",
    recipe = {
		{ "basic_materials:ic",  "default:steel_ingot",    "default:steel_ingot",  },
		{ "default:steel_ingot", "basic_materials:chainlink_steel", "basic_materials:motor" },
		{ "default:steel_ingot", "basic_materials:heating_element", "bucket:bucket_water"   }
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher",
    recipe = {
		{ "basic_materials:ic",  "default:steel_ingot",    "default:steel_ingot",  },
		{ "default:steel_ingot", "basic_materials:chainlink_steel", "basic_materials:motor" },
		{ "default:steel_ingot", "basic_materials:heating_element", "bucket:bucket_river_water"   }
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_wood",
    recipe = {
		{ "group:wood", "group:wood", "group:wood" },
		{ "", "homedecor:dishwasher", "" },
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_steel",
    recipe = {
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
		{ "", "homedecor:dishwasher", "" },
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_marble",
    recipe = {
		{ "default:marble", "default:marble", "default:marble" },
		{ "", "homedecor:dishwasher", ""  },
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_granite",
    recipe = {
		{ "default:granite", "default:granite", "default:granite" },
		{ "", "homedecor:dishwasher", ""  },
    },
})

minetest.register_craft( {
        output = "homedecor:kitchen_faucet",
        recipe = {
			{ "", "default:steel_ingot" },
			{ "default:steel_ingot", "" },
			{ "basic_materials:steel_bar", "" }
        },
})

minetest.register_craft( {
        output = "homedecor:cutlery_set",
        recipe = {
			{ "", "vessels:glass_bottle", "" },
			{ "basic_materials:steel_strip", "default:marble", "basic_materials:steel_strip" },
        },
})

minetest.register_craft({
	output = "homedecor:copper_pans",
	recipe = {
		{ "basic_materials:copper_strip","","basic_materials:copper_strip" },
		{ "default:copper_ingot","","default:copper_ingot" },
		{ "default:copper_ingot","","default:copper_ingot" }
	},
})

minetest.register_craft({
    output = "homedecor:paper_towel",
    recipe = {
		{ "default:steel_ingot", "default:paper" }
    },
})

--furnace
minetest.register_craft({
        output = "homedecor:oven_steel",
        recipe = {
		{"basic_materials:heating_element", "default:steel_ingot", "basic_materials:heating_element", },
		{"default:steel_ingot", "default:glass", "default:steel_ingot", },
		{"default:steel_ingot", "basic_materials:heating_element", "default:steel_ingot", },
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:oven",
	recipe = {
		"homedecor:oven_steel",
		"dye:white",
		"dye:white",
	}
})

minetest.register_craft({
        output = "homedecor:microwave_oven",
        recipe = {
		{"default:steel_ingot", "default:steel_ingot", "", },
		{"", "default:glass", "basic_materials:ic", },
		{"default:steel_ingot", "default:copper_ingot", "basic_materials:energy_crystal_simple", },
	}
})