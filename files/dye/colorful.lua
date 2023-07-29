local S = dye.S

---GLASS---
local function register_glass(name, descrip)	
	minetest.register_node(":default:glass_" .. name, {
		description = descrip .. " " .. S"Glass",
		drawtype = "glasslike",
		tiles = {"glass_" .. name .. ".png"},
		paramtype = "light",
		paramtype2 = "glasslikeliquidlevel",
		sunlight_propagates = true,
		is_ground_content = false,
		use_texture_alpha = true,
		groups = {cracky = 3, oddly_breakable_by_hand = 3, colorglass = 1},
		sounds = default.node_sound_glass_defaults(),
		drop = ""
	})

	minetest.register_craft({
		type = "shapeless",
		output = "default:glass_" .. name,
		recipe = {"group:dye,color_" .. name, "default:glass"}
	})

	minetest.register_craft({
		type = "shapeless",
		output = "default:glass_" .. name,
		recipe = {"group:dye,color_" .. name, "group:colorglass"}
	})
end

register_glass("black", "Black3")
register_glass("blue", "Blue3")
register_glass("brown", "Brown3")
register_glass("cyan", "Cyan3")
register_glass("dark_green", "Dark Green3")
register_glass("dark_grey", "Dark Grey3")
register_glass("green", "Green3")
register_glass("grey", "Grey3")
register_glass("magenta", "Magenta3")
register_glass("orange", "Orange3")
register_glass("pink", "Pink3")
register_glass("red", "Red3")
register_glass("violet", "Violet3")
register_glass("white", "White3")
register_glass("yellow", "Yellow3")

---HARDENED CLAY---
local function register_clay(name, descrip)	
	minetest.register_node(":hardened_clay:" .. name, {
		description = descrip .. " " .. S"Hardened Clay",
		tiles = {"hardened_clay_stained_" .. name .. ".png"},
		is_ground_content = false,
		groups = {cracky = 3, hardened_clay = 1},
		sounds = default.node_sound_stone_defaults()
	})

	minetest.register_craft({
		output = "hardened_clay:" .. name .. " 8",
		recipe = {
			{"group:hardened_clay", "group:hardened_clay", "group:hardened_clay"},
			{"group:hardened_clay", "group:dye,color_" .. name, "group:hardened_clay"},
			{"group:hardened_clay", "group:hardened_clay", "group:hardened_clay"}
		}
	})
end

register_clay("black", "Black2")
register_clay("blue", "Blue2")
register_clay("brown", "Brown2")
register_clay("cyan", "Cyan2")
register_clay("dark_green", "Dark Green2")
register_clay("dark_grey", "Dark Grey2")
register_clay("green", "Green2")
register_clay("grey", "Grey2")
register_clay("magenta", "Magenta2")
register_clay("orange", "Orange2")
register_clay("pink", "Pink2")
register_clay("red", "Red2")
register_clay("violet", "Violet2")
register_clay("white", "White2")
register_clay("yellow", "Yellow2")

---WOOL---
local function register_wool(name, descrip)	
	minetest.register_node(":wool:" .. name, {
		description = descrip .. " " .. S"Wool",
		tiles = {"wool_" .. name .. ".png"},
		is_ground_content = false,
		groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
				flammable = 3, wool = 1},
		sounds = default.node_sound_wool_defaults()
	})

	minetest.register_craft({
		type = "shapeless",
		output = "wool:" .. name,
		recipe = {"group:dye,color_" .. name, "group:wool"}
	})
end

register_wool("black", "Black2")
register_wool("blue", "Blue2")
register_wool("brown", "Brown2")
register_wool("cyan", "Cyan2")
register_wool("dark_green", "Dark Green2")
register_wool("dark_grey", "Dark Grey2")
register_wool("green", "Green2")
register_wool("grey", "Grey2")
register_wool("magenta", "Magenta2")
register_wool("orange", "Orange2")
register_wool("pink", "Pink2")
register_wool("red", "Red2")
register_wool("violet", "Violet2")
register_wool("white", "White2")
register_wool("yellow", "Yellow2")

minetest.register_craft({
	type = "fuel",
	recipe = "group:wool",
	burntime = 4
})