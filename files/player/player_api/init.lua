player_api = {}

local translator = minetest.get_translator
local S = translator and translator("player_api") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local path = minetest.get_modpath("player_api")
dofile(path .. "/api.lua")
dofile(path .. "/wieldview.lua")

local creative_mode_cache = minetest.settings:get_bool("creative_mode")

-- Default player appearance
local b = "blank.png"
player_api.register_model("character.b3d", {
	visual_size = {x = 10, y = 10, z = 10},
	animation_speed = 30,
	textures = {player_api.default_skin, player_api.default_hair, b, b, b, b, b},
	animations = {
		-- Standard animations.
		stand     = {x = 0,   y = 79},
		lay       = {x = 162, y = 166, eye_height = 0.3, override_local = true,
			collisionbox = {-0.6, 0.0, -0.6, 0.6, 0.3, 0.6}},
		walk      = {x = 168, y = 187},
		mine      = {x = 189, y = 198},
		walk_mine = {x = 200, y = 219},
		sit       = {x = 81,  y = 160, eye_height = 0.8, override_local = true,
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.0, 0.3}},
		ride       = {x = 81,  y = 160, eye_height = 0.8, override_local = true,
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.0, 0.3}}	
	},
	stepheight = 0.6,
	eye_height = 1.47
})

-- Hand definition
player_api.hand = {
	wield_scale = {x = 1, y = 1, z = 0.7},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "hand.b3d",
	tiles = {"character_boy_1.png"},
	inventory_image = b,
	drop = "",
	node_placement_prediction = "",
	groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
	on_place = function(i) return i end
}

local hand = player_api.hand
if creative_mode_cache then
	local digtime = 96
	local caps = {times = {digtime, digtime, digtime}, uses = 0, maxlevel = 192}

	hand.range = 10
	hand.tool_capabilities = {
		full_punch_interval = 0.5,
		max_drop_level = 3,
		groupcaps = {
			crumbly = caps,
			cracky  = caps,
			snappy  = caps,
			choppy  = caps,
			oddly_breakable_by_hand = caps
		},
		damage_groups = {fleshy = 5}
	}
else
	hand.tool_capabilities = {
		full_punch_interval = 0.5,
		max_drop_level = 0,
		groupcaps = {
			crumbly = {times = {[1]=5.0, [2]=3.0, [3]=2.0}, uses = 0, maxlevel = 1},
			snappy  = {times = {[1]=0.5, [2]=0.5, [3]=0.5}, uses = 0, maxlevel = 1},
			choppy  = {times = {[1]=6.0, [2]=4.0, [3]=3.0}, uses = 0, maxlevel = 1},
			cracky  = {times = {[1]=7.0, [2]=5.0, [3]=4.0}, uses = 0, maxlevel = 1},
			oddly_breakable_by_hand = {times = {[1]=3.5, [2]=2.0, [3]=0.7}, uses = 0}
		},
		damage_groups = {fleshy = 1}
	}
end

minetest.register_node("player_api:hand", hand)

-- Update appearance when the player joins
minetest.register_on_joinplayer(function(player)
	player_api.player_attached[player:get_player_name()] = false
	player_api.set_model(player, "character.b3d")

	player:hud_set_hotbar_itemcount(9)
	player:hud_set_hotbar_image("gui_hotbar.png")
	player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")

	local inv = player:get_inventory()
	inv:set_size("main", 36)
	inv:set_size("hand", 1)
	inv:set_stack("hand", 1, "player_api:hand")
end)

-- Items for the new player
if not creative_mode_cache and minetest.is_singleplayer() then
	minetest.register_on_newplayer(function(player)
		player:get_inventory():add_item("main", "default:sword_steel")
		player:get_inventory():add_item("main", "default:torch 8")
		player:get_inventory():add_item("main", "default:wood 32")
	end)
end

-- Drop items at death
minetest.register_on_dieplayer(function(player)
	local pos = player:get_pos()
	local inv = player:get_inventory()

	-- Drop inventory items
	local stack
	local item_drop = minetest.item_drop
	for i = 1, inv:get_size("main") do
		stack = inv:get_stack("main", i)
		if stack:get_count() > 0 then
			item_drop(stack, nil, pos)
		end
	end
	inv:set_list("main", {})

	-- Display death coordinates
	local name = player:get_player_name()
	local pos_string = minetest.pos_to_string(pos, 1)

	minetest.chat_send_player(name, S("Your last coordinates: @1", pos_string))
	minetest.log("action", "Player \"" .. name .. "\" died at " .. pos_string)
end)
