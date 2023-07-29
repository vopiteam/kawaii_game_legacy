local translator = minetest.get_translator
local S = translator and translator("homedecor_windows") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

--Window Quartered Lime
homedecor.register("window_quartered_lime", {
	description = S("Window Lime(quartered)"),
	tiles = {
		"homedecor_window_sides_lime.png",
		"homedecor_window_sides_lime.png",
		"homedecor_window_sides_lime.png",
		"homedecor_window_sides_lime.png",
		"homedecor_window_quartered_lime.png",
		"homedecor_window_quartered_lime.png"
	},
	use_texture_alpha = true,
	groups = {snappy=3},
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.025, 0.5, 0.5, 0}, -- NodeBox1
			{-0.5, 0.4375, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox2
			{-0.5, -0.5, -0.0625, 0.5, -0.4375, 0.0625}, -- NodeBox3
			{-0.5, -0.0625, -0.025, 0.5, 0.0625, 0.025}, -- NodeBox4
			{0.4375, -0.5, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox5
			{-0.5, -0.5, -0.0625, -0.4375, 0.5, 0.0625}, -- NodeBox6
			{-0.0625, -0.5, -0.025, 0.0625, 0.5, 0.025}, -- NodeBox7
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
})
minetest.register_craft({
    output = "homedecor:window_quartered_lime",
    recipe = {
		{ "group:stick", "default:glass", "group:stick"},
		{ "", "group:stick", ""},
		{ "group:stick", "dye:green", "group:stick"},
	},
})

--Window Quartered Violet
homedecor.register("window_quartered_violet", {
	description = S("Window Violet (quartered)"),
	tiles = {
		"homedecor_window_sides_violet.png",
		"homedecor_window_sides_violet.png",
		"homedecor_window_sides_violet.png",
		"homedecor_window_sides_violet.png",
		"homedecor_window_quartered_violet.png",
		"homedecor_window_quartered_violet.png"
	},
	use_texture_alpha = true,
	groups = {snappy=3},
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.025, 0.5, 0.5, 0}, -- NodeBox1
			{-0.5, 0.4375, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox2
			{-0.5, -0.5, -0.0625, 0.5, -0.4375, 0.0625}, -- NodeBox3
			{-0.5, -0.0625, -0.025, 0.5, 0.0625, 0.025}, -- NodeBox4
			{0.4375, -0.5, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox5
			{-0.5, -0.5, -0.0625, -0.4375, 0.5, 0.0625}, -- NodeBox6
			{-0.0625, -0.5, -0.025, 0.0625, 0.5, 0.025}, -- NodeBox7
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
})
minetest.register_craft({
    output = "homedecor:window_quartered_violet",
    recipe = {
		{ "group:stick", "default:glass", "group:stick"},
		{ "", "group:stick", ""},
		{ "group:stick", "dye:violet", "group:stick"},
	},
})

--Window Quartered Yellow
homedecor.register("window_quartered_yellow", {
	description = S("Window Yellow (quartered)"),
	tiles = {
		"homedecor_window_sides_yellow.png",
		"homedecor_window_sides_yellow.png",
		"homedecor_window_sides_yellow.png",
		"homedecor_window_sides_yellow.png",
		"homedecor_window_quartered_yellow.png",
		"homedecor_window_quartered_yellow.png"
	},
	use_texture_alpha = true,
	groups = {snappy=3},
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.025, 0.5, 0.5, 0}, -- NodeBox1
			{-0.5, 0.4375, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox2
			{-0.5, -0.5, -0.0625, 0.5, -0.4375, 0.0625}, -- NodeBox3
			{-0.5, -0.0625, -0.025, 0.5, 0.0625, 0.025}, -- NodeBox4
			{0.4375, -0.5, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox5
			{-0.5, -0.5, -0.0625, -0.4375, 0.5, 0.0625}, -- NodeBox6
			{-0.0625, -0.5, -0.025, 0.0625, 0.5, 0.025}, -- NodeBox7
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
})
minetest.register_craft({
    output = "homedecor:window_quartered_yellow",
    recipe = {
		{ "group:stick", "default:glass", "group:stick"},
		{ "", "group:stick", ""},
		{ "group:stick", "dye:yellow", "group:stick"},
	},
})

------------------------------------------------

--Window Plain Lime
homedecor.register("window_plain_lime", {
	description = S("Window Lime (plain)"),
	tiles = {
		"homedecor_window_sides_lime.png",
		"homedecor_window_sides_lime.png",
		"homedecor_window_sides_lime.png",
		"homedecor_window_sides_lime.png",
		"homedecor_window_frame_lime.png",
		"homedecor_window_frame_lime.png"
	},
	use_texture_alpha = true,
	groups = {snappy=3},
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.025, 0.5, 0.5, 0}, -- NodeBox1
			{-0.5, 0.4375, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox2
			{-0.5, -0.5, -0.0625, 0.5, -0.4375, 0.0625}, -- NodeBox3
			{0.4375, -0.5, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox4
			{-0.5, -0.5, -0.0625, -0.4375, 0.5, 0.0625}, -- NodeBox5
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
})
minetest.register_craft({
    output = "homedecor:window_plain_lime",
    recipe = {
		{ "group:stick", "default:glass", "group:stick"},
		{ "", "", ""},
		{ "group:stick", "dye:green", "group:stick"},
	},
})

--Window Plain Violet
homedecor.register("window_plain_violet", {
	description = S("Window Violet (plain)"),
	tiles = {
		"homedecor_window_sides_violet.png",
		"homedecor_window_sides_violet.png",
		"homedecor_window_sides_violet.png",
		"homedecor_window_sides_violet.png",
		"homedecor_window_frame_violet.png",
		"homedecor_window_frame_violet.png"
	},
	use_texture_alpha = true,
	groups = {snappy=3},
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.025, 0.5, 0.5, 0}, -- NodeBox1
			{-0.5, 0.4375, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox2
			{-0.5, -0.5, -0.0625, 0.5, -0.4375, 0.0625}, -- NodeBox3
			{0.4375, -0.5, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox4
			{-0.5, -0.5, -0.0625, -0.4375, 0.5, 0.0625}, -- NodeBox5
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
})
minetest.register_craft({
    output = "homedecor:window_plain_violet",
    recipe = {
		{ "group:stick", "default:glass", "group:stick"},
		{ "", "", ""},
		{ "group:stick", "dye:violet", "group:stick"},
	},
})

--Window Plain Yellow
homedecor.register("window_plain_yellow", {
	description = S("Window Yellow (plain)"),
	tiles = {
		"homedecor_window_sides_yellow.png",
		"homedecor_window_sides_yellow.png",
		"homedecor_window_sides_yellow.png",
		"homedecor_window_sides_yellow.png",
		"homedecor_window_frame_yellow.png",
		"homedecor_window_frame_yellow.png"
	},
	use_texture_alpha = true,
	groups = {snappy=3},
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.025, 0.5, 0.5, 0}, -- NodeBox1
			{-0.5, 0.4375, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox2
			{-0.5, -0.5, -0.0625, 0.5, -0.4375, 0.0625}, -- NodeBox3
			{0.4375, -0.5, -0.0625, 0.5, 0.5, 0.0625}, -- NodeBox4
			{-0.5, -0.5, -0.0625, -0.4375, 0.5, 0.0625}, -- NodeBox5
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
	}
})
minetest.register_craft({
    output = "homedecor:window_plain_yellow",
    recipe = {
		{ "group:stick", "default:glass", "group:stick"},
		{ "", "", ""},
		{ "group:stick", "dye:yellow", "group:stick"},
	},
})

------------------------------------------------

local wb1_cbox = {
	type = "fixed",
	fixed = { -8/16, -8/16, 5/16, 8/16, 8/16, 8/16 },
}

--Window Blinds Blue (thick)
homedecor.register("blinds_thick_blue", {
	description = S("Window Blinds Blue (thick)"),
	mesh = "homedecor_windowblind_thick.obj",
	inventory_image = "homedecor_windowblind_thick_inv_blue.png",
	tiles = {
		"homedecor_windowblind_strings_blue.png",
		"homedecor_windowblinds_blue.png"
	},
	walkable = false,
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = wb1_cbox
})
minetest.register_craft({
    output = "homedecor:blinds_thick_blue",
    recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "", "dye:blue", "farming:string" },
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
    },
})

--Window Blinds Green (thick)
homedecor.register("blinds_thick_green", {
	description = S("Window Blinds Green (thick)"),
	mesh = "homedecor_windowblind_thick.obj",
	inventory_image = "homedecor_windowblind_thick_inv_green.png",
	tiles = {
		"homedecor_windowblind_strings_green.png",
		"homedecor_windowblinds_green.png"
	},
	walkable = false,
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = wb1_cbox
})
minetest.register_craft({
    output = "homedecor:blinds_thick_green",
    recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "", "dye:green", "farming:string" },
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
    },
})

