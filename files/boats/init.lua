local translator = minetest.get_translator
local S = translator and translator("boats") or intllib.make_gettext_pair()

if translator and not minetest.is_singleplayer() then
	local lang = minetest.settings:get("language")
	if lang and lang == "ru" then
		S = intllib.make_gettext_pair()
	end
end

--
-- Helper functions
--

local function is_water(pos, nodename)
	local nn = nodename or minetest.get_node(pos).name
	return minetest.get_item_group(nn, "water") ~= 0, nn
end


local function get_velocity(v, yaw, y)
	local x = -math.sin(yaw) * v
	local z =  math.cos(yaw) * v
	return {x = x, y = y, z = z}
end


local function get_v(v)
	return math.sqrt(v.x ^ 2 + v.z ^ 2)
end

--
-- Boat entity
--

local boat = {
	initial_properties = {
		physical = true,
		collisionbox = {-0.6, -0.4, -0.6, 0.6, 0.3, 0.6},
		visual = "mesh",
		mesh = "boats_boat.b3d",
		textures = {"default_acacia_wood.png"}
	},
	driver = nil,
	v = 0,
	last_v = 0,
	removed = false,
	auto = false
}


local aheight = 11
if minetest.features and minetest.features.object_independent_selectionbox then
	aheight = 1
