local S = mobs_animal.S

mobs:register_mob("mobs_animal:wolf", {
	description = S"Wolf",
	type = "animal",
	damage = 2,
	hp_min = 30,
	hp_max = 35,
	collisionbox = {-0.6, -0.01, -0.6, 0.6, 1.1, 0.6},
	visual = "mesh",
	mesh = "mobs_wolf.b3d",
	textures = {
		{"mobs_wolf.png"}
	},
	animation = {
		speed_normal = 25,	speed_run = 25,
		stand_start = 26,	stand_end = 46,
		walk_start = 1,	walk_end = 12,
		run_start = 13,	run_end = 25,
		punch_start = 82,	punch_end = 94
	},
	makes_footstep_sound = true,
	sounds = {
		war_cry = "mobs_wolf_attack",
		death = "mobs_wolf_attack"
	},
	walk_chance = 75,
	walk_velocity = 2,
	run_velocity = 3,
	view_range = 7,
	follow = {"group:food_meat_raw", "default:bone"},
	pathfinding = true,
	group_attack = true,
	fear_height = 4,

	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 2, false, true) then
			if self.food == 0 then
				local mob = minetest.add_entity(self.object:get_pos(), "mobs_animal:dog")
				local ent = mob:get_luaentity()
				ent.owner = clicker:get_player_name()
				ent.following = clicker
				ent.order = "follow"
				self.object:remove()
			end
			return
		end
	--	mobs:capture_mob(self, clicker, 0, 0, 80, true, nil)
	end
})

-- Dog
mobs:register_mob("mobs_animal:dog", {
	description = S"Dog",
	type = "npc",
	damage = 4,
	hp_min = 25,
	hp_max = 30,
	collisionbox = {-0.6, -0.01, -0.6, 0.6, 1.1, 0.6},
	visual = "mesh",
	mesh = "mobs_wolf.b3d",
	textures = {
		{"mobs_dog.png"}
	},
	animation = {
		speed_normal = 25,	speed_run = 25,
		stand_start = 26,	stand_end = 46,
		walk_start = 1,	walk_end = 12,
		run_start = 13,	run_end = 25,
		punch_start = 82,	punch_end = 94
	},
	makes_footstep_sound = true,
	sounds = {
		war_cry = "mobs_wolf_attack",
		death = "mobs_wolf_attack"
	},
	water_damage = 0,
	fear_height = 4,
	walk_chance = 75,
	walk_velocity = 2,
	run_velocity = 4,
	view_range = 15,
	follow = {"group:food_meat_raw", "default:bone"},
	attacks_monsters = true,
	pathfinding = true,
	group_attack = true,

	on_rightclick = function(self, clicker)
		if mobs:feed_tame(self, clicker, 6, true, true) then return end
		if clicker:get_wielded_item():is_empty() and clicker:get_player_name() == self.owner then
			if clicker:get_player_control().sneak then
				self.order = ""
				self.state = "walk"
				self.walk_velocity = 2
				self.stepheight = 0.6
			else
				if self.order == "follow" then
					self.order = "stand"
					self.state = "stand"
					self.walk_velocity = 2
					self.stepheight = 0.6
				else
					self.order = "follow"
					self.state = "walk"
					self.walk_velocity = 3
					self.stepheight = 1.1
				end
			end
			return
		end
	--	mobs:capture_mob(self, clicker, 0, 0, 80, false, nil)
	end
})

mobs:spawn({
	name = "mobs_animal:wolf",
	mobs_animal.spawn_nodes,
	chance = 20000,
	min_height = 0,
	day_toggle = true
})

mobs:register_egg("mobs_animal:wolf", S"Wolf's Egg", "mobs_wolf_egg.png")
mobs:register_egg("mobs_animal:dog", S"Dog Egg", "mobs_dog_egg.png")
