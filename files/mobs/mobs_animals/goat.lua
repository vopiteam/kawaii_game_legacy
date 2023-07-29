local S = mobs_animals.S

mobs:register_mob("mobs_animals:goat", {
	description = S"Goat",
	type = "animal",
	passive = true,
	hp_min = 5,
	hp_max = 15,
	collisionbox = {-0.5, -0.01, -0.5, 0.5, 1.1, 0.5},
	visual = "mesh",
	mesh = "mobs_goat.b3d",
	textures = {
		{"mobs_goat.png"},
		{"mobs_goat2.png"},
		{"mobs_goat3.png"}
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_goat",
		damage = "mobs_goat_moaning"
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
		speed_normal = 25, speed_run = 25,
		stand_start = 26, stand_end = 46,
		walk_start = 1,	walk_end = 12,
		run_start = 13, run_end = 25
	},
	follow = {"default:apple", "farming_addons:carrot", "farming_addons:potato"},

	on_rightclick = function(self, clicker)
		mobs:feed_tame(self, clicker, 8, true, true)
	--	mobs:capture_mob(self, clicker, 0, 5, 50, false, nil)
	end
})

mobs:spawn({
	name = "mobs_animals:goat",
	nodes = {"default:dirt", "default:sand", "default:redsand",
	"default:snow", "default:snowblock",
	"default:dirt_with_snow", "default:dirt_with_grass", "default:dirt_with_dry_grass"},
	min_light = 5,
	chance = 20000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg("mobs_animals:goat", S"Goat Egg", "mobs_goat_egg.png")
