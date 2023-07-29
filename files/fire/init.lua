fire = {}

local translator = minetest.get_translator
local S = translator and translator("fire") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

--
-- Items
--

-- Flood flame function
local function flood_flame(pos, _, newnode)
	-- Play flame extinguish sound if liquid is not an 'igniter'
	if minetest.get_item_group(newnode.name, "igniter") == 0 then
		minetest.sound_play("fire_extinguish_flame",
			{pos = pos, max_hear_distance = 16, gain = 0.15})
	end
	-- Remove the flame
	return false
end

local fire_node = {
	drawtype = "firelike",
	tiles = {{
		name = "fire_basic_flame_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 32,
			aspect_h = 32,
			length = 1
		}}
	},
	inventory_image = "fire_basic_flame.png",
	paramtype = "light",
	light_source = 13,
	walkable = false,
	buildable_to = true,
	sunlight_propagates = true,
	floodable = true,
	damage_per_second = 4,
	groups = {igniter = 2, dig_immediate = 3, fire = 1, not_in_creative_inventory = 1},
	drop = "",
	on_flood = flood_flame
}

-- Flame nodes
local flame_fire_node = table.copy(fire_node)
flame_fire_node.on_timer = function(pos)
	local f = minetest.find_node_near(pos, 1, {"group:flammable"})
	if not f then
		minetest.remove_node(pos)
	return
	end
	-- Restart timer
	return true
end
flame_fire_node.on_construct = function(pos)
	if minetest.is_singleplayer() then
		minetest.get_node_timer(pos):start(math.random(30, 60))
	else
		minetest.get_node_timer(pos):start(math.random(10, 20))
	end
end
minetest.register_node("fire:basic_flame", flame_fire_node)

-- Permanent flame nodes
minetest.register_node("fire:permanent_flame", fire_node)

local tr = minetest.get_modpath("toolranks")

-- Flint and Steel
minetest.register_tool("fire:flint_and_steel", {
	description = S"Flint and Steel",
	inventory_image = "fire_flint_steel.png",
	sound = {breaks = "default_tool_breaks"},
	groups = {fire_source = 1},
	on_use = function(itemstack, user, pointed_thing)
		local sound_pos = pointed_thing.above or user:get_pos()
		minetest.sound_play("fire_flint_and_steel",
			{pos = sound_pos, gain = 0.5, max_hear_distance = 8})
		local player_name = user and user:get_player_name() or ""
		if pointed_thing.type == "node" then
			local node_under = minetest.get_node(pointed_thing.under).name
			local nodedef = minetest.registered_nodes[node_under]
			if not nodedef then
				return
			end
			if minetest.is_protected(pointed_thing.under, player_name) then
				minetest.chat_send_player(player_name, "This area is protected")
				return
			end
			if nodedef.on_ignite then
				nodedef.on_ignite(pointed_thing.under, user)
			elseif minetest.get_item_group(node_under, "flammable") >= 1
				and minetest.get_node(pointed_thing.above).name == "air" then
				minetest.set_node(pointed_thing.above, {name = "fire:basic_flame"})
			end
		end
		if not minetest.is_creative_enabled(player_name) then
			-- Wear tool
			local wdef = itemstack:get_definition()

			-- Toolranks support
			if tr then
				toolranks.new_afteruse(itemstack, user, nil, {wear = 1000})
			else
				itemstack:add_wear(1000)
			end

			-- Tool break sound
			if itemstack:get_count() == 0 and wdef.sound and wdef.sound.breaks then
				minetest.sound_play(wdef.sound.breaks, {pos = sound_pos, gain = 0.5})
			end
			return itemstack
		end
	end
})

minetest.register_craft({
	output = "fire:flint_and_steel",
	recipe = {
		{"default:flint", "default:steel_ingot"}
	}
})

-- Override coalblock to enable permanent flame above
-- Coalblock is non-flammable to avoid unwanted basic_flame nodes
minetest.override_item("default:coalblock", {
	after_destruct = function(pos)
		pos.y = pos.y + 1
		if minetest.get_node(pos).name == "fire:permanent_flame" then
			minetest.remove_node(pos)
		end
	end,
	on_ignite = function(pos)
		local flame_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
		if minetest.get_node(flame_pos).name == "air" then
			minetest.set_node(flame_pos, {name = "fire:permanent_flame"})
		end
	end
})


--
-- Sound
--

local flame_sound = minetest.settings:get_bool("flame_sound")
if flame_sound == nil then
	-- Enable if no setting present
	flame_sound = true
end