--Window Blinds Red (thick)
homedecor.register("blinds_thick_red", {
	description = S("Window Blinds Red (thick)"),
	mesh = "homedecor_windowblind_thick.obj",
	inventory_image = "homedecor_windowblind_thick_inv_red.png",
	tiles = {
		"homedecor_windowblind_strings_red.png",
		"homedecor_windowblinds_red.png"
	},
	walkable = false,
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = wb1_cbox
})
minetest.register_craft({
    output = "homedecor:blinds_thick_red",
    recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "", "dye:red", "farming:string" },
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
    },
})

-----------------------------------------------

local wb2_cbox = {
	type = "fixed",
	fixed = { -8/16, -8/16, 6/16, 8/16, 8/16, 8/16 },
}

--Window Blinds Blue (thin)
homedecor.register("blinds_thin_blue", {
	description = S("Window Blinds Blue (thin)"),
	mesh = "homedecor_windowblind_thin.obj",
	inventory_image = "homedecor_windowblind_thin_inv_blue.png",
	tiles = {
		"homedecor_windowblind_strings_blue.png",
		"homedecor_windowblinds_blue.png"
	},
	walkable = false,
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = wb2_cbox
})
minetest.register_craft({
    output = "homedecor:blinds_thin_blue",
    recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "", "dye:blue", "farming:string" },
		{ "", "", "" },
    },
})

