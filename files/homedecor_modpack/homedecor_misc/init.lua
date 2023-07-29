-- Home Decor mod by VanessaE
--
-- Mostly my own code, with bits and pieces lifted from Minetest's default
-- lua files and from ironzorg's flowers mod.  Many thanks to GloopMaster
-- for helping me figure out the inventories used in the nightstands/dressers.
--
-- The code for ovens, nightstands, refrigerators are basically modified
-- copies of the code for chests and furnaces.

local translator = minetest.get_translator
local S = translator and translator("homedecor_misc") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

homedecor_misc = {}

local ft_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.375, 0.5, 0.3125, 0.375 }
}

homedecor.register("fishtank", {
	description = S("Fishtank"),
	mesh = "homedecor_fishtank.obj",
	tiles = {
		"homedecor_fishtank_top.png",
		"homedecor_fishtank_filter.png",
		"homedecor_fishtank_fishes.png",
		"homedecor_fishtank_gravel.png",
		"homedecor_fishtank_water_top.png",
		"homedecor_fishtank_sides.png",
	},
	use_texture_alpha = true,
	selection_box = ft_cbox,
	collision_box = ft_cbox,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "homedecor:fishtank_lighted", param2 = node.param2})
		return itemstack
	end
})

homedecor.register("fishtank_lighted", {
	description = S("Fishtank (lighted)"),
	mesh = "homedecor_fishtank.obj",
	tiles = {
		"homedecor_fishtank_top.png",
		"homedecor_fishtank_filter.png",
		"homedecor_fishtank_fishes_lighted.png",
		"homedecor_fishtank_gravel_lighted.png",
		"homedecor_fishtank_water_top_lighted.png",
		"homedecor_fishtank_sides_lighted.png",
	},
	light_source = minetest.LIGHT_MAX - 4,
	use_texture_alpha = true,
	selection_box = ft_cbox,
	collision_box = ft_cbox,
	groups = {cracky=3,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
	sounds = default.node_sound_glass_defaults(),
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "homedecor:fishtank", param2 = node.param2})
		return itemstack
	end,
	drop = "homedecor:fishtank",
})

local piano_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.125, 1.5, 0.5, 0.5 }
}

homedecor.register("piano", {
	mesh = "homedecor_piano.obj",
	tiles = {
		"default_cherry_blossom_wood.png",
		"homedecor_piano_keys.png",
		"default_gold_block.png",
	},
	inventory_image = "homedecor_piano_inv.png",
	description = S("Piano"),
	groups = { snappy = 3 },
	selection_box = piano_cbox,
	collision_box = piano_cbox,
	expand = { right="placeholder" },
	sounds = default.node_sound_wood_defaults(),
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.sound_play('homedecor_misc_note', {
            pos = pos,
            max_hear_distance = 4
        })
	end,
})

minetest.register_alias("homedecor:piano_left", "homedecor:piano")
minetest.register_alias("homedecor:piano_right", "air")

local tr_cbox = {
	type = "fixed",
	fixed = { -0.3125, -0.5, -0.1875, 0.3125, 0.125, 0.1875 }
}

homedecor.register("trophy", {
	description = S("Trophy"),
	mesh = "homedecor_trophy.obj",
	tiles = {
		"default_birch_wood.png",
		"default_gold_block.png"
	},
	inventory_image = "homedecor_trophy_inv.png",
	groups = { snappy=3 },
	walkable = false,
	selection_box = tr_cbox,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
})

minetest.register_node(":homedecor:tatami_mat", {
	tiles = {
		"homedecor_tatami.png",
		"homedecor_tatami.png",
		"homedecor_tatami.png",
		"homedecor_tatami.png",
		"homedecor_tatami.png",
		"homedecor_tatami.png"
	},
	description = S("Japanese tatami"),
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy=3},
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
		}
	}
})

-- crafting

minetest.register_craft({
	output = "homedecor:fishtank",
	recipe = {
		{ "basic_materials:plastic_sheet", "default:glowstone_dust", "basic_materials:plastic_sheet" },
		{ "default:glass", "bucket:bucket_water", "default:glass" },
		{ "default:glass", "default:gravel", "default:glass" },
	},
	replacements = { {"bucket:bucket_water", "bucket:bucket_empty"} }
})

minetest.register_craft({
	output = "homedecor:fishtank",
	recipe = {
		{ "basic_materials:plastic_sheet", "default:glowstone_dust", "basic_materials:plastic_sheet" },
		{ "default:glass", "bucket:bucket_river_water", "default:glass" },
		{ "default:glass", "default:gravel", "default:glass" },
	},
	replacements = { {"bucket:bucket_river_water", "bucket:bucket_empty"} }
})

minetest.register_craft( {
	output = "homedecor:tatami_mat 3",
	recipe = {
		{"farming:wheat", "farming:wheat", "farming:wheat"}
	},
})

minetest.register_craft({
	output = "homedecor:piano",
	recipe = {
		{ "", "basic_materials:steel_wire", "default:cherry_blossom_wood" },
		{ "basic_materials:plastic_strip", "basic_materials:steel_wire", "default:cherry_blossom_wood" },
		{ "basic_materials:brass_ingot", "default:steelblock", "default:cherry_blossom_wood" }
	},
})

minetest.register_craft({
	output = "homedecor:trophy 3",
	recipe = {
		{ "default:gold_ingot","","default:gold_ingot" },
		{ "","default:gold_ingot","" },
		{ "group:wood","default:gold_ingot","group:wood" }
	},
})