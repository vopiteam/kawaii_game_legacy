mobs_trader = {}

local S = mobs_npc.S
local b = "blank.png"
local ver = 4

mobs:register_mob("mobs_npc:trader", {
	type = "npc",
	damage = 1,
	attacks_monsters = true,
	hp_min = 15,
	hp_max = 20,
	collisionbox = {-0.35, -1.0, -0.35, 0.35, 0.8, 0.35},
	visual = "mesh",
	mesh = "mobs_npc.b3d",
	textures = {
		{"mobs_trader.png^mobs_trader1.png", b, b},
		{"mobs_trader.png^mobs_trader2.png", b, b},
		{"mobs_trader.png^mobs_trader3.png", b, b}
	},
	makes_footstep_sound = true,
	sounds = {},
	walk_velocity = 2,
	run_velocity = 2,
	jump = false,
	drops = {},
	lava_damage = 3,
	order = "stand",
	fear_height = 3,
	animation = {
		speed_normal = 30,	speed_run = 30,
		stand_start = 0,	stand_end = 79,
		walk_start = 168,	walk_end = 187, walk_speed = 15,
		run_start = 168,	run_end = 187,
		punch_start = 189,	punch_end = 198
	},

	on_punch = function(self, clicker)
		mobs_trader.trader_show_goods(self, clicker, mobs_trader.human)
	end,

	on_rightclick = function(self, clicker)
		mobs_trader.trader_show_goods(self, clicker, mobs_trader.human)
	end,

	on_spawn = function(self)
		self.nametag = S"Trader"
		self.object:set_properties({
			nametag = self.nametag,
			nametag_color = "#FFFFFF"
		})
		return true -- return true so on_spawn is run once only
	end,

	after_activate = function(self)
		if mobs_npc.replace_model(self) then
			return
		end

		if not self.game_name then
			self.object:set_properties({
				nametag_color = "#FFFFFF"
			})
		end
	end
})