if flame_sound then
	local handles = {}

	-- Parameters
	local radius = 8 -- Flame node search radius around player
	local cycle = 3 -- Cycle time for sound updates

	-- Update sound for player
	function fire.update_player_sound(player)
		local player_name = player:get_player_name()
		-- Search for flame nodes in radius around player
		local ppos = player:get_pos()
		local areamin = vector.subtract(ppos, radius)
		local areamax = vector.add(ppos, radius)
		local fpos, num = minetest.find_nodes_in_area(
			areamin,
			areamax,
			{"fire:basic_flame", "fire:permanent_flame"}
		)
		-- Total number of flames in radius
		local flames = (num["fire:basic_flame"] or 0) +
			(num["fire:permanent_flame"] or 0)
		-- Stop previous sound
		if handles[player_name] then
			minetest.sound_stop(handles[player_name])
			handles[player_name] = nil
		end
		-- If flames
		if flames > 0 then
			-- Find centre of flame positions
			local fposmid = fpos[1]
			-- If more than 1 flame
			if #fpos > 1 then
				local fposmin = areamax
				local fposmax = areamin
				for i = 1, #fpos do
					local fposi = fpos[i]
					if fposi.x > fposmax.x then
						fposmax.x = fposi.x
					end
					if fposi.y > fposmax.y then
						fposmax.y = fposi.y
					end
					if fposi.z > fposmax.z then
						fposmax.z = fposi.z
					end
					if fposi.x < fposmin.x then
						fposmin.x = fposi.x
					end
					if fposi.y < fposmin.y then
						fposmin.y = fposi.y
					end
					if fposi.z < fposmin.z then
						fposmin.z = fposi.z
					end
				end
				fposmid = vector.divide(vector.add(fposmin, fposmax), 2)
			end
			-- Play sound
			local handle = minetest.sound_play("fire_fire", {
				pos = fposmid,
				to_player = player_name,
				gain = math.min(0.06 * (1 + flames * 0.125), 0.18),
				max_hear_distance = 32,
				loop = true -- In case of lag
			})
			-- Store sound handle for this player
			if handle then
				handles[player_name] = handle
			end
		end
	end

	-- Cycle for updating players sounds
	local cycles = {}
	minetest.register_playerstep(function(dtime, playernames)
		for _, name in pairs(playernames) do
			local player = minetest.get_player_by_name(name)
			if player and player:is_player() then
				cycles[name] = cycles[name] or 0
				cycles[name] = cycles[name] + dtime
				if cycles[name] >= cycle then
					fire.update_player_sound(player)
					cycles[name] = 0
				end
			end
		end
	end, true) -- We can force this since it is already rate-limited

	-- Stop sound and clear handle on player leave
	minetest.register_on_leaveplayer(function(player)
		local player_name = player:get_player_name()
		if handles[player_name] then
			minetest.sound_stop(handles[player_name])
			handles[player_name] = nil
			cycles[player_name] = nil
		end
	end)
end


--
-- ABMs
--

if minetest.is_singleplayer() then
	-- Ignite neighboring nodes, add basic flames
	minetest.register_abm({
		label = "Ignite flame",
		nodenames = {"group:flammable"},
		neighbors = {"group:igniter"},
		interval = 7,
		chance = 12,
		catch_up = false,
		action = function(pos)
			local p = minetest.find_node_near(pos, 1, {"air"})
			if p then
				minetest.set_node(p, {name = "fire:basic_flame"})
			end
		end
	})

	-- Remove flammable nodes around basic flame
	minetest.register_abm({
		label = "Remove flammable nodes",
		nodenames = {"fire:basic_flame"},
		neighbors = "group:flammable",
		interval = 5,
		chance = 18,
		catch_up = false,
		action = function(pos)
			local p = minetest.find_node_near(pos, 1, {"group:flammable"})
			if not p then
				return
			end
			local flammable_node = minetest.get_node(p)
			local def = minetest.registered_nodes[flammable_node.name]
			if def.on_burn then
				def.on_burn(p)
			else
				minetest.remove_node(p)
				minetest.add_particlespawner({
					amount = 3,
					time = 0.1,
					minpos = {x = p.x - 0.1, y = p.y + 0.1, z = p.z - 0.1},
					maxpos = {x = p.x + 0.1, y = p.y + 0.2, z = p.z + 0.1},
					minvel = {x = 0, y = 2.5, z = 0},
					maxvel = {x = 0, y = 2.5, z = 0},
					minacc = {x = -0.15, y = -0.02, z = -0.15},
					maxacc = {x = 0.15, y = -0.01, z = 0.15},
					minexptime = 4,
					maxexptime = 6,
					minsize = 2,
					maxsize = 4,
					texture = "item_smoke.png"
				})
				minetest.check_for_falling(p)
			end
		end
	})
end
