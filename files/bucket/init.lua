local translator = minetest.get_translator
local S = translator and translator("bucket") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

minetest.register_craft({
	output = "bucket:bucket_empty",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"", "default:steel_ingot", ""}
	}
})

bucket = {}
bucket.liquids = {}

local singleplayer = minetest.is_singleplayer()

local function check_protection(pos, name, text)
	if minetest.is_protected_action(pos, name) then
		minetest.log("action", (name ~= "" and name or "A mod")
			.. " tried to " .. text
			.. " at protected position "
			.. minetest.pos_to_string(pos)
			.. " with a bucket")
		minetest.record_protection_violation(pos, name)
		return true
	end
	return false
end

-- Register a new liquid
--		source = name of the source node
--		flowing = name of the flowing node
--		itemname = name of the new bucket item (or nil if liquid is not takeable)
--		inventory_image = texture of the new bucket item (ignored if itemname == nil)
--		name = text description of the bucket item
--		groups = (optional) groups of the bucket item, for example {water_bucket = 1}
--		force_renew = (optional) bool. Force the liquid source to renew if it has a
--					source neighbour, even if defined as 'liquid_renewable = false'.
--					Needed to avoid creating holes in sloping rivers.
-- This function can be called from any mod (that depends on bucket).
function bucket.register_liquid(source, flowing, itemname, inventory_image, name,
		groups, force_renew)
	bucket.liquids[source] = {
		source = source,
		flowing = flowing,
		itemname = itemname,
		force_renew = force_renew
	}
	bucket.liquids[flowing] = bucket.liquids[source]

	if itemname ~= nil then
		minetest.register_craftitem(itemname, {
			description = S(name),
			inventory_image = inventory_image,
			stack_max = 1,
			liquids_pointable = true,
			groups = groups,

			on_place = function(itemstack, user, pointed_thing)
				-- Must be pointing to node
				if pointed_thing.type ~= "node" then
					return itemstack
				end

				local under = pointed_thing.under
				local node = minetest.get_node_or_nil(under)
				local ndef = node and minetest.registered_nodes[node.name]

				-- Call on_rightclick if the pointed node defines it
				if ndef and ndef.on_rightclick and
						not (user and user:is_player() and
						user:get_player_control().sneak) then
					return ndef.on_rightclick(under, node, user, itemstack,
						pointed_thing) or itemstack
				end

				local lpos

				-- Check if pointing to a buildable node
				if ndef and ndef.buildable_to then
					-- buildable; replace the node
					lpos = under
				else
					-- not buildable to; place the liquid above
					-- check if the node above can be replaced

					lpos = pointed_thing.above
					node = minetest.get_node_or_nil(lpos)
					local above_ndef = node and minetest.registered_nodes[node.name]

					if not above_ndef or not above_ndef.buildable_to then
						-- do not remove the bucket with the liquid
						return itemstack
					end
				end

				local pn = user and user:get_player_name() or ""

				local place_restriction = not singleplayer and
						not minetest.check_player_privs(pn, {server = true})

				if place_restriction then
					local height = under.y
					if height > 8 then
						if source == "default:lava_source" then
							minetest.chat_send_player(pn, S("Too much Lava is bad, right?"))
							return itemstack
						elseif height > 64 or
								minetest.get_node({x = lpos.x, y = lpos.y - 1, z = lpos.z}).name == "air" then
							minetest.chat_send_player(pn, S("Too much liquid is bad, right?"))
							return itemstack
						elseif source == "default:water_source" then
							source = "default:water_source_poured"
						elseif source == "default:river_water_source" then
							source = "default:river_water_source_poured"
						end
					end
				end

				if check_protection(lpos, pn, "place " .. source) then
					return itemstack
				end

				minetest.set_node(lpos, {name = source})
				if place_restriction
						or not minetest.is_creative_enabled(pn) then
					return ItemStack("bucket:bucket_empty")
				else
					return itemstack
				end
			end
		})
	end
end

