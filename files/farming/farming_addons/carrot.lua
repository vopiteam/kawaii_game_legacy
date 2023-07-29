local S = farming_addons.S

farming.register_plant("farming_addons:carrot", {
	description = S"Carrot Seed",
	harvest_description = S"Carrot",
	paramtype2 = "meshoptions",
	inventory_image = "farming_addons_carrot_seed.png",
	steps = 4,
	minlight = 12,
	fertility = {"grassland"},
	groups = {flammable = 4, food = 1, wieldview = 2},
	place_param2 = 3
})

-- place and eat carrots
minetest.override_item("farming_addons:carrot", {
	on_use = minetest.item_eat(3),
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

		return farming.place_seed(itemstack, placer, pointed_thing, "farming_addons:seed_carrot") or itemstack
	end
})

-- Golden Carrot
minetest.register_craftitem("farming_addons:carrot_golden", {
	description = S"Golden Carrot",
	inventory_image = "farming_addons_carrot_golden.png",
	wield_image = "farming_addons_carrot_golden.png",
	groups = {food = 1, wieldview = 2},
	on_use = minetest.item_eat(10)
})

minetest.register_craft({
	output = "farming_addons:carrot_golden",
	recipe = {
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
		{"default:gold_ingot", "farming_addons:carrot", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"}
	}
})
