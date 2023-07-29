local S = mobs_animals.S

mobs:register_mob("mobs_animals:foxy", {
	description = S"Fox",
	type = "animal",
	visual = "mesh",
	mesh = "mobs_fox.b3d",
	collisionbox = {-0.45, -0.05, -0.8, 0.45, 0.75, 0.25},
	animation = {
		speed_normal = 50,
		speed_run = 80,
		walk_start = 0,
		walk_end = 40,
		stand_start = 410,
		stand_end = 550,
		run_start = 0,
		run_end = 40,
		punch_start = 730,
		punch_end = 870,
	},
	textures = {"mobs_fox.png"},
	sounds = {
		attack = "mobs_fox_angry"
	},
	runaway = false,
	jump = false,
	walk_chance = 75,
	walk_velocity = 1,
	run_velocity = 2.5,
	view_range = 14,
	follow = {
		"mobs_animals:chicken_raw"
	},
	damage = 3,
	group_attack = true,
	hp_min = 20,
	hp_max = 24,
	water_damage = 0,
	lava_damage = 2,
	light_damage = 0,
	fall_damage = 1,
	fear_height = 4,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 3},
		{name = "mobs:leather", chance = 2, min = 0, max = 1},
	},
	replace_what = {
		"farming:blueberry_4", "farming:raspberry_4"
	},
	replace_with = "air",
	replace_rate = 10,

	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 10, true, true) then return end

	--	mobs:capture_mob(self, clicker, 0, 0, 80, false, nil)
	end
})

mobs:spawn({
	name = "mobs_animals:foxy",
	mobs_animal.spawn_nodes,
	chance = 30000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg("mobs_animals:foxy", S"Fox Egg", "mobs_fox_egg.png")