--Window Blinds Green (thin)
homedecor.register("blinds_thin_green", {
	description = S("Window Blinds Green (thin)"),
	mesh = "homedecor_windowblind_thin.obj",
	inventory_image = "homedecor_windowblind_thin_inv_green.png",
	tiles = {
		"homedecor_windowblind_strings_green.png",
		"homedecor_windowblinds_green.png"
	},
	walkable = false,
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = wb2_cbox
})
minetest.register_craft({
    output = "homedecor:blinds_thin_green",
    recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "", "dye:green", "farming:string" },
		{ "", "", "" },
    },
})

--Window Blinds Red (thin)
homedecor.register("blinds_thin_red", {
	description = S("Window Blinds Red (thin)"),
	mesh = "homedecor_windowblind_thin.obj",
	inventory_image = "homedecor_windowblind_thin_inv_red.png",
	tiles = {
		"homedecor_windowblind_strings_red.png",
		"homedecor_windowblinds_red.png"
	},
	walkable = false,
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	selection_box = wb2_cbox
})
minetest.register_craft({
    output = "homedecor:blinds_thin_red",
    recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "", "dye:red", "farming:string" },
		{ "", "", "" },
    },
})

-----------------------------------------------

local function on_place(itemstack, placer, pointed_thing)
	if pointed_thing.type == "node" then
		local undery = pointed_thing.under.y
		local posy = pointed_thing.above.y
		if undery == posy then -- allowed wall-mounted only
			itemstack = minetest.item_place(itemstack, placer, pointed_thing)
			minetest.sound_play({name = "default_place_node_hard"},
					{pos = pointed_thing.above})
		end
	end
	return itemstack
end

