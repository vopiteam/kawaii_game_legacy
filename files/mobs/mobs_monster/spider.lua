local spider_replace = {"air", "mobs:cobweb"}
if not minetest.is_singleplayer() then
	spider_replace = {}
end

-- Spider by AspireMint (fishyWET (CC-BY-SA 3.0 license for texture)
mobs:register_mob("mobs_monster:spider", {
	docile_by_day = true,
	group_attack = true,
	type = "monster",
	passive = false,
	damage = 2,
	hp_min = 15,
	hp_max = 20,
	collisionbox = {-0.8, -0.5, -0.8, 0.8, 0, 0.8},
	visual = "mesh",
	mesh = "mobs_spider.b3d",
	textures = {
		{"mobs_spider.png"},
		{"mobs_spider_grey.png"},
		{"mobs_spider_orange.png"}
	},
	sounds = {
		random = "mobs_spider",
		attack = "mobs_spider"
	},
	run_velocity = 3,
	view_range = 15,
	replace_rate = 192,
	replace_what = {
		spider_replace
	},
	floats = 0,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(2, 4), pos)
		end
		return {
			{name = "farming:string"},
			{name = "farming:string", chance = 2}
		}
	end,
	water_damage = 5,
	animation = {
		speed_normal = 15,	speed_run = 20,
		stand_start = 0,	stand_end = 0,
		walk_start = 1,		walk_end = 21,
		run_start = 1,		run_end = 21,
		punch_start = 25,	punch_end = 45,
	},

	-- make spiders jump at you on attack
--[[custom_attack = function(self)
		local vel = self.object:get_velocity()

		self.object:set_velocity({
			x = vel.x * self.run_velocity,
			y = self.jump_height * 1.2,
			z = vel.z * self.run_velocity
		})

		self.pausetimer = 0.5

		return true -- continue rest of attack function
	end]]
})

-- Small spider
mobs:register_mob("mobs_monster:small_spider", {
	group_attack = true,
	type = "animal",
	passive = false,
	damage = 1,
	hp_min = 5,
	hp_max = 10,
	collisionbox = {-0.3, -0.15, -0.3, 0.3, 0.05, 0.3},
	visual = "mesh",
	mesh = "mobs_spider.b3d",
	textures = {
		{"mobs_spider.png"},
		{"mobs_spider_grey.png"},
		{"mobs_spider_orange.png"}
	},
	visual_size = {x = 0.3, y = 0.3},
	sounds = {
		random = "mobs_spider",
		attack = "mobs_spider"
	},
	run_velocity = 3,
	view_range = 10,
	floats = 0,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(2), pos)
		end
		return {
			{name = "farming:string"}
		}
	end,
	water_damage = 5,
	animation = {
		speed_normal = 15,	speed_run = 20,
		stand_start = 0,	stand_end = 0,
		walk_start = 1,		walk_end = 21,
		run_start = 1,		run_end = 21,
		punch_start = 25,	punch_end = 45
	}
})

mobs:register_egg("mobs_monster:spider", mobs_monster.S"Spider Egg", "mobs_monster_egg.png^mobs_monster_spider_egg.png")
mobs:register_egg("mobs_monster:small_spider", mobs_monster.S"Small Spider Egg", "mobs_monster_egg.png^mobs_monster_spider_small_egg.png")

mobs:spawn({
	name = "mobs_monster:spider",
	nodes = mobs_monster.spawn_nodes,
	max_light = 12,
	chance = 20000
})

mobs:spawn({
	name = "mobs_monster:small_spider",
	nodes = mobs_monster.spawn_nodes,
	chance = 20000
})
