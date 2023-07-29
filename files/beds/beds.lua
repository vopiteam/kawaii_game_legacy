beds.box = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5}

function beds.dyeing(pos, _, clicker, itemstack)
	local player_name = clicker:get_player_name()
	if minetest.is_protected(pos, player_name) then
		return false
	end

	local itemname = itemstack:get_name()
	if itemname:find("dye:") then
		minetest.swap_node(pos, {
			name = "beds:bed_" .. itemname:split(":")[2],
			param2 = minetest.get_node(pos).param2
		})

		if not minetest.is_creative_enabled(player_name) then
			itemstack:take_item()
		end

		return true
	else
		return false
	end
end

--Bed
beds.register_bed("beds:bed", {
	description = beds.S"Bed",
	inventory_image = "beds_bed_inv.png",
	wield_image = "beds_bed_inv.png",
	tiles = {"beds_bed.png", "wool_red.png"},
	mesh = "beds_bed.b3d",
	selectionbox = beds.box,
	collisionbox = beds.box,
	recipe = {	
		{"group:wool", "group:wool", "group:wool"},
		{"group:wood", "group:wood", "group:wood"}
	},

	on_rightclick = beds.dyeing
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:bed",
	burntime = 12
})

--Halloween Bed
beds.register_bed("beds:halloween_bed", {
	description = beds.S"Halloween Bed",
	inventory_image = "beds_halloween_bed_inv.png",
	wield_image = "beds_halloween_bed_inv.png",
	tiles = {"beds_halloween_bed.png", "wool_red.png"},
	mesh = "beds_bed.b3d",
	selectionbox = beds.box,
	collisionbox = beds.box,
	recipe = {
		{"", "mobs:piece_ghost", ""},
		{"group:wool", "group:wool", "group:wool"},
		{"group:wood", "group:wood", "group:wood"}
	},

	on_rightclick = beds.dyeing
})

minetest.register_alias("beds:bed_bottom", "beds:bed")
minetest.register_alias("beds:bed_top", "air")

local function register_colored_bed(name, descrip)	
	beds.register_bed("beds:bed_" .. name, {
		description = descrip .. " " .. beds.S"Bed",
		inventory_image = "beds_bed_inv.png",
		wield_image = "beds_bed_inv.png",
		tiles = {"beds_bed.png", "wool_" .. name .. ".png"},
		mesh = "beds_bed.b3d",
		selectionbox = beds.box,
		collisionbox = beds.box,
		groups = {not_in_creative_inventory = 1},
		recipe = {
			{"wool:" .. name, "wool:" .. name, "wool:" .. name},
			{"group:wood", "group:wood", "group:wood"}
		},

		on_rightclick = beds.dyeing
	})
end

register_colored_bed("black", "Black2")
register_colored_bed("blue", "Blue2")
register_colored_bed("brown", "Brown2")
register_colored_bed("cyan", "Cyan2")
register_colored_bed("dark_green", "Dark Green2")
register_colored_bed("dark_grey", "Dark Grey2")
register_colored_bed("green", "Green2")
register_colored_bed("grey", "Grey2")
register_colored_bed("magenta", "Magenta2")
register_colored_bed("orange", "Orange2")
register_colored_bed("pink", "Pink2")
register_colored_bed("red", "Red2")
register_colored_bed("violet", "Violet2")
register_colored_bed("white", "White2")
register_colored_bed("yellow", "Yellow2")
