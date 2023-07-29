local S = mobs_animal.S

mobs:register_mob("mobs_animal:pig", {
	description = S"Pig",
	type = "animal",
	passive = true,
	hp_min = 5,
	hp_max = 15,
	collisionbox = {-0.5, -0.01, -0.5, 0.5, 1.1, 0.5},
	visual = "mesh",
	mesh = "mobs_pig.b3d",
	textures = {
		{"mobs_pig.png"},
		{"mobs_pig_black.png"},
		{"mobs_pig_motley.png"}
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_pig",
		damage = "mobs_pig_angry"
	},
	walk_velocity = 2,
	run_velocity = 3,
	runaway = true,
	drops = function(pos)
		if rawget(_G, "experience") then
			experience.add_orb(math.random(3), pos) -- random amount between 1 and 3
		end

		return {
			{name = "mobs:pork_raw"},
			{name = "mobs:pork_raw", chance = 2},
			{name = "mobs:pork_raw", chance = 2}
		}
	end,
	fear_height = 2,
	animation = {
		stand_start = 0,	stand_end = 60,
		walk_start = 61,	walk_end = 80,
		punch_start = 90,	punch_end = 110
	},
	follow = {"default:apple", "farming_addons:carrot", "farming_addons:potato"},

	on_rightclick = function(self, clicker)
		mobs:feed_tame(self, clicker, 8, true, true)
	--	mobs:capture_mob(self, clicker, 0, 5, 50, false, nil)
	end
})

mobs:spawn({
	name = "mobs_animal:pig",
	nodes = mobs_animal.spawn_nodes,
	min_light = 5,
	chance = 20000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg("mobs_animal:pig", S"Pig Egg", "mobs_pig_egg.png")
