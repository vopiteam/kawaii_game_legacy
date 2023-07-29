local translator = minetest.get_translator
local S = translator and translator("homedecor_exterior") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

--
-- Formspecs
--

local function get_barbecue_active_formspec(fuel_percent, item_percent)
	return default.gui ..
		"image[-0.23,-0.26;9,1;formspec_barbecue_icon.png]" ..
		"item_image[3,0.75;1,1;default:cell]" ..
		"list[context;src;3,0.75;1,1;]" ..
		"item_image[3,2.75;1,1;default:cell]" ..
		"list[context;fuel;3,2.75;1,1;]" ..
		"image[3,1.75;1,1;default_furnace_fire_bg.png^[lowpart:" ..
		fuel_percent .. ":default_furnace_fire_fg.png]" ..
		"image[4,1.75;1,1;default_arrow_bg.png^[lowpart:" ..
		item_percent ..":default_arrow_fg.png^[transformR270]" ..
		"item_image[4.925,1.675;1.2,1.2;default:cell]" ..
		"list[context;dst;5,1.75;1,1;]" ..
		"list[context;split;8,3.14;1,1;]"
end

local function get_barbecue_inactive_formspec()
	return default.gui ..
		"image[-0.23,-0.26;9,1;formspec_barbecue_icon.png]" ..
		"item_image[3,0.75;1,1;default:cell]" ..
		"list[context;src;3,0.75;1,1;]" ..
		"item_image[3,2.75;1,1;default:cell]" ..
		"list[context;fuel;3,2.75;1,1;]" ..
		"image[3,1.75;1,1;default_furnace_fire_bg.png]" ..
		"image[4,1.75;1,1;default_arrow_bg.png^[transformR270]" ..
		"item_image[4.925,1.675;1.2,1.2;default:cell]" ..
		"list[context;dst;5,1.75;1,1;]" ..
		"list[context;split;8,3.14;1,1;]"
end

--
-- Node callback functions that are the same for active and inactive furnace
--

local function can_dig(pos, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return false
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	for _, name in pairs({"fuel", "dst", "src"}) do
		local stack = inv:get_stack(name, 1)
		minetest.item_drop(stack, nil, pos)
		inv:set_stack(name, 1, nil)
	end
	return true
end

local function allow_metadata_inventory_put(pos, listname, _, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "fuel" then
		if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
			if inv:is_empty("src") then
				meta:set_string("infotext", Sl("Furnace is empty"))
			end
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "src" then
		if minetest.get_craft_result({method="cooking", width=1, items={stack}}).time ~= 0 then
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "dst" then
		return 0
	elseif listname == "split" then
		return stack:get_count() / 2
	end
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, _, player)
	if to_list == "split" then
		return 1
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function allow_metadata_inventory_take(pos, _, _, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end

local function barbecue_node_timer(pos, elapsed)
	--
	-- Initialize metadata
	--
	local meta = minetest.get_meta(pos)
	local fuel_time = meta:get_float("fuel_time") or 0
	local src_time = meta:get_float("src_time") or 0
	local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

	local inv = meta:get_inventory()
	local srclist, fuellist
	local dst_full = false

	local cookable, cooked
	local fuel

	local update = true
	while elapsed > 0 and update do
		update = false

		srclist = inv:get_list("src")
		fuellist = inv:get_list("fuel")

		--
		-- Cooking
		--

		-- Check if we have cookable content
		local aftercooked
		cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		cookable = cooked.time ~= 0

		local el = math.min(elapsed, fuel_totaltime - fuel_time)
		if cookable then -- fuel lasts long enough, adjust el to cooking duration
			el = math.min(el, cooked.time - src_time)
		end

		-- Check if we have enough fuel to burn
		if fuel_time < fuel_totaltime then
			-- The furnace is currently active and has enough fuel
			fuel_time = fuel_time + el
			-- If there is a cookable item then check if it is ready yet
			if cookable then
				src_time = src_time + el
				if src_time >= cooked.time then
					-- Place result in dst list if possible
					if inv:room_for_item("dst", cooked.item) then
						inv:add_item("dst", cooked.item)
						inv:set_stack("src", 1, aftercooked.items[1])
						src_time = src_time - cooked.time
						update = true
					else
						dst_full = true
					end
				else
					-- Item could not be cooked: probably missing fuel
					update = true
				end
			end
		else
			-- Furnace ran out of fuel
			if cookable then
				-- We need to get new fuel
				local afterfuel
				fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})

				if fuel.time == 0 then
					-- No valid fuel in fuel list
					fuel_totaltime = 0
					src_time = 0
				else
					-- Take fuel from fuel list
					inv:set_stack("fuel", 1, afterfuel.items[1])
					-- Put replacements in dst list or drop them on the furnace.
					local replacements = fuel.replacements
					if replacements[1] then
						local leftover = inv:add_item("dst", replacements[1])
						if not leftover:is_empty() then
							local above = vector.new(pos.x, pos.y + 1, pos.z)
							local drop_pos = minetest.find_node_near(above, 1, {"air"}) or above
							minetest.item_drop(replacements[1], nil, drop_pos)
						end
					end
					update = true
					fuel_totaltime = fuel.time + (fuel_totaltime - fuel_time)
				end
			else
				-- We don't need to get new fuel since there is no cookable item
				fuel_totaltime = 0
				src_time = 0
			end
			fuel_time = 0
		end

		elapsed = elapsed - el
	end

	if fuel and fuel_totaltime > fuel.time then
		fuel_totaltime = fuel.time
	end
	if srclist and srclist[1]:is_empty() then
		src_time = 0
		end

	--
	-- Update formspec, infotext and node
	--
	local formspec
	local item_state
	local item_percent = 0
	if cookable then
		item_percent = math.floor(src_time / cooked.time * 100)
		if dst_full then
			item_state = "100% " .. S("output full")
		else
			item_state = item_percent .. "%"
		end
	else
		if srclist and not srclist[1]:is_empty() then
			item_state = S("Not cookable")
		else
			item_state = S("Empty")
		end
	end

	local fuel_state = S("Empty")
	local active = false
	local result = false

	if fuel_totaltime ~= 0 then
		active = true
		local fuel_percent = 100 - math.floor(fuel_time / fuel_totaltime * 100)
		fuel_state = fuel_percent .. "%"
		formspec = get_barbecue_active_formspec(fuel_percent, item_percent)
		swap_node(pos, "homedecor:barbecue_active")
		-- make sure timer restarts automatically
		result = true
	else
		if fuellist and not fuellist[1]:is_empty() then
			fuel_state = "0%"
		end
		formspec = get_barbecue_inactive_formspec()
		swap_node(pos, "homedecor:barbecue")
		-- stop timer on the inactive furnace
		minetest.get_node_timer(pos):stop()
	end

	local infotext
	if active then
		infotext = S("Barbecue active")
	else
		infotext = S("Barbecue inactive")
	end
	infotext = infotext .. "\n" ..  S("Item: @1; Fuel: @2", item_state, fuel_state)

		--
		-- Set meta values
		--
		meta:set_float("fuel_totaltime", fuel_totaltime)
		meta:set_float("fuel_time", fuel_time)
		meta:set_float("src_time", src_time)
		meta:set_string("formspec", formspec)
		meta:set_string("infotext", infotext)

	return result
