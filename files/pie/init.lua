pie = {}

local translator = minetest.get_translator
local S = translator and translator("pie") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

-- eat pie slice function
local replace_pie = function(pos, node, puncher)
	if not minetest.is_valid_pos(pos) then
		return
	end
	if minetest.is_protected(pos, puncher:get_player_name()) then
		return
	end

	local pie = node.name:split("_")[1]
	local num = tonumber(node.name:split("_")[2])

	-- eat slice or remove whole pie
	if num == 3 then
		node.name = "air"
	elseif num < 3 then
		node.name = pie .. "_" .. (num + 1)
	end

	minetest.swap_node(pos, {name = node.name})
	if minetest.settings:get_bool("enable_damage") then
		hunger.change_saturation(puncher, 4)
	end
	minetest.sound_play("player_eat", {
		pos = pos,
		gain = 0.7,
		max_hear_distance = 5
	})
end

-- register pie bits
local tcopy = table.copy
function pie.register_pie(pie, desc)
	local pie_node = {
		paramtype = "light",
		sunlight_propagates = false,
		drawtype = "nodebox",
		tiles = {
			"pie_" .. pie .. "_top.png", "pie_" .. pie .. "_bottom.png", "pie_" .. pie .. "_side.png",
			"pie_" .. pie .. "_side.png", "pie_" .. pie .. "_side.png", "pie_" .. pie .. "_inside.png"
		},
		groups = {food = 1, falling_node = 1},
		on_punch = replace_pie
	}

	-- full pie
	local pie_full = tcopy(pie_node)
	pie_full.node_box = {
		type = "fixed",
		fixed = {-0.43, -0.5, -0.43, 0.43, 0, 0.43}
	}
	pie_full.tiles = {
			"pie_" .. pie .. "_top.png", "pie_" .. pie .. "_bottom.png", "pie_" .. pie .. "_side.png",
			"pie_" .. pie .. "_side.png", "pie_" .. pie .. "_side.png", "pie_" .. pie .. "_side.png"
	}
	pie_full.description = S(desc)
	pie_full.stack_max = 1
	pie_full.inventory_image = "pie_" .. pie .. "_inv.png"
--	pie_full.wield_image = "pie_" .. pie .. "_wield.png"
	minetest.register_node("pie:" .. pie .. "_0", pie_full)

	-- 3/4 pie
	local pie_75 = tcopy(pie_node)
	pie_75.node_box = {
		type = "fixed",
		fixed = {-0.43, -0.5, -0.25, 0.43, 0, 0.43}
	}
	pie_75.groups.not_in_creative_inventory = 1
	minetest.register_node("pie:" .. pie .. "_1", pie_75)

	-- 2/4 pie
	local pie_50 = tcopy(pie_node)
	pie_50.node_box = {
		type = "fixed",
		fixed = {-0.43, -0.5, 0.0, 0.43, 0, 0.43}
	}
	pie_50.groups.not_in_creative_inventory = 1
	minetest.register_node("pie:" .. pie .. "_2", pie_50)

	-- 1/4 pie
	local pie_25 = tcopy(pie_node)
	pie_25.node_box = {
		type = "fixed",
		fixed = {-0.43, -0.5, 0.25, 0.43, 0, 0.43}
	}
	pie_25.groups.not_in_creative_inventory = 1
	minetest.register_node("pie:" .. pie .. "_3", pie_25)
end

--== Pie Registration ==--

-- Cake
pie.register_pie("cake", "Cake")
minetest.register_craft({
	output = "pie:cake_0",
	recipe = {
		{"bucket:bucket_milk", "bucket:bucket_milk", "bucket:bucket_milk"},
		{"default:sugar", "group:egg", "default:sugar"},
		{"farming:flour", "farming:flour", "farming:flour"}
	},
	replacements = {
		{"bucket:bucket_milk", "bucket:bucket_empty"},
		{"bucket:bucket_milk", "bucket:bucket_empty"},
		{"bucket:bucket_milk", "bucket:bucket_empty"}
	}
})

-- Pumpkin
pie.register_pie("pumpkin", "Pumpkin Pie")
minetest.register_craft({
	output = "pie:pumpkin_0",
	recipe = {
		{"", "", ""},
		{"farming_addons:pumpkin_fruit", "group:egg", ""},
		{"", "farming:flour", ""}
	}
})
