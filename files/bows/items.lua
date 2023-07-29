bows.register_bow("bow",{
	description = "Bow",
	texture = "bows_bow.png",
	texture_loaded = "bows_bow_loaded.png",
	uses = 50,
	level = 1,
	craft = {
		{"", "group:wood", "farming:string"},
		{"group:wood", "", "farming:string"},
		{"", "group:wood", "farming:string"}
	},
})

bows.register_arrow("arrow",{
	description = "Arrow",
	texture = "bows_arrow.png",
	damage = 5,
	craft_count = 4,
	drop_chance = 10,
	craft = {
		{"default:flint"},
		{"default:stick"},
		{"default:paper"}
	},
	on_hit_node = function(self, pos, user, arrow_pos)
		minetest.add_item(pos, "bows:arrow")
	end,
})

minetest.register_alias("throwing:arrow", "bows:arrow")
minetest.register_alias("throwing:arrow_item", "bows:arrow")
minetest.register_alias("throwing:bow", "bows:bow")