mobs:register_mob("mobs_animals:parrot", {
	type = "animal",
	passive = true,
	hp_min = 8,
	hp_max = 10,
	collisionbox = {-0.35, -0.01, -0.35, 0.35, 0.75, 0.35},
	visual = "mesh",
	mesh = "mobs_parrot.b3d",
	textures = {
		{"mobs_parrot_green.png"},
		{"mobs_parrot_red.png"},
		{"mobs_parrot_yellow.png"}
	},
	makes_footstep_sound = true,
	run_velocity = 2.5,
	runaway = true,
	water_damage = 1,
	fall_damage = 0,
	fall_speed = -8,
	fear_height = 5,
	animation = {
		speed_normal = 25, speed_run = 25,
		stand_start = 26,	stand_end = 46,
		walk_start = 1,	walk_end = 12,
		run_start = 13,	run_end = 25,
		fly_start = 92,	fly_end = 98
	},
	fly = false,
	follow = {"seed"},

	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
	end
})

mobs:spawn({
	name = "mobs_animals:parrot",
	nodes = {"default:leaves", "default:jungleleaves", "default:acacia_leaves", "default:birch_leaves", "default:grass", "default:dry_grass", "default:junglegrass"},
	min_light = 10,
	chance = 15000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg("mobs_animals:parrot", mobs_animals.S"Parrot Egg", "mobs_parrot_egg.png")

mobs:alias_mob("mobs_animal:parrot", "mobs_animals:parrot")
