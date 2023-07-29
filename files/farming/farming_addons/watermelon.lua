local S = farming_addons.S

farming.register_plant("farming_addons:melon", {
	description = S"Watermelon Seed",
	harvest_description = S"Watermelon",
	inventory_image = "farming_addons_melon_seed.png",
	steps = 8,
	minlight = 12,
	fertility = {"grassland"},
	groups = {flammable = 4, food = 1},
	place_param2 = 3
})

-- eat melons
minetest.override_item("farming_addons:melon", {
	description = S"Watermelon Slice",
	on_use = minetest.item_eat(2)
})

-- how often node timers for plants will tick
local function tick(pos)
	minetest.get_node_timer(pos):start(math.random(512, 1024))
end

-- WATERMELON FRUIT - HARVEST
minetest.register_node("farming_addons:melon_fruit", {
	description = S"Watermelon",
	tiles = {"farming_addons_melon_fruit_top.png", "farming_addons_melon_fruit_top.png", "farming_addons_melon_fruit_side.png"},
	paramtype2 = "facedir",
	sounds = default.node_sound_wood_defaults(),
	is_ground_content = false,
	groups = {snappy = 3, flammable = 4, fall_damage_add_percent = -30, food = 1, not_cuttable = 1, falling_node = 1},
	drop = {
		items = {
			{items = {"farming_addons:melon"}},
			{items = {"farming_addons:melon"}},
			{items = {"farming_addons:melon"}},
			{items = {"farming_addons:melon"}, rarity = 2},
			{items = {"farming_addons:melon"}, rarity = 2},
			{items = {"farming_addons:melon"}, rarity = 3},
			{items = {"farming_addons:melon"}, rarity = 3}
		}
	},
	after_dig_node = function(_, _, oldmetadata)
		local parent = oldmetadata.fields.parent
		local parent_pos_from_child = minetest.string_to_pos(parent)
		local parent_node

		-- make sure we have position
		if parent_pos_from_child
			and parent_pos_from_child ~= nil then
			parent_node = minetest.get_node(parent_pos_from_child)
		end

		-- tick parent if parent stem still exists
		if parent_node ~= nil
				and parent_node.name == "farming_addons:melon_8" then
			tick(parent_pos_from_child)
		end
	end
})

-- take over the growth from minetest_game farming from here
minetest.override_item("farming_addons:melon_8", {
	next_plant = "farming_addons:melon_fruit",
	on_timer = farming_addons.grow_block
})

-- Melon
minetest.register_craftitem("farming_addons:melon_golden", {
	description = S"Golden Watermelon Slice",
	inventory_image = "farming_addons_melon_golden.png",
	on_use = minetest.item_eat(10),
	groups = {food = 1}
})

--
-- Recipes
--

-- Seed
minetest.register_craft({
	output = "farming_addons:seed_melon",
	recipe = {{"farming_addons:melon"}}
})

-- Golden Melon
minetest.register_craft({
	output = "farming_addons:melon_golden",
	recipe = {
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
		{"default:gold_ingot", "farming_addons:melon", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"}
	}
})

-- Block
minetest.register_craft({
	output = "farming_addons:melon_fruit",
	recipe = {
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"},
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"},
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"}
	}
})

--
-- Generation
--

minetest.register_decoration({
	name = "default:grass",
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 80,
	fill_ratio = 0.0001,
	biomes = {"rainforest"},
	y_max = 40,
	y_min = 1,
	decoration = "farming_addons:melon_fruit"
})
