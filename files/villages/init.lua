-- eclipse debugging lines
--require("debugger")(idehost, ideport, idekey)

--zerobrane debugging lines
--package.cpath = package.cpath .. ";/usr/share/lua/5.2/?.so"
--package.path = package.path .. ";/usr/share/zbstudio/lualibs/mobdebug/?.lua"
--require('mobdebug').start()

villages = {}
villages.modpath = minetest.get_modpath("villages");

vm, data, va, emin, emax = 1

dofile(villages.modpath.."/const.lua")
dofile(villages.modpath.."/utils.lua")
dofile(villages.modpath.."/foundation.lua")
dofile(villages.modpath.."/buildings.lua")
dofile(villages.modpath.."/paths.lua")
dofile(villages.modpath.."/convert_lua_mts.lua")
--
-- load villages on server
--
villages_in_world = villages.load()
villages.grundstellungen()
--
-- register block for npc spawn
--
minetest.register_node("villages:junglewood", {
    description = "special junglewood floor",
    tiles = {"default_junglewood.png"},
    groups = {choppy=3, wood=2, not_in_creative_inventory = 1},
    sounds = default.node_sound_wood_defaults(),
    drop = "default:junglewood",
	sounds = default.node_sound_wood_defaults()
})
  
minetest.register_node("villages:cobble", {
	description = "special cobble floor",
    tiles = {"default_cobble.png"},
    groups = {cracky = 3, stone = 2, not_in_creative_inventory = 1},
    sounds = default.node_sound_wood_defaults(),
    drop = "default:cobble",
	sounds = default.node_sound_stone_defaults()
})
--
-- register inhabitants
--
minetest.register_abm({
	label = "mobs_npc: NPC spawner",
	nodenames = {"villages:junglewood"},
	interval = 15,
	chance = 5,
	catch_up = false,
	action = function(pos)
		local npc_objs = minetest.get_objects_inside_radius(pos, 16)
		for _, obj in pairs(npc_objs) do
			local ent = obj:get_luaentity()
			if ent and ent.name and
			(ent.name == "mobs_npc:npc_man" or
			 ent.name == "mobs_npc:npc_woman") then
				return
			end
		end

		local npc_area = minetest.find_nodes_in_area(
			{x = pos.x - 1, y = pos.y + 1, z = pos.z - 1},
			{x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, "air")

		if npc_area and #npc_area > 1 then
			local npc_pos_man = npc_area[math.random(#npc_area)]
			npc_pos_man.y = npc_pos_man.y + 0.5
			minetest.add_entity(npc_pos_man, "mobs_npc:npc_man")
			local npc_pos_woman = npc_area[math.random(#npc_area)]
			npc_pos_woman.y = npc_pos_woman.y + 0.5
			minetest.add_entity(npc_pos_woman, "mobs_npc:npc_woman")
			minetest.swap_node(pos, {name = "default:junglewood"})
		end
	end
})

-- Spawn Trader
minetest.register_abm({
	label = "mobs_npc: Trader spawner",
	nodenames = {"villages:cobble"},
	interval = 15,
	chance = 5,
	catch_up = false,
	action = function(pos)
		local trader_objs = minetest.get_objects_inside_radius(pos, 32)
		for _, obj in pairs(trader_objs) do
			local ent = obj:get_luaentity()
			if ent and ent.name and ent.name == "mobs_npc:trader" then
				return
			end
		end

		local trader_area = minetest.find_nodes_in_area(
			{x = pos.x - 8, y = pos.y, z = pos.z - 8},
			{x = pos.x + 8, y = pos.y + 1, z = pos.z + 8}, "air")

		if trader_area and #trader_area > 0 then
			local trader_pos = trader_area[math.random(#trader_area)]
			trader_pos.y = trader_pos.y + 0.5
			minetest.add_entity(trader_pos, "mobs_npc:trader")
			minetest.swap_node(pos, {name = "default:cobble"})
		end
	end
})
--
-- on map generation, try to build a settlement
--
minetest.register_on_generated(function(minp, maxp)
    --
    -- needed for manual and automated settlement building
    --
    heightmap = minetest.get_mapgen_object("heightmap")
    --
    -- randomly try to build villages
    -- 
    if math.random(2) == 1 then 
      --
      -- time between creation of two villages
      --
      if os.difftime(os.time(), villages.last_settlement) < villages.min_timer then
        return
      end
	  -- if villages.debug == true then
	  -- minetest.chat_send_all("Last opportunity ".. os.difftime(os.time(), villages.last_settlement))
	  -- end
      --
      -- don't build settlement underground
      --
      if maxp.y < 0 then 
        return 
      end
      --
      -- don't build villages too close to each other
      --
      local center_of_chunk = { 
        x=maxp.x-half_map_chunk_size, 
        y=maxp.y-half_map_chunk_size, 
        z=maxp.z-half_map_chunk_size
      } 
      local dist_ok = villages.check_distance_other_villages(center_of_chunk)
      if dist_ok == false then
        return
      end
      --
      -- don't build villages on (too) uneven terrain
      --
      local height_difference = villages.evaluate_heightmap(minp, maxp)
      if height_difference == nil then return end
      if height_difference > max_height_difference then
        return
      end
      -- 
      -- if no hard showstoppers prevent the settlement -> try to do it (check for suitable terrain)
      
      -- waiting necessary for chunk to load, otherwise, townhall is not in the middle, no map found behind townhall
      minetest.after(2, function()
          --
          -- fill settlement_info with buildings and their data
          --
          suitable_place_found = false
          if villages.lvm == true then
            vm, data, va, emin, emax = villages.getlvm(minp, maxp)
            suitable_place_found = villages.create_site_plan_lvm(maxp, minp)
          else
            suitable_place_found = villages.create_site_plan(maxp, minp)
          end
          
          if not suitable_place_found then
            return
          end
          
          --
     	  -- set timestamp of actual settlement
     	  --
          villages.last_settlement = os.time()
          --
          -- evaluate settlement_info and prepair terrain
          --
          if villages.lvm == true then
            villages.terraform_lvm()
          else
            villages.terraform()
          end

          --
          -- evaluate settlement_info and build paths between buildings
          --
          if villages.lvm == true then
            villages.paths_lvm(minp)
          else
          	minetest.chat_send_all("NO paths")
            villages.paths()
          end
          --
          -- evaluate settlement_info and place schematics
          --
          if villages.lvm == true then
            vm:set_data(data)
            villages.place_schematics_lvm()
            vm:write_to_map(true)
          else
            villages.place_schematics()
          end
          --
          -- evaluate settlement_info and initialize furnaces and chests
          --
          villages.initialize_nodes()
          
        end)
    end
end)
--
-- manually place buildings, for debugging only
--
if villages.debug then
	minetest.register_craftitem("villages:tool", {
    	description = "villages build tool",
    	inventory_image = "default_tool_woodshovel.png",
    	--
    	-- build single house
    	--
    	on_use = function(itemstack, placer, pointed_thing)
      local center_surface = pointed_thing.under
      if center_surface then
        local building_all_info = {name = "blacksmith", 
          mts = schem_path.."blacksmith.mts", 
          hsize = 13, 
          max_num = 0.9, 
          rplc = "n"}
        villages.build_schematic(center_surface, 
          building_all_info["mts"],
          building_all_info["rplc"], 
          building_all_info["name"])

--        villages.convert_mts_to_lua()
--        villages.mts_save()
      end
    end,
    	--
    	-- build ssettlement
    	--
    	on_place = function(itemstack, placer, pointed_thing)
      -- enable debug routines
      villages.debug = true
      local center_surface = pointed_thing.under
      if center_surface then
        local minp = {
          x=center_surface.x-half_map_chunk_size, 
          y=center_surface.y-half_map_chunk_size, 
          z=center_surface.z-half_map_chunk_size
        }
        local maxp = {
          x=center_surface.x+half_map_chunk_size, 
          y=center_surface.y+half_map_chunk_size, 
          z=center_surface.z+half_map_chunk_size
        }
        --
        -- get LVM of current chunk
        --
        vm, data, va, emin, emax = villages.getlvm(minp, maxp)
        --
        -- fill settlement_info with buildings and their data
        --
        local start_time = os.time()
        if villages.lvm == true then
        	suitable_place_found = villages.create_site_plan_lvm(maxp, minp)
        else
        	suitable_place_found = villages.create_site_plan(maxp, minp)
        end
        if not suitable_place_found
        then
        	return
        end
        --
        -- evaluate settlement_info and prepair terrain
        --
        if villages.lvm == true then
        	villages.terraform_lvm()
        else
        	villages.terraform()
        end

        --
        -- evaluate settlement_info and build paths between buildings
        --
        if villages.lvm == true
        then
          villages.paths_lvm(minp)
        else
          villages.paths()
        end
        --
        -- evaluate settlement_info and place schematics
        --
        if villages.lvm == true
        then
          vm:set_data(data)
          villages.place_schematics_lvm()
          vm:write_to_map(true)
        else
          villages.place_schematics()
        end

        --
        -- evaluate settlement_info and initialize furnaces and chests
        --
        villages.initialize_nodes()
        local end_time = os.time()
        minetest.chat_send_all("Zeit ".. end_time - start_time)
--
        --villages.convert_mts_to_lua()
        --villages.mts_save()

      end
    end
  	})
end