end
function boat.on_rightclick(self, clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	local name = clicker:get_player_name()
	if self.driver and name == self.driver and player_api.is_sitting(clicker) == true then
		self.driver = nil
		self.auto = false
		clicker:set_detach()
		--player_api.player_attached[name] = false
		player_api.stand_up(clicker)
		player_api.set_animation(clicker, "stand", 30)
		local pos = clicker:get_pos()
		pos = {x = pos.x, y = pos.y + 0.2, z = pos.z}
		minetest.after(0.1, function()
			if clicker then
				clicker:set_pos(pos)
			end
		end)
	elseif not self.driver and player_api.is_sitting(clicker) == true then
		player_api.show_sitting_object_message(clicker)
	elseif not self.driver and player_api.is_sitting(clicker) == false then
		local attach = clicker:get_attach()
		if attach and attach:get_luaentity() then
			local luaentity = attach:get_luaentity()
			if luaentity.driver then
				luaentity.driver = nil
			end
			clicker:set_detach()
		end
		self.driver = name
		clicker:set_attach(self.object, "",
			{x = 0, y = aheight, z = -2}, {x = 0, y = 0, z = 0})
		--player_api.player_attached[name] = true
		player_api.sit_down({x = 0, y = 0, z = 0}, clicker, S("To stand up, press and hold your finger on the boat you are sitting on!"), false)
		minetest.after(0.1, function()
			if clicker then
				player_api.set_animation(clicker, "sit", 30)
			end
		end)
		clicker:set_look_horizontal(self.object:get_yaw())
	end
end

-- If driver leaves server while driving boat
function boat.on_detach_child(self)
	self.driver = nil
	self.auto = false
end


function boat.on_activate(self, staticdata)
	self.object:set_armor_groups({immortal = 1})
	if staticdata then
		self.v = tonumber(staticdata)
	end
	self.last_v = self.v
end


function boat.get_staticdata(self)
	return tostring(self.v)
end


function boat.on_punch(self, puncher)
	if not puncher or not puncher:is_player() or self.removed then
		return
	end

	local name = puncher:get_player_name()
	if self.driver and name == self.driver and player_api.is_sitting(puncher) == true then
		self.driver = nil
		puncher:set_detach()
		--player_api.player_attached[name] = false
		player_api.stand_up(puncher)
	end
	if not self.driver then
		self.removed = true
		local inv = puncher:get_inventory()
		if not inv then
			minetest.add_item(self.object:get_pos(), "boats:boat")
		else
			local leftover = inv:add_item("main", "boats:boat")
			-- if no room in inventory add a replacement boat to the world
			if not leftover:is_empty() then
				minetest.add_item(self.object:get_pos(), leftover)
			end
		end
		-- delay remove to ensure player is detached
		minetest.after(0.1, function()
			if self.object then
				self.object:remove()
			end
		end)
	end
end

local sp = minetest.is_singleplayer()

function boat.on_step(self, dtime)
	-- Drop boat if the player is not on board
	if not sp then
		local drop_timer = 120 -- 2 min

		self.count = (self.count or 0) + dtime
		if self.count > drop_timer then
			minetest.add_item(self.object:get_pos(), "boats:boat")
			self.object:remove()
			return
		end
	end

	self.v = get_v(self.object:get_velocity()) * math.sign(self.v)
	if self.driver then
		self.count = 0
		local driver_objref = minetest.get_player_by_name(self.driver)
		if driver_objref then
			local ctrl = driver_objref:get_player_control()
			if ctrl.up and ctrl.down then
				if not self.auto then
					self.auto = true
					minetest.chat_send_player(self.driver, S("Boat: cruise mode on"))
				end
			elseif ctrl.down then
				self.v = self.v - dtime * 2.0
				if self.auto then
					self.auto = false
					minetest.chat_send_player(self.driver, S("Boat: cruise mode off"))
				end
			elseif ctrl.up or self.auto then
				self.v = self.v + dtime * 2.0
			end
			if ctrl.left then
				if self.v < -0.001 then
					self.object:set_yaw(self.object:get_yaw() - dtime * 0.9)
				else
					self.object:set_yaw(self.object:get_yaw() + dtime * 0.9)
				end
			elseif ctrl.right then
				if self.v < -0.001 then
					self.object:set_yaw(self.object:get_yaw() + dtime * 0.9)
				else
					self.object:set_yaw(self.object:get_yaw() - dtime * 0.9)
				end
			end
			if ctrl.jump and player_api.is_sitting(driver_objref) == true then
				--player_api.player_attached[self.driver] = false
				player_api.stand_up(driver_objref)
				driver_objref:set_detach()
				player_api.set_animation(driver_objref, "stand", 30)
				local pos = driver_objref:get_pos()
				pos = {x = pos.x, y = pos.y + 0.2, z = pos.z}
				minetest.after(0.1, function()
					if driver_objref then
						driver_objref:set_pos(pos)
					end
				end)
				self.driver = nil
				self.auto = false
			end
		else
			-- If driver leaves server while driving 'driver' is present
			-- but driver objectref is nil. Reset boat properties.
			self.driver = nil
			self.auto = false
		end
	end
	local velo = self.object:get_velocity()
	if not self.driver and
			self.v == 0 and velo.x == 0 and velo.y == 0 and velo.z == 0 then
		self.object:set_pos(self.object:get_pos())
		return
	end
	-- We need to preserve velocity sign to properly apply drag force
	-- while moving backward
	local drag = dtime * math.sign(self.v) * (0.01 + 0.0796 * self.v * self.v)
	-- If drag is larger than velocity, then stop horizontal movement
	if math.abs(self.v) <= math.abs(drag) then
		self.v = 0
	else
		self.v = self.v - drag
	end

	local p = self.object:get_pos()
	p.y = p.y - 0.5
	local new_velo
	local new_acce = {x = 0, y = 0, z = 0}
	local iswater, nodename = is_water(p)
	if not iswater then
		local nodedef = minetest.registered_nodes[nodename]
		if (not nodedef) or nodedef.walkable then
			self.v = 0
			new_acce = {x = 0, y = 1, z = 0}
		else
			new_acce = {x = 0, y = -9.8, z = 0}
		end
		new_velo = get_velocity(self.v, self.object:get_yaw(),
			self.object:get_velocity().y)
		self.object:set_pos(self.object:get_pos())
	else
		p.y = p.y + 1
		if is_water(p) then
			local y = self.object:get_velocity().y
			if y >= 5 then
				y = 5
			elseif y < 0 then
				new_acce = {x = 0, y = 20, z = 0}
			else
				new_acce = {x = 0, y = 5, z = 0}
			end
			new_velo = get_velocity(self.v, self.object:get_yaw(), y)
			self.object:set_pos(self.object:get_pos())
		else
			new_acce = {x = 0, y = 0, z = 0}
			if math.abs(self.object:get_velocity().y) < 1 then
				local pos = self.object:get_pos()
				pos.y = math.floor(pos.y) + 0.5
				self.object:set_pos(pos)
				new_velo = get_velocity(self.v, self.object:get_yaw(), 0)
			else
				new_velo = get_velocity(self.v, self.object:get_yaw(),
					self.object:get_velocity().y)
				self.object:set_pos(self.object:get_pos())
			end
		end
	end
	self.object:set_velocity(new_velo)
	self.object:set_acceleration(new_acce)

	-- if boat comes to sudden stop, drop it
	if (self.v2 or 0) - self.v >= 3 then
		if self.driver then
			local driver_objref = minetest.get_player_by_name(self.driver)
			if player_api.is_sitting(driver_objref) == true then
				--player_api.player_attached[self.driver] = false
				player_api.stand_up(driver_objref)
				driver_objref:set_detach()
				player_api.set_animation(driver_objref, "stand" , 30)
			end
		end

		minetest.add_item(self.object:get_pos(), "boats:boat")
		self.object:remove()
		return
	end

	self.v2 = self.v
end


minetest.register_entity("boats:boat", boat)


minetest.register_craftitem("boats:boat", {
	description = S"Boat",
	inventory_image = "boats_inventory.png",
	liquids_pointable = true,
	stack_max = 1,
	groups = {rail = 1, flammable = 2},

	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local udef = minetest.registered_nodes[node.name]
		if udef and udef.on_rightclick and
				not (placer and placer:is_player() and
				placer:get_player_control().sneak) then
			return udef.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		if pointed_thing.type ~= "node" then
			return itemstack
		end
		if not is_water(pointed_thing.under) then
			return itemstack
		end
		pointed_thing.under.y = pointed_thing.under.y + 0.5
		boat = minetest.add_entity(pointed_thing.under, "boats:boat")
		if boat then
			if placer then
				boat:set_yaw(placer:get_look_horizontal())
			end
			local player_name = placer and placer:get_player_name() or ""
			if not minetest.is_creative_enabled(player_name) or not sp then
				itemstack:take_item()
			end
		end
		return itemstack
	end
})


minetest.register_craft({
	output = "boats:boat",
	recipe = {
		{"", "", ""},
		{"group:wood", "", "group:wood"},
		{"group:wood", "group:wood", "group:wood"}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "boats:boat",
	burntime = 20
})
