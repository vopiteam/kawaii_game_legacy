sfinv = {
	pages = {},
	pages_unordered = {},
	contexts = {},
	enabled = true
}

function sfinv.register_page(name, def)
	assert(name, "Invalid sfinv page. Requires a name")
	assert(def, "Invalid sfinv page. Requires a def[inition] table")
	assert(def.get, "Invalid sfinv page. Def requires a get function.")
	assert(not sfinv.pages[name], "Attempt to register already registered sfinv page " .. dump(name))

	sfinv.pages[name] = def
	def.name = name

	local unpages = sfinv.pages_unordered
	unpages[#unpages+1] = def
end

function sfinv.override_page(name, def)
	assert(name, "Invalid sfinv page override. Requires a name")
	assert(def, "Invalid sfinv page override. Requires a def[inition] table")
	local page = sfinv.pages[name]
	assert(page, "Attempt to override sfinv page " .. dump(name) .. " which does not exist.")
	for key, value in pairs(def) do
		page[key] = value
	end
end

--[[function sfinv.get_nav_fs(player, context, nav, current_idx)
	-- Only show tabs if there is more than one page
	if #nav > 1 then
		return "tabheader[0,0;sfinv_nav_tabs;" .. table.concat(nav, ",") ..
				";" .. current_idx .. ";true;false]"
	else
		return ""
	end
end]]

local theme_inv = [[
	list[current_player;main;0.01,4.51;9,3;9]
	list[current_player;main;0.01,7.74;9,1;]
]]

function sfinv.make_formspec(_, _, content, show_inv, size)
	local tmp = {
		size or "size[9,8.75]",
		default.gui_bg,
		default.listcolors,
	--	sfinv.get_nav_fs(player, context, context.nav_titles, context.nav_idx),
		show_inv and theme_inv or "",
		content
	}
	return table.concat(tmp, "")
end

function sfinv.get_homepage_name()
	return "sfinv:inventory"
end

function sfinv.get_formspec(player, context)
	-- Generate navigation tabs
	local nav = {}
	local nav_ids = {}
	local current_idx = 1
	for _, pdef in pairs(sfinv.pages_unordered) do
		if not pdef.is_in_nav or pdef:is_in_nav(player, context) then
			nav[#nav + 1] = pdef.title
			nav_ids[#nav_ids + 1] = pdef.name
			if pdef.name == context.page then
				current_idx = #nav_ids
			end
		end
	end
	context.nav = nav_ids
	context.nav_titles = nav
	context.nav_idx = current_idx

	-- Generate formspec
	local page = sfinv.pages[context.page] or sfinv.pages["404"]
	if page then
		return page:get(player, context)
	else
		local old_page = context.page
		local home_page = sfinv.get_homepage_name(player)

		if old_page == home_page then
			minetest.log("error", "[sfinv] Couldn't find " .. dump(old_page) ..
					", which is also the old page")

			return ""
		end

		context.page = home_page
		assert(sfinv.pages[context.page], "[sfinv] Invalid homepage")
		minetest.log("warning", "[sfinv] Couldn't find " .. dump(old_page) ..
				" so switching to homepage")

		return sfinv.get_formspec(player, context)
	end
end

function sfinv.get_or_create_context(player)
	local name = player:get_player_name()
	local context = sfinv.contexts[name]
	if not context then
		context = {
			page = sfinv.get_homepage_name(player)
		}
		sfinv.contexts[name] = context
	end
	return context
end

function sfinv.reset_context(player)
	local name = player:get_player_name()
	local context = {
		page = sfinv.get_homepage_name(player)
	}
	sfinv.contexts[name] = context
end

function sfinv.set_context(player, context)
	sfinv.contexts[player:get_player_name()] = context
end

function sfinv.set_player_inventory_formspec(player, context)
	local fs = sfinv.get_formspec(player,
			context or sfinv.get_or_create_context(player))
	player:set_inventory_formspec(fs)
end

function sfinv.open_formspec(player, context)
	local fs = sfinv.get_formspec(player,
			context or sfinv.get_or_create_context(player))
	minetest.show_formspec(player:get_player_name(), "", fs)
end

function sfinv.set_page(player, pagename, temp)
	local context = sfinv.get_or_create_context(player)
	local oldpage = sfinv.pages[context.page]
	if oldpage and oldpage.on_leave then
		oldpage:on_leave(player, context)
	end
	context.page = pagename
	local page = sfinv.pages[pagename]
	if page.on_enter then
		page:on_enter(player, context)
	end
	if temp then
		sfinv.open_formspec(player, context)
		return
	end
	sfinv.set_player_inventory_formspec(player, context)
end

function sfinv.get_page(player)
	local context = sfinv.contexts[player:get_player_name()]
	return context and context.page or sfinv.get_homepage_name(player)
end

minetest.register_on_joinplayer(function(player)
	if sfinv.enabled then
		sfinv.set_player_inventory_formspec(player)
	end
end)

minetest.register_on_leaveplayer(function(player)
	sfinv.contexts[player:get_player_name()] = nil
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "" or not sfinv.enabled then
		return false
	end

	-- Get Context
	local name = player:get_player_name()
	local context = sfinv.contexts[name]
	if not context then
		sfinv.set_player_inventory_formspec(player, context)
		return false
	end

	-- Was a tab selected?
--[[if fields.sfinv_nav_tabs and context.nav then
		local tid = tonumber(fields.sfinv_nav_tabs)
		if tid and tid > 0 then
			local id = context.nav[tid]
			local page = sfinv.pages[id]
			if id and page then
				sfinv.set_page(player, id)
			end
		end
	else]]
		-- Pass event to page
		local page = sfinv.pages[context.page]
		if page and page.on_player_receive_fields then
			return page:on_player_receive_fields(player, context, fields)
		end
--	end
end)
