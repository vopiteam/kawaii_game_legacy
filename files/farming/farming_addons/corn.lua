local S = farming_addons.S

farming.register_plant("farming_addons:corn", {
	description = S"Corn Seed",
	harvest_description = S"Corn",
	inventory_image = "farming_addons_corn_seed.png",
	steps = 8,
	minlight = 12,
	fertility = {"grassland"},
	groups = {flammable = 4, food = 1, wieldview = 2},
	place_param2 = 3
})

-- place corn
minetest.override_item("farming_addons:corn", {
	on_use = minetest.item_eat(2),
	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local udef = minetest.registered_nodes[node.name]
		if udef and udef.on_rightclick and
				not (placer and placer:is_player() and
				placer:get_player_control().sneak) then
			return udef.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		return farming.place_seed(itemstack, placer, pointed_thing, "farming_addons:seed_corn") or itemstack
	end
})

minetest.override_item("farming_addons:corn_4", {
	visual_scale = 2.0,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.6, 0.25}
	}
})

minetest.override_item("farming_addons:corn_5", {
	visual_scale = 2.0,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.6, 0.25}
	}
})

minetest.override_item("farming_addons:corn_6", {
	visual_scale = 2.0,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.6, 0.25}
	}
})

minetest.override_item("farming_addons:corn_7", {
	visual_scale = 2.0,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.6, 0.25}
	}
})

minetest.override_item("farming_addons:corn_8", {
	visual_scale = 2.0,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.6, 0.25}
	}
})

-- Baked Corn
minetest.register_craftitem("farming_addons:corn_baked", {
	description = S"Baked Corn",
	inventory_image = "farming_addons_corn_baked.png",
	groups = {food = 1, wieldview = 2},
	on_use = minetest.item_eat(8)
})

minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "farming_addons:corn_baked",
	recipe = "farming_addons:corn"
})

minetest.register_alias("farming_plants:sunflower", "farming_addons:corn")
minetest.register_alias_force("farming_plants:head_sunflower", "farming_addons:corn")
minetest.register_alias("farming_plants:seed_sunflower", "farming_addons:seed_corn")
minetest.register_alias("farming_plants:seed_sunflower_fried", "farming_addons:corn_baked")
minetest.register_alias("farming_plants:oil_puddle", "farming_plants:oil")
minetest.register_alias("farming_plants:oil", "basic_materials:oil_extract")