end

--
-- Node definitions
--

local bbq_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.3125, 0.5, 0.53125, 0.3125 }
}

homedecor.register("barbecue", {
	description = S("Barbecue"),
	mesh = "homedecor_barbecue.obj",
	tiles = {
		{ name = "basic_materials_chain_brass.png"},
		{ name = "homedecor_embers.png",
			animation={
				type="vertical_frames",
				aspect_w=16,
				aspect_h=16,
				length=2
			}
		},
		"homedecor_barbecue_meat.png",
	},
	groups = { snappy=3 },
	light_source = 9,
	selection_box = bbq_cbox,
	collision_box = bbq_cbox,
	sounds = default.node_sound_stone_defaults(),
	-- no need for placeholder it appears
	expand = { top="air" }, 
	can_dig = can_dig,

	on_timer = barbecue_node_timer,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
		inv:set_size("fuel", 1)
		inv:set_size("dst", 1)
		inv:set_size("split", 1)
		barbecue_node_timer(pos, 0)
	end,

	on_metadata_inventory_move = function(pos)
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_metadata_inventory_put = function(pos)
		-- start timer function, it will sort out whether furnace can burn or not.
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "src", drops)
		default.get_inventory_drops(pos, "fuel", drops)
		default.get_inventory_drops(pos, "dst", drops)
		drops[#drops+1] = "homedecor:barbecue"
		minetest.remove_node(pos)
		return drops
	end,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take	
})

homedecor.register("barbecue_active", {
	mesh = "homedecor_barbecue.obj",
	tiles = {
		{ name = "basic_materials_chain_brass.png"},
		{ name = "homedecor_embers.png",
			animation={
				type="vertical_frames",
				aspect_w=16,
				aspect_h=16,
				length=2
			}
		},
		"homedecor_barbecue_meat.png",
	},
	groups = { snappy=3 },
	light_source = 9,
	selection_box = bbq_cbox,
	collision_box = bbq_cbox,
	sounds = default.node_sound_stone_defaults(),
	-- no need for placeholder it appears
	expand = { top="air" }, 
	
	drop = "homedecor:barbecue",
	
	on_timer = barbecue_node_timer,

	can_dig = can_dig,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take
})

minetest.register_craft({
	output = "homedecor:barbecue",
	recipe = {
		{ "","basic_materials:steel_bar","" },
		{ "basic_materials:brass_ingot","default:coal_lump","basic_materials:brass_ingot" },
		{ "basic_materials:steel_bar","default:steel_ingot","basic_materials:steel_bar" }
	}
})