--Curtains Blue
minetest.register_node(":homedecor:curtain_closed_blue", {
	description = S("Curtains Blue"),
	tiles = { "homedecor_curtain_blue.png" },
	inventory_image = "homedecor_curtain_blue.png",
	wield_image = "homedecor_curtain_blue.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3, ud_param2_colorable = 1, not_in_creative_inventory=1 },
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	selection_box = { type = "wallmounted" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_open_blue", param2 = node.param2})
		return itemstack
	end,
	on_place = on_place,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
})
minetest.register_node(":homedecor:curtain_open_blue", {
	description = S("Curtains Blue (open)"),
	tiles = { "homedecor_curtain_open_blue.png" },
	inventory_image = "homedecor_curtain_open_blue.png",
	wield_image = "homedecor_curtain_open_blue.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3, ud_param2_colorable = 1 },
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	selection_box = { type = "wallmounted" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_closed_blue", param2 = node.param2})
		return itemstack
	end,
	on_place = on_place,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
})
minetest.register_craft( {
	output = "homedecor:curtain_open_blue",
		recipe = {
		{ "wool:white", "", ""},
		{ "wool:white", "dye:blue", ""},
		{ "wool:white", "", ""},
	},
})

--Curtains Orange
minetest.register_node(":homedecor:curtain_closed_orange", {
	description = S("Curtains Orange"),
	tiles = { "homedecor_curtain_orange.png" },
	inventory_image = "homedecor_curtain_orange.png",
	wield_image = "homedecor_curtain_orange.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3, not_in_creative_inventory=1 },
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	selection_box = { type = "wallmounted" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_open_orange", param2 = node.param2})
		return itemstack
	end,
	on_place = on_place,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
})
minetest.register_node(":homedecor:curtain_open_orange", {
	description = S("Curtains Orange (open)"),
	tiles = { "homedecor_curtain_open_orange.png" },
	inventory_image = "homedecor_curtain_open_orange.png",
	wield_image = "homedecor_curtain_open_orange.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3,},
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	selection_box = { type = "wallmounted" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_closed_orange", param2 = node.param2})
		return itemstack
	end,
	on_place = on_place,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
})
minetest.register_craft( {
	output = "homedecor:curtain_open_orange",
		recipe = {
		{ "wool:white", "", ""},
		{ "wool:white", "dye:orange", ""},
		{ "wool:white", "", ""},
	},
})

--Curtains Pink
minetest.register_node(":homedecor:curtain_closed_pink", {
	description = S("Curtains Pink"),
	tiles = { "homedecor_curtain_pink.png" },
	inventory_image = "homedecor_curtain_pink.png",
	wield_image = "homedecor_curtain_pink.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3, not_in_creative_inventory=1 },
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	selection_box = { type = "wallmounted" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_open_pink", param2 = node.param2})
		return itemstack
	end,
	on_place = on_place,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
})
minetest.register_node(":homedecor:curtain_open_pink", {
	description = S("Curtains Pink (open)"),
	tiles = { "homedecor_curtain_open_pink.png" },
	inventory_image = "homedecor_curtain_open_pink.png",
	wield_image = "homedecor_curtain_open_pink.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3,},
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	selection_box = { type = "wallmounted" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_closed_pink", param2 = node.param2})
		return itemstack
	end,
	on_place = on_place,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
})
minetest.register_craft( {
	output = "homedecor:curtain_open_pink",
		recipe = {
		{ "wool:white", "", ""},
		{ "wool:white", "dye:pink", ""},
		{ "wool:white", "", ""},
	},
})

--Curtains Halloween
minetest.register_node(":homedecor:curtain_closed_halloween", {
	description = S("Halloween Curtains"),
	tiles = { "homedecor_curtain_halloween.png" },
	inventory_image = "homedecor_curtain_halloween.png",
	wield_image = "homedecor_curtain_halloween.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3, not_in_creative_inventory=1 },
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	selection_box = { type = "wallmounted" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_open_halloween", param2 = node.param2})
		return itemstack
	end,
	on_place = on_place,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
})
minetest.register_node(":homedecor:curtain_open_halloween", {
	description = S("Halloween Curtains (open)"),
	tiles = { "homedecor_curtain_open_halloween.png" },
	inventory_image = "homedecor_curtain_open_halloween.png",
	wield_image = "homedecor_curtain_open_halloween.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3,},
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	selection_box = { type = "wallmounted" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_closed_halloween", param2 = node.param2})
		return itemstack
	end,
	on_place = on_place,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
})
minetest.register_craft( {
	output = "homedecor:curtain_open_halloween",
		recipe = {
		{ "wool:white", "", ""},
		{ "wool:white", "dye:orange", "mobs:piece_ghost"},
		{ "wool:white", "", ""},
	},
})

--Curtains Christmas
minetest.register_node(":homedecor:curtain_closed_christmas", {
	description = S("Christmas Curtains"),
	tiles = { "homedecor_curtain_christmas.png" },
	inventory_image = "homedecor_curtain_christmas.png",
	wield_image = "homedecor_curtain_christmas.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3, not_in_creative_inventory=1 },
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	selection_box = { type = "wallmounted" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_open_christmas", param2 = node.param2})
		return itemstack
	end,
	on_place = on_place,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
})
minetest.register_node(":homedecor:curtain_open_christmas", {
	description = S("Christmas Curtains (open)"),
	tiles = { "homedecor_curtain_open_christmas.png" },
	inventory_image = "homedecor_curtain_open_christmas.png",
	wield_image = "homedecor_curtain_open_christmas.png",
	drawtype = 'signlike',
	use_texture_alpha = true,
	walkable = false,
	groups = { snappy = 3,},
	sounds = default.node_sound_leaves_defaults(),
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	selection_box = { type = "wallmounted" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, { name = "homedecor:curtain_closed_christmas", param2 = node.param2})
		return itemstack
	end,
	on_place = on_place,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
})
minetest.register_craft( {
	output = "homedecor:curtain_open_christmas",
		recipe = {
		{ "wool:white", "", ""},
		{ "wool:white", "dye:blue", "dye:white"},
		{ "wool:white", "", ""},
	},
})

-----------------------------------------------

--Curtain Rod Blue
homedecor.register("curtainrod_blue", {
	tiles = { "homedecor_curtainrod_texture_blue.png" },
	inventory_image  = "homedecor_curtainrod_inv_blue.png",
	description = S("Curtain Rod Blue"),
	groups = { snappy = 3 },
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.375, 0.5, -0.4375, 0.4375},
			{-0.4375, -0.5, 0.4375, -0.375, -0.4375, 0.5},
			{0.375, -0.5, 0.4375, 0.4375, -0.4375, 0.5}
		}
	}
})
minetest.register_craft({
	output = "homedecor:curtainrod_blue",
	recipe = {
		{"basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet"},
		{"", "dye:blue", ""},
		{"", "", ""},
	},
})

--Curtain Rod Green
homedecor.register("curtainrod_green", {
	tiles = { "homedecor_curtainrod_texture_green.png" },
	inventory_image  = "homedecor_curtainrod_inv_green.png",
	description = S("Curtain Rod Green"),
	groups = { snappy = 3 },
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.375, 0.5, -0.4375, 0.4375},
			{-0.4375, -0.5, 0.4375, -0.375, -0.4375, 0.5},
			{0.375, -0.5, 0.4375, 0.4375, -0.4375, 0.5}
		}
	}
})
minetest.register_craft({
	output = "homedecor:curtainrod_green",
	recipe = {
		{"basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet"},
		{"", "dye:green", ""},
		{"", "", ""},
	},
})

--Curtain Rod Magenta
homedecor.register("curtainrod_magenta", {
	tiles = { "homedecor_curtainrod_texture_magenta.png" },
	inventory_image  = "homedecor_curtainrod_inv_magenta.png",
	description = S("Curtain Rod Magenta"),
	groups = { snappy = 3 },
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.375, 0.5, -0.4375, 0.4375},
			{-0.4375, -0.5, 0.4375, -0.375, -0.4375, 0.5},
			{0.375, -0.5, 0.4375, 0.4375, -0.4375, 0.5}
		}
	}
})
minetest.register_craft({
	output = "homedecor:curtainrod_magenta",
	recipe = {
		{"basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet"},
		{"", "dye:magenta", ""},
		{"", "", ""},
	},
})

