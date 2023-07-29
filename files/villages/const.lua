--
-- switch for debugging
--
villages.debug = false
--
-- switch for lvm
villages.lvm = false
--
-- timer between creation of two villages
villages.min_timer = 120

villages.last_settlement = (os.time() - villages.min_timer) + 5

--
--
-- material to replace cobblestone with
--
wallmaterial = {
  "default:junglewood", 
  "default:pine_wood", 
  "default:wood", 
  "default:birch_wood", 
  "default:acacia_wood",   
  "default:stonebrick", 
  "default:cobble",  
  "default:redsandstone",
  "default:redsandstonesmooth",
  "default:sandstone"
}
villages.surface_mat = {}
-------------------------------------------------------------------------------
-- Set array to list
-- https://stackoverflow.com/questions/656199/search-for-an-item-in-a-lua-list
-------------------------------------------------------------------------------
function villages.grundstellungen ()
  villages.surface_mat = villages.Set {
    "default:dirt_with_grass",
    "default:dirt_with_snow",
    "default:dirt_with_dry_grass",
    "default:sand",
    "default:snow_block"
  }
end
--
-- possible surfaces where buildings can be built
--

--
-- path to schematics
--
schem_path = villages.modpath.."/schematics/"
--
-- list of schematics
--
schematic_table = { 
  {name = "townhall", mts = schem_path.."townhall.mts", hwidth = 10, hdepth = 11, hheight = 12, hsize = 15, max_num = 0, rplc = "n"},
  {name = "well", mts = schem_path.."well.mts", hwidth = 5, hdepth = 5, hheight = 13, hsize = 11, max_num = 0.045, rplc = "n"},
  {name = "hut", mts = schem_path.."hut.mts", hwidth = 7, hdepth = 7, hheight = 13, hsize = 11, max_num = 0.9, rplc = "y"},
  {name = "garden", mts = schem_path.."garden.mts", hwidth = 7, hdepth = 7, hheight = 13, hsize = 11, max_num = 0.1, rplc = "n"},
  {name = "lamp", mts = schem_path.."lamp.mts", hwidth = 3, hdepth = 3, hheight = 13, hsize = 10, max_num = 0.1, rplc = "n"},
  {name = "tower", mts = schem_path.."tower.mts", hwidth = 7, hdepth = 7, hheight = 13, hsize = 11, max_num = 0.055, rplc = "n"},
  {name = "blacksmith", mts = schem_path.."blacksmith.mts", hwidth = 7, hdepth = 7, hheight = 13, hsize = 11, max_num = 0.050, rplc = "n"},
}
--
-- temporary info for currentliy built settlement (position of each building) 
--
settlement_info = {}
--
-- list of villages, load on server start up
--
villages_in_world = {}
--
-- min_distance between villages
--
villages.min_dist_villages = 500
if villages.debug == true 
then
  min_dist_villages = 200
end
--
-- maximum allowed difference in height for building a sttlement
--
max_height_difference = 12
--
--
--
half_map_chunk_size = 40
quarter_map_chunk_size = 20