-- This code comes almost exclusively from the trader and inventory of mobf, by Sapier.
-- The copyright notice below is from mobf:
-------------------------------------------------------------------------------
-- Mob Framework Mod by Sapier
--
-- You may copy, use, modify or do nearly anything except removing this
-- copyright notice.
-- And of course you are NOT allow to pretend you have written it.
--
--! @file inventory.lua
--! @brief component containing mob inventory related functions
--! @copyright Sapier
--! @author Sapier
--! @date 2013-01-02
--
--! @defgroup Inventory Inventory subcomponent
--! @brief Component handling mob inventory
--! @ingroup framework_int
--! @{
--
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------

-- This code has been heavily modified by isaiah658.
-- Trades are saved in entity metadata so they always stay the same after
-- initially being chosen. Also the formspec uses item image buttons instead of
-- inventory slots.

-- Define tabe containing names for use and shop items for sale
mobs_trader.human = {
	names = {
		"Bill", "Clark", "Donald", "Duncan", "Dylan", "Ethan", "Gower",
		"James", "Lenny", "Ralph", "Rodman", "Scott", "Tom", "Winslow"
	},

	-- Item for sale, price, chance of appearing in trader's inventory
	items = {
		{"mobs:nametag 1", "default:emerald 1", 10},
		{"farming:bread 8", "default:emerald 2", 5},
		{"default:clay 8", "default:emerald 1", 10},
		{"default:brick 8", "default:emerald 2", 15},
		{"carts:cart 1", "default:gold_ingot 2", 16},
		{"boats:boat 1", "default:gold_ingot 1", 15},
		{"default:diamond 1", "default:emerald 2", 30},
		{"farming:wheat 8", "default:emerald 2", 17},
		{"default:tree 16", "default:gold_ingot 2", 15},
		{"pep:speedplus 1", "default:gold_ingot 2", 20},
		{"pep:jumpplus 1", "default:gold_ingot 2", 20},
		{"default:birch_sapling 3", "default:gold_ingot 2", 20},
		{"default:stone 16", "default:emerald 1", 17},
		{"watch:0 1", "default:emerald 1", 7},
		{"default:fish 1", "default:emerald 2", 20},
		{"default:sword_gold 1", "default:emerald 1", 17},
		{"bucket:bucket_lava 1", "default:emerald 1", 15},
		{"default:quartz_crystal 8", "default:emerald 1", 17},
		{"farming:hoe_ruby 1", "default:emerald 1", 17},
		{"default:cactus 4", "default:emerald 2", 35},
		{"default:sugarcane 4", "default:emerald 2", 35},
		{"default:ruby 1", "default:emerald 4", 20},
		{"default:ruby 2", "default:emerald 7", 20},
		{"default:ruby 1", "default:diamond 5", 30},
		{"default:ruby 2", "default:diamond 9", 30},
		{"default:obsidian 32", "default:emerald 1", 30},
		{"default:emerald 1", "default:obsidian 64", 45},
		{"farming_addons:carrot_golden 2", "default:diamond 1", 25},
		{"farming_addons:seed_melon 1", "default:diamond 1", 25},
		{"farming_addons:seed_pumpkin 1", "default:diamond 1", 25},
		{"farming_plants:seed_melon 1", "default:diamond 1", 25},
		{"farming_addons:potato 1", "default:gold_ingot 2", 20},
		{"3d_armor:helmet_chain 1", "default:goldblock 4", 40},
		{"3d_armor:chestplate_chain 1", "default:ruby 4", 40},
		{"3d_armor:leggings_chain 1", "default:emerald 4", 40},
		{"3d_armor:boots_chain 1", "default:diamond 4", 40}
	}
}

local random = math.random

function mobs_trader.trader_add_goods(self, race)
	local trade_index = 1
	local trades_already_added = {}
	local trader_pool_size = 6
	local item_pool_size = #race.items -- get number of items on list

	local trades = {}
	if item_pool_size < trader_pool_size then
		trader_pool_size = item_pool_size
	end

	for i = 1, trader_pool_size do
		-- If there are more trades than the amount being added, they are
		-- randomly selected. If they are equal, there is no reason to randomly
		-- select them
		local random_trade

		if item_pool_size == trader_pool_size then
			random_trade = i
		else
			while random_trade == nil do
				local num = random(item_pool_size)

				if trades_already_added[num] == nil then
					trades_already_added[num] = true
					random_trade = num
				end
			end
		end

		if random(100) > race.items[random_trade][3] then
			trades[trade_index] = {
				race.items[random_trade][1],
				race.items[random_trade][2]
			}

			trade_index = trade_index + 1
		end
	end

	self.trades = trades
	self.version = ver
end

function mobs_trader.trader_show_goods(self, clicker, race)
	if not self.id then
		self.id = (random(1000) * random(10000))
				.. self.name .. (random(1000) ^ 2)
	end
	local id = self.id

	if not self.game_name then
		self.game_name = S(race.names[random(#race.names)])
		self.nametag = S("Trader @1", self.game_name)
		self.object:set_properties({
			nametag = self.nametag,
			nametag_color = "#00FF00"
		})
	end
	local game_name = self.game_name

	local version = self.version
	local trades = self.trades

	if trades == nil or not version or version < ver then
		mobs_trader.trader_add_goods(self, race)
		trades = self.trades
	end

	local player = clicker and clicker:get_player_name() or ""
	minetest.chat_send_player(player,
		S("<[NPC] Trader @1> Hello @2, have a look at my wares.",
			game_name, S(player)))

	-- Make formspec trade list
	local formspec_trade_list = ""
	local x, y

	for i = 1, 6 do
		if trades[i] and trades[i] ~= "" then
			if i < 4 then
				x = 1
				y = i - 0.2
			else
				x = 5
				y = i - 3.2
			end

			local name_prices = trades[i][2]:match("%S*")
			local amount_prices = trades[i][2]:match("%d")
			local itemdef_prices = minetest.registered_items[name_prices]
			local tooltip_prices =
					(itemdef_prices and itemdef_prices.description or "") .. " " ..
					(amount_prices and amount_prices ~= "1" and amount_prices or "")

			local name_goods = trades[i][1]:match("%S*")
			local amount_goods = trades[i][1]:match("%d")
			local itemdef_goods = minetest.registered_items[name_goods]
			local tooltip_goods =
					(itemdef_goods and itemdef_goods.description or "") .. " " ..
					(amount_goods and amount_goods ~= "1" and amount_goods or "")

			formspec_trade_list = formspec_trade_list ..
					"item_image[" .. x .. "," .. y .. ";1,1;" .. trades[i][2] .. "]" ..
					"image_button[" .. x .. "," .. y .. ";1,1;formspec_cell.png;prices#" .. i .. "#" .. id ..
						";;;false;formspec_cell.png^formspec_item_pressed.png]" ..
					"tooltip[prices#" .. i .. "#" .. id .. ";" .. tooltip_prices .. "]" ..
					"image[".. x + 1 ..",".. y ..";1,1;default_arrow_bg.png^[transformR270]" ..
					"item_image[" .. x + 2 .. "," .. y .. ";1,1;" .. trades[i][1] .. "]" ..
					"image_button[" .. x + 2 .. "," .. y .. ";1,1;formspec_cell.png;goods#" .. i .. "#" .. id ..
						";;;false;formspec_cell.png^formspec_item_pressed.png]" ..
					"tooltip[goods#" .. i .. "#" .. id .. ";" .. tooltip_goods .. "]"
		end
	end

	minetest.show_formspec(player, "mobs_npc:trade",
		default.gui ..
		"item_image[0,-0.1;1,1;default:emerald]" ..
		"label[0.9,0.1;" .. S("Trader @1's stock", game_name) .. "]" ..
		"image[7.95,3.1;1.1,1.1;^[colorize:#fcb5d1]]" ..
		formspec_trade_list)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "mobs_npc:trade" then return end

	if fields then
		local trade = ""
		for k, _ in pairs(fields) do
			trade = tostring(k)
		end

		local id = trade:split("#")[3]
		local self

		if id ~= nil then
			for _, v in pairs(minetest.luaentities) do
				if v.object and v.id and v.id == id then
					self = v
					break
				end
			end
		end

		if self ~= nil then
			local trade_number = tonumber(trade:split("#")[2])

			if trade_number ~= nil and self.trades[trade_number] ~= nil then
				local price = self.trades[trade_number][2]
				local goods = self.trades[trade_number][1]
				local inv = player:get_inventory()

				if inv:contains_item("main", price) then
					inv:remove_item("main", price)
					local leftover = inv:add_item("main", goods)

					if leftover:get_count() > 0 then
						-- Drop items in front of player
						local droppos = player:get_pos()
						local dir = player:get_look_dir()

						droppos.x = droppos.x + dir.x
						droppos.z = droppos.z + dir.z

						minetest.add_item(droppos, leftover)
					end
				end
			end
		end
	end
end)

mobs:register_egg("mobs_npc:trader", S"Trader", "mobs_trader_egg.png")