-----------------------------------------------

--Stained Glass
homedecor.register("stained_glass", {
	description = S("Stained Glass"),
	tiles = {"homedecor_stained_glass.png"},
	inventory_image = "homedecor_stained_glass.png",
	groups = {snappy=3},
	use_texture_alpha = true,
	light_source = 3,
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "fixed",
		fixed = { {-0.5, -0.5, 0.46875, 0.5, 0.5, 0.5} }
	}
})
minetest.register_craft({
	output = "homedecor:stained_glass 3",
	recipe = {
		{"default:glass", "dye:green", "default:glass"},
		{"dye:blue", "default:glass", "dye:yellow"},
		{"default:glass", "dye:magenta", "default:glass"},
	},
})

-----------------------------------------------

local shutter_cbox = {
	type = "wallmounted",
	wall_top =		{ -0.5,  0.4375, -0.5,  0.5,     0.5,    0.5 },
	wall_bottom =	{ -0.5, -0.5,    -0.5,  0.5,    -0.4375, 0.5 },
	wall_side =		{ -0.5, -0.5,    -0.5, -0.4375,  0.5,    0.5 }
}

--Wooden Shutter
homedecor.register("shutter", {
	mesh = "homedecor_window_shutter.obj",
	tiles = {"homedecor_wood_textura.png"},
	description = S("Wooden Shutter"),
	inventory_image = "homedecor_window_shutter_inv.png",
	wield_image = "homedecor_window_shutter_inv.png",
	paramtype2 = "colorwallmounted",
	groups = { snappy = 3 },
	sounds = default.node_sound_wood_defaults(),
	selection_box = shutter_cbox,
	node_box = shutter_cbox,
})
minetest.register_craft( {
	output = "homedecor:shutter",
	recipe = {
		{"group:wood", "", "group:wood"},
		{"group:stick", "group:stick", "group:stick"},
		{"group:wood", "", "group:wood"},
	},
})
minetest.register_craft({
        type = "fuel",
        recipe = "homedecor:shutter",
        burntime = 30,
})