minetest.register_craftitem("bucket:bucket_empty", {
	description = S("Empty Bucket"),
	inventory_image = "bucket.png",
	groups = {tool = 1},
	liquids_pointable = true,

	on_use = function(_, user, pointed_thing)
		if pointed_thing.type == "object" then
			pointed_thing.ref:right_click(user)
			return user:get_wielded_item()
		elseif pointed_thing.type ~= "node" then
			-- do nothing if it's neither object nor node
			return
		end

		local under = pointed_thing.under

		-- Check if pointing to a liquid source
		local node = minetest.get_node(under)
		local liquiddef = bucket.liquids[node.name]
		local item_count = user:get_wielded_item():get_count()

		if liquiddef ~= nil
		and liquiddef.itemname ~= nil
		and node.name == liquiddef.source then
			if check_protection(under, user:get_player_name(),
					"take " .. node.name) then
				return
			end

			-- default set to return filled bucket
			local giving_back = liquiddef.itemname

			-- check if holding more than 1 empty bucket
			if item_count > 1 then
				-- if space in inventory add filled bucked, otherwise drop as item
				local inv = user:get_inventory()
				if inv:room_for_item("main", {name = liquiddef.itemname}) then
					inv:add_item("main", liquiddef.itemname)
				else
					local pos = user:get_pos()
					pos.y = math.floor(pos.y + 0.5)
					minetest.add_item(pos, liquiddef.itemname)
				end

				-- set to return empty buckets minus 1
				giving_back = "bucket:bucket_empty " .. tostring(item_count - 1)
			end

			-- force_renew requires a source neighbour
			local source_neighbor = false
			if liquiddef.force_renew then
				source_neighbor =
					minetest.find_node_near(under, 1, liquiddef.source)
			end
			if not (source_neighbor and liquiddef.force_renew) then
				minetest.add_node(under, {name = "air"})
			end

			return ItemStack(giving_back)
		else
			-- non-liquid nodes will have their on_punch triggered
			local node_def = minetest.registered_nodes[node.name]
			if node_def then
				node_def.on_punch(under, node, user, pointed_thing)
			end
			return user:get_wielded_item()
		end
	end
})

bucket.register_liquid(
	"default:water_source",
	"default:water_flowing",
	"bucket:bucket_water",
	"bucket.png^bucket_water.png",
	"Water Bucket",
	{water_bucket = 1}
)

bucket.register_liquid(
	"default:water_source",
	"default:water_flowing",
	"bucket:bucket_water",
	"bucket.png^bucket_water.png",
	"Water Bucket",
	{water_bucket = 1}
)

-- Poured water for multiplayer
bucket.liquids["default:water_source_poured"] = {
	source = "default:water_source_poured",
	itemname = "bucket:bucket_water"
}

-- River water source is 'liquid_renewable = false' to avoid horizontal spread
-- of water sources in sloping rivers that can cause water to overflow
-- riverbanks and cause floods.
-- River water source is instead made renewable by the 'force renew' option
-- used here.

bucket.register_liquid(
	"default:river_water_source",
	"default:river_water_flowing",
	"bucket:bucket_river_water",
	"bucket.png^bucket_river_water.png",
	"River Water Bucket",
	{water_bucket = 1},
	true
)

-- Poured river water for multiplayer
bucket.liquids["default:river_water_source_poured"] = {
	source = "default:river_water_source_poured",
	itemname = "bucket:bucket_river_water"
}

bucket.register_liquid(
	"default:lava_source",
	"default:lava_flowing",
	"bucket:bucket_lava",
	"bucket.png^bucket_lava.png",
	"Lava Bucket"
)

-- Milk Bucket
minetest.register_craftitem("bucket:bucket_milk", {
	description = S"Milk Bucket",
	inventory_image = "bucket.png^bucket_milk.png",
	stack_max = 1,
	on_use = minetest.item_eat(8, "bucket:bucket_empty"),
	groups = {food_milk = 1, food = 1}
})

minetest.register_alias("mobs:bucket_milk", "bucket:bucket_milk")

minetest.register_craft({
	type = "fuel",
	recipe = "bucket:bucket_lava",
	burntime = 60,
	replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}}
})
