local translator = minetest.get_translator
local S = translator and translator("xpanes") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

local function is_pane(pos)
	return minetest.get_item_group(minetest.get_node(pos).name, "pane") > 0
end

local vector_add = vector.add

local function connects_dir(pos, name, dir)
	local aside = vector_add(pos, minetest.facedir_to_dir(dir))
	if is_pane(aside) then
		return true
	end

	local connects_to = minetest.registered_nodes[name].connects_to
	if not connects_to then
		return false
	end
	local list = minetest.find_nodes_in_area(aside, aside, connects_to)

	if #list > 0 then
		return true
	end

	return false
end

local function swap(pos, node, name, param2)
	if node.name == name and node.param2 == param2 then
		return
	end

	minetest.swap_node(pos, {name = name, param2 = param2})
end

local function update_pane(pos)
	if not is_pane(pos) then
		return
	end
	local node = minetest.get_node(pos)
	local name = node.name
	if name:sub(-5) == "_flat" then
		name = name:sub(1, -6)
	end

	local any = node.param2
	local c = {}
	local count = 0
	for dir = 0, 3 do
		c[dir] = connects_dir(pos, name, dir)
		if c[dir] then
			any = dir
			count = count + 1
		end
	end

	if count == 0 then
		swap(pos, node, name .. "_flat", any)
	elseif count == 1 then
		swap(pos, node, name .. "_flat", (any + 1) % 4)
	elseif count == 2 then
		if (c[0] and c[2]) or (c[1] and c[3]) then
			swap(pos, node, name .. "_flat", (any + 1) % 4)
		else
			swap(pos, node, name, 0)
		end
	else
		swap(pos, node, name, 0)
	end
end

minetest.register_on_placenode(function(pos, node)
	if minetest.get_item_group(node, "pane") then
		update_pane(pos)
	end
	for i = 0, 3 do
		local dir = minetest.facedir_to_dir(i)
		update_pane(vector_add(pos, dir))
	end
end)

minetest.register_on_dignode(function(pos)
	for i = 0, 3 do
		local dir = minetest.facedir_to_dir(i)
		update_pane(vector_add(pos, dir))
	end
end)

xpanes = {}
function xpanes.register_pane(name, def)
	local flatgroups = table.copy(def.groups)
	flatgroups.pane = 1

	def.drop = def.drop or "xpanes:" .. name .. "_flat"

	minetest.register_node(":xpanes:" .. name .. "_flat", {
		description = def.description,
		drawtype = "nodebox",
		paramtype = "light",
		is_ground_content = false,
		sunlight_propagates = true,
		inventory_image = def.inventory_image,
		wield_image = def.wield_image,
		paramtype2 = "facedir",
		tiles = {
			def.textures[2], def.textures[2], def.textures[2],
			def.textures[2], def.textures[1], def.textures[1]
		},
		groups = flatgroups,
		drop = def.drop,
		sounds = def.sounds,
		use_texture_alpha = def.use_texture_alpha ~= nil or true,
		node_box = {
			type = "fixed",
			fixed = {-1/2, -1/2, -1/32, 1/2, 1/2, 1/32}
		},
		connect_sides = {"left", "right"}
	})

	local groups = table.copy(def.groups)
	groups.pane = 1
	groups.not_in_creative_inventory = 1
	minetest.register_node(":xpanes:" .. name, {
		drawtype = "nodebox",
		paramtype = "light",
		is_ground_content = false,
		sunlight_propagates = true,
		description = def.description,
		tiles = {
			def.textures[2], def.textures[2], def.textures[1],
			def.textures[1], def.textures[1], def.textures[1]
		},
		groups = groups,
		drop = def.drop,
		sounds = def.sounds,
		use_texture_alpha = def.use_texture_alpha ~= nil or true,
		node_box = {
			type = "connected",
			fixed         = {-1/32, -1/2, -1/32,  1/32, 1/2,  1/32},
			connect_front = {-1/32, -1/2, -1/2,   1/32, 1/2, -1/32},
			connect_left  = {-1/2,  -1/2, -1/32, -1/32, 1/2,  1/32},
			connect_back  = {-1/32, -1/2,  1/32,  1/32, 1/2,  1/2},
			connect_right = { 1/32, -1/2, -1/32,  1/2,  1/2,  1/32}
		},
		connects_to = {"group:pane", "group:stone", "group:glass", "group:wood", "group:tree"}
	})

	if def.recipe then
		minetest.register_craft({
			output = "xpanes:" .. name .. "_flat " .. def.recipe_items,
			recipe = def.recipe
		})
	end
end

xpanes.register_pane("pane", {
	description = S"Glass Pane",
	textures = {"default_glass.png", "xpanes_top_glass.png"},
	sounds = default.node_sound_glass_defaults(),
	groups = {snappy = 2, cracky = 3, oddly_breakable_by_hand = 3, glasspane = 1},
	drop = "",
	recipe = {
		{"default:glass", "default:glass", "default:glass"},
		{"default:glass", "default:glass", "default:glass"}
	},
	recipe_items = "16"
})

local function register_colored_xpanes(name, descrip)	
	xpanes.register_pane("pane_" .. name, {
		description = descrip .. " " .. S"Glass Pane",
		textures = {"glass_" .. name .. ".png", "xpanes_top_glass_" .. name .. ".png"},
		sounds = default.node_sound_glass_defaults(),
		groups = {snappy = 2, cracky = 3, oddly_breakable_by_hand = 3, glasspane = 1},
		drop = ""
	})

	minetest.register_craft({
		type = "shapeless",
		output = "xpanes:pane_" .. name .. "_flat",
		recipe = {"group:dye,color_" .. name, "group:glasspane"}
	})
end

register_colored_xpanes("black", "Black2")
register_colored_xpanes("blue", "Blue2")
register_colored_xpanes("brown", "Brown2")
register_colored_xpanes("cyan", "Cyan2")
register_colored_xpanes("dark_green", "Dark Green2")
register_colored_xpanes("dark_grey", "Dark Grey2")
register_colored_xpanes("green", "Green2")
register_colored_xpanes("grey", "Grey2")
register_colored_xpanes("magenta", "Magenta2")
register_colored_xpanes("orange", "Orange2")
register_colored_xpanes("pink", "Pink2")
register_colored_xpanes("red", "Red2")
register_colored_xpanes("violet", "Violet2")
register_colored_xpanes("white", "White2")
register_colored_xpanes("yellow", "Yellow2")


xpanes.register_pane("bar", {
	description = S"Steel Bars",
	textures = {"xpanes_bar.png", "xpanes_bar_top.png"},
	inventory_image = "xpanes_bar.png",
	wield_image = "xpanes_bar.png",
	groups = {cracky = 2},
	sounds = default.node_sound_metal_defaults(),
	recipe = {
		{"default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot"}
	},
	recipe_items = "12"
})

minetest.register_lbm({
	name = "xpanes:gen2",
	nodenames = {"group:pane"},
	action = function(pos)
		update_pane(pos)
		for i = 0, 3 do
			local dir = minetest.facedir_to_dir(i)
			update_pane(vector_add(pos, dir))
		end
	end
})
