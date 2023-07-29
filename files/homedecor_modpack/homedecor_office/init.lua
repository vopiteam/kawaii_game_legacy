local translator = minetest.get_translator
local S = translator and translator("homedecor_office") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

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

homedecor.register("calendar", {
	description = S("Calendar"),
	mesh = "homedecor_calendar.obj",
	tiles = {"homedecor_calendar.png"},
	inventory_image = "homedecor_calendar_inv.png",
	wield_image = "homedecor_calendar_inv.png",
	paramtype2 = "wallmounted",
	walkable = false,
	selection_box = {
		type = "wallmounted",
		wall_side =   { -8/16, -8/16, -4/16, -5/16,  5/16, 4/16 },
		wall_bottom = { -4/16, -8/16, -8/16,  4/16, -5/16, 5/16 },
		wall_top =    { -4/16,  5/16, -8/16,  4/16,  8/16, 5/16 }
	},
	use_texture_alpha = "clip",
	groups = {choppy=2,attached_node=1},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	infotext = S("Date (right-click to update):\n@1", os.date("%Y-%m-%d")), -- ISO 8601 format
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local date = os.date("%Y-%m-%d")
		meta:set_string("infotext", S("Date (right-click to update):\n@1", date))
		return itemstack
	end,
	on_place = on_place,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil
})

-- crafting

minetest.register_craft({
	output = "homedecor:calendar",
	recipe = {
		{"", "basic_materials:chainlink_steel", ""},
		{"default:paper", "dye:black", "default:paper"},
		{"default:paper", "default:paper", "default:paper"}
	},
})

