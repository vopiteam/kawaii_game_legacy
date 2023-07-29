local S = mobs_animals.S

mobs:register_mob("mobs_animals:bear_b", {
	description = S"Brown Bear",
	type = "animal",
	visual = "mesh",
	mesh = "mobs_bear.b3d",
	collisionbox = {-0.75, -0.01, -0.75, 0.75, 1.49, 0.75},
	animation = {
		speed_normal = 25,	speed_run = 25,
		stand_speed = 5,
		stand_start = 26,	stand_end = 46,
		stand1_speed = 5,
		stand1_start = 47,	stand1_end = 59,
		walk_start = 1,		walk_end = 12,
		run_start = 13,		run_end = 25,
	},
	textures = {"mobs_bear.png"},
	sounds = {
		random = "mobs_bear",
		attack = "mobs_bear_angry"
	},
	jump = false,
	walk_chance = 25,
	walk_velocity = 3,
	run_velocity = 3,
	view_range = 10,
	follow = {
		"farming:blueberries", "farming:raspberries"
	},
	damage = 4,
	attacks_monsters = true,
	pathfinding = true,
	group_attack = true,
	hp_min = 15,
	hp_max = 20,
	fear_height = 4,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(3, 5), pos)
		end
		return {
			{name = "mobs:meat_raw"},
			{name = "mobs:meat_raw"},
			{name = "mobs:meat_raw", chance = 2},
			{name = "mobs:meat_raw", chance = 2},
			{name = "mobs:leather"},
			{name = "mobs:leather", chance = 2}
		}
	end,
	replace_what = {
		"farming:blueberry_4", "farming:raspberry_4"
	},
	replace_with = "air",
	replace_rate = 20,

	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 10, true, true) then return end

		if clicker:get_wielded_item():is_empty() and clicker:get_player_name() == self.owner then
			if clicker:get_player_control().sneak then
				self.order = ""
				self.state = "walk"
				self.walk_velocity = 1
			else
				if self.order == "follow" then
					self.order = "stand"
					self.state = "stand"
					self.walk_velocity = 1
				else
					self.order = "follow"
					self.state = "walk"
					self.walk_velocity = 3
				end
			end
			return
		end

	--	mobs:capture_mob(self, clicker, 0, 0, 80, false, nil)
	end
})

mobs:register_mob("mobs_animals:bear_p", {
	description = S"Polar Bear",
	type = "animal",
	visual = "mesh",
	mesh = "mobs_bear_polar.b3d",
	collisionbox = {-0.75, -0.01, -0.75, 0.75, 1.49, 0.75},
	animation = {
		speed_normal = 25,	speed_run = 25,
		stand_speed = 5,
		stand_start = 26,	stand_end = 46,
		stand1_speed = 5,
		stand1_start = 47,	stand1_end = 59,
		walk_start = 1,		walk_end = 12,
		run_start = 13,		run_end = 25,
	},
	textures = {"mobs_bear_polar.png"},
	sounds = {
		random = "mobs_bear",
		attack = "mobs_bear_angry"
	},
	jump = false,
	walk_chance = 25,
	walk_velocity = 3,
	run_velocity = 3,
	view_range = 10,
	follow = {
		"farming:blueberries", "farming:raspberries"
	},
	damage = 4,
	attacks_monsters = true,
	pathfinding = true,
	group_attack = true,
	specific_attack = {"mobs_animals:fox"},
	hp_min = 15,
	hp_max = 20,
	fear_height = 4,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(3, 5), pos)
		end
		return {
			{name = "mobs:meat_raw"},
			{name = "mobs:meat_raw"},
			{name = "mobs:meat_raw", chance = 2},
			{name = "mobs:meat_raw", chance = 2}
		}
	end
})

mobs:spawn({
	name = "mobs_animals:bear_brown",
	nodes = {
		"default:dirt", "default:dirt_with_grass", "default:dirt_with_dry_grass",
		"default:sand", "default:redsand"
	},
	chance = 30000,
	min_height = 0,
	day_toggle = true
})

mobs:spawn({
	name = "mobs_animals:bear_polar",
	nodes = {
		"default:dirt_with_snow", "default:snow", "default:snowblock", "default:ice"
	},
	chance = 30000,
	min_height = 0,
	day_toggle = true
})


mobs:register_egg("mobs_animals:bear_b", S"Brown Bear Egg", "mobs_bear_egg.png")
mobs:register_egg("mobs_animals:bear_p", S"Polar Bear Egg", "mobs_bear_polar_egg.png")
