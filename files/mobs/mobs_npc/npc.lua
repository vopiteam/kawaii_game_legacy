-- Npc by TenPlus1

local b = "blank.png"

mobs.npc_drops = {
	"default:pick_steel", "mobs:meat", "default:sword_steel",
	"default:shovel_steel", "farming:bread", "bucket:bucket_water"
}

local mtextures = {}
local mcount = 1
for i = 1, 3 do
for j = 1, 3 do
for k = 1, 3 do
	mtextures[mcount] = {
		"mobs_npc_man.png" .. "^" ..
		"mobs_npc_man_hair" .. i .. ".png" .. "^" ..
		"mobs_npc_man_pants" .. j .. ".png" .. "^" ..
		"mobs_npc_man_shirt" .. k .. ".png", b, b
	}
	mcount = mcount + 1
end
end
end

mobs:register_mob("mobs_npc:npc_man", {
	type = "npc",
	damage = 2,
	attacks_monsters = true,
	attack_players = false,
	hp_min = 15,
	hp_max = 20,
	collisionbox = {-0.35, -1.0, -0.35, 0.35, 0.8, 0.35},
	visual = "mesh",
	mesh = "mobs_npc.b3d",
	textures = mtextures,
	makes_footstep_sound = true,
	sounds = {},
	jump = true,
	lava_damage = 3,
	fear_height = 3,
	animation = {
		speed_normal = 30,	speed_run = 30,
		stand_start = 0,	stand_end = 79,
		walk_start = 168,	walk_end = 187, walk_speed = 15,
		run_start = 168,	run_end = 187,
		punch_start = 189,	punch_end = 198
	},

	do_punch = function(_, hitter)
		if not hitter or not hitter:is_player() then
			return true
		end
	end,

	after_activate = mobs_npc.replace_model,
})

local wtextures = {}
local wcount = 1
for i = 1, 3 do
for j = 1, 3 do
for k = 1, 3 do
	wtextures[wcount] = {
		"mobs_npc_woman.png" .. "^" ..
		"mobs_npc_woman_hair" .. i .. ".png" .. "^" ..
		"mobs_npc_woman_pants" .. j .. ".png" .. "^" ..
		"mobs_npc_woman_shirt" .. k .. ".png", b, b
	}
	wcount = wcount + 1
end
end
end

mobs:register_mob("mobs_npc:npc_woman", {
	type = "npc",
	damage = 1,
	attacks_monsters = true,
	attack_players = false,
	hp_min = 15,
	hp_max = 20,
	collisionbox = {-0.35, -1.0, -0.35, 0.35, 0.8, 0.35},
	visual = "mesh",
	mesh = "mobs_npc.b3d",
	textures = wtextures,
	makes_footstep_sound = true,
	sounds = {},
	jump = true,
	lava_damage = 3,
	fear_height = 3,
	animation = {
		speed_normal = 30,	speed_run = 30,
		stand_start = 0,	stand_end = 79,
		walk_start = 168,	walk_end = 187, walk_speed = 15,
		run_start = 168,	run_end = 187,
		punch_start = 189,	punch_end = 198
	},

	do_punch = function(_, hitter)
		if not hitter or not hitter:is_player() then
			return true
		end
	end,

	after_activate = mobs_npc.replace_model,
})


mobs:register_egg("mobs_npc:npc_man", mobs_npc.S("NPC Man"), "mobs_npc_man_egg.png")
mobs:register_egg("mobs_npc:npc_woman", mobs_npc.S("NPC Woman"), "mobs_npc_woman_egg.png")