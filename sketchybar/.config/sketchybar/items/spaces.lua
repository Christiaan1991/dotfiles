local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local sbar = require("sketchybar")

local spaces = {}
-- local space_windows = {}
AEROSPACE_FOCUSED_SPACE = nil

local app_colors = {
	["Code"] = colors.blue,
	["Terminal"] = colors.green,
	["Default"] = colors.grey,
	["Firefox"] = colors.orange,
	["WezTerm"] = colors.purple,
	["LM Studio"] = colors.purple,
	["Microsoft Edge"] = colors.blue,
	["Microsoft Excel"] = colors.green,
	["Microsoft Outlook"] = colors.blue,
	["Microsoft PowerPoint"] = colors.red,
	["Microsoft Teams"] = colors.purple,
	["Microsoft Word"] = colors.blue,
	["Google Chrome"] = colors.red,
	["Maps"] = colors.green,
	["Mail"] = colors.blue,
	["Messages"] = colors.green,
	["Spotify"] = colors.green,
	["Music"] = colors.red,
	["Slack"] = colors.purple,
	["Safari"] = colors.blue,
	["PyCharm"] = colors.orange,
	["Datagrip"] = colors.blue,
	["Dataspell"] = colors.green,
	["IntelliJ IDEA"] = colors.orange,
	["Finder"] = colors.blue,
	["Cursor"] = colors.white,
	["Home"] = colors.yellow,
	["Notes"] = colors.yellow,
	["Games"] = colors.orange,
	["Photos"] = colors.red,
	["Calendar"] = colors.red,
	["Reminders"] = colors.purple,
	["FaceTime"] = colors.green,
	["TV"] = colors.black,
	["Books"] = colors.brown,
	["Podcasts"] = colors.purple,
	["News"] = colors.red,
	["Stocks"] = colors.black,
	["Voice Memos"] = colors.black,
	["Contacts"] = colors.yellow,
	["Calculator"] = colors.black,
	["Preview"] = colors.grey,
	["Keynote"] = colors.purple,
	["Numbers"] = colors.green,
    ["Proton Mail"] = colors.purple,
    ["Proton Mail Bridge"] = colors.purple,
	["Pages"] = colors.orange,
	["GarageBand"] = colors.green,
	["iMovie"] = colors.purple,
	["Weather"] = colors.blue,
	["Journal"] = colors.magenta,
	["Xcode"] = colors.blue,
	["Find My"] = colors.green,
	["Steam"] = colors.navy,
	["Discord"] = colors.purple,
	["Zoom"] = colors.blue,
	["Stickies"] = colors.yellow,
	["App Store"] = colors.blue,
	["kitty"] = colors.green,
	["MongoDB Compass"] = colors.green,
	["Passwords"] = colors.dark_grey,
    ["Clock"] = colors.white,
}

local refresh_active_windows = function(workspace, window)
	if workspace == nil then
		return
	end
	local cmd = "aerospace list-windows --workspace "
		.. workspace
		.. " --format '%{monitor-id} %{window-id} %{app-name} %{window-title}  %{workspace}' --json"
	sbar.exec(cmd, function(output)
		local is_selected = (AEROSPACE_FOCUSED_SPACE == workspace)
		local has_any = false
		local app_index = 0
		-- space_windows[workspace] = {}
		sbar.set("/space" .. workspace .. ".app\\.*/", {
			drawing = false,
			updates = false,
			background = { drawing = false, color = nil, border_width = 0 },
		})
		for k, v in pairs(output) do
			app_index = app_index + 1
			has_any = true
			local app_name = v["app-name"]
			local newly_focused_window = v["window-id"] == window
			local icon = app_icons[app_name] or app_icons["Default"]
			local color = app_colors[app_name] or colors.grey
			if app_index > 5 then
				sbar.set("space" .. workspace .. ".app.ellipses", {
					drawing = true,
				})
			else
				local highlight_opacity = newly_focused_window and 1.0 or 0.5
				sbar.set("space" .. workspace .. ".app." .. app_index, {
					drawing = true,
					updates = true,
					icon = {
						string = icon,
						color = colors.with_alpha(color, 0.3),
						-- color = colors.grey,
						highlight_color = colors.with_alpha(color, highlight_opacity),
					},
					label = {
						drawing = false,
					},
					background = {
						drawing = newly_focused_window,
						color = newly_focused_window and colors.with_alpha(colors.white, 0.2) or nil,
						height = 20,
						corner_radius = 100,
					},
				})
			end
		end
		sbar.set("space" .. workspace .. ".label", {
			drawing = is_selected or has_any,
			width = is_selected and not has_any and "dynamic" or 20,
			updates = is_selected or has_any,
			-- padding_right = has_any and 100 or 0,
		})
		sbar.set("space" .. workspace, {
			updates = is_selected or has_any,
		})
		-- sbar.set("space" .. workspace .. ".app.1", {
		-- drawing = has_any,
		-- padding_right = has_any and 100 or 0,
		-- })
		-- sbar.set("space" .. workspace, {
		-- drawing = has_any and 100,
		-- })

		-- sbar.animate("tanh", 10, function()
		-- spaces[workspace]:set({ label = icon_line, drawing = has_any })
		-- })
		-- end)
	end)
end

local get_aerospace_workspaces = function()
	local cmd = io.popen("aerospace list-workspaces --all")
	if not cmd then
		return {}
	end

	local aerospace_spaces = {}
	for line in cmd:lines() do
		table.insert(aerospace_spaces, line)
	end
	cmd:close()
	return aerospace_spaces
end

local aerospace_spaces = get_aerospace_workspaces()

-- for monitor_idx 1, 3 do
-- sbar.set("item", monitor.name, {
-- padding_left = settings.paddings,
-- padding_right = settings.paddings,
-- })
-- end
for idx, i in pairs(aerospace_spaces) do
	spaceapps = { "space" .. i .. ".label" }

	local space_label = sbar.add("item", "space" .. i .. ".label", {
		position = "space." .. i,
		width = 20,
		icon = {
			font = { family = settings.font.numbers, size = 16.0 },
			string = i,
			padding_left = 4,
			padding_right = 0,
			color = colors.grey,
			highlight_color = colors.white,
		},
		drawing = false,
	})

	for index = 1, 5 do
		local app_color = colors.white
		local app_icon_size = 22.0
		sbar.add("item", "space" .. i .. ".app." .. index, {
			position = "space." .. i, -- Place it after the workspace number
			drawing = false,
			updates = false,
			icon = {
				string = ":default:", -- Placeholder icon,
				font = "sketchybar-app-font:Regular:" .. app_icon_size,
				padding_left = 0,
				padding_right = 0,
				width = app_icon_size,
			},
			label = { drawing = false },
			background = { drawing = false },
		})
		spaceapps[#spaceapps + 1] = "space" .. i .. ".app." .. index
	end

	sbar.add("item", "space" .. i .. ".app.ellipses", {
		position = "space." .. i, -- Place it after the workspace number
		drawing = false,
		align = "left",
		icon = {
			string = "...",
			color = colors.grey,
			highlight_color = colors.white,
			font = "sketchybar-app-font:Regular:16.0",
			padding_left = 0,
			padding_right = 0,
		},
		-- label = { drawing = false },
		background = { drawing = false },
	})
	spaceapps[#spaceapps + 1] = "space" .. i .. ".app.ellipses"

	local space = sbar.add("bracket", "space" .. i, spaceapps, {
		-- associated_space = i,
		-- space = i,
		updates = false,
		-- drawing = true,
		-- updates = true,
		-- icon = {
		-- font = { family = settings.font.numbers, size = 16.0 },
		-- string = i,
		-- padding_left = 8,
		-- padding_right = 0,
		-- color = colors.grey,
		-- highlight_color = colors.white,
		-- },
		-- label = {
		-- padding_right = 10,
		-- padding_left = 10,
		-- string = i,
		-- color = colors.grey,
		-- highlight_color = colors.white,
		-- font = "sketchybar-app-font:Regular:20.0",
		-- y_offset = -1,
		-- },
		-- padding_right = 0,
		-- padding_left = 0,
		background = {
			color = colors.with_alpha(colors.bg2, 0.3),
			border_color = colors.with_alpha(colors.bg2, 0.3),
			-- border_width = 1,
			height = 30,
		},
	})

	spaces[i] = space

	-- Padding space
	-- sbar.add("space", "space.padding." .. i, {
	-- script = "",
	-- width = settings.group_paddings,
	-- })

	-- local space_popup = sbar.add("item", {
	-- position = "popup." .. space.name,
	-- padding_left = 5,
	-- padding_right = 0,
	-- background = {
	-- drawing = true,
	-- image = {
	-- corner_radius = 9,
	-- scale = 0.2
	-- }
	-- }
	-- })
	--
	local function show_active_opacity(selected)
		sbar.set("/space" .. i .. "\\.*/", {
			-- space_label:set({
			icon = { highlight = selected },
			-- background = { border_color = selected and colors.black or colors.bg2 },
		})
		sbar.set("space" .. i .. ".label", {
			icon = { highlight = selected },
		})
		local opacity = selected and 0.7 or 0.3
		space:set({
			background = {
				color = colors.with_alpha(colors.bg2, opacity),
				border_color = colors.with_alpha(colors.bg2, opacity),
			},
		})
	end

	space:subscribe("aerospace_workspace_change", function(env)
		local selected = env.FOCUSED_WORKSPACE == i
		local last_selected = env.PREV_WORKSPACE == i
		local color = selected and colors.grey or colors.bg2
		AEROSPACE_FOCUSED_SPACE = env.FOCUSED_WORKSPACE
		if selected or last_selected then
			refresh_active_windows(i)
		end
		show_active_opacity(selected)
	end)

	for idx, name in pairs(spaceapps) do
		sbar.subscribe(name, "mouse.clicked", function(env)
			print(name .. " clicked, switching to workspace " .. i)
			sbar.exec("aerospace workspace " .. i)
		end)
		sbar.subscribe(name, "mouse.exited", function(_)
			if AEROSPACE_FOCUSED_SPACE ~= i then
				print("animating to inactive opacity for space " .. i)
				sbar.animate("tanh", 30, function()
					show_active_opacity(false)
				end)
			end
			print("exited space " .. i)
		end)

		sbar.subscribe(name, "mouse.entered", function(_)
			if AEROSPACE_FOCUSED_SPACE ~= i then
				print("animating to active opacity for space " .. i)
				sbar.animate("tanh", 30, function()
					show_active_opacity(true)
				end)
			end
			sbar.delay(1, function()
				if AEROSPACE_FOCUSED_SPACE ~= i then
					print("animating to inactive opacity for space " .. i)
					sbar.animate("tanh", 30, function()
						show_active_opacity(false)
					end)
				end
			end)
			print("exited space " .. i)
			-- space:set({ popup = { drawing = false } })
			print("entered space " .. i)
		end)
		-- sbar.subscribe(name, "mouse.entered", function(env)
		-- someething
		-- end
		-- end)
	end

	refresh_active_windows(i)
end

local spaces_indicator = sbar.add("item", {
	padding_left = -3,
	padding_right = 0,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

space_window_observer:subscribe("aerospace_window_focus_change", function(env)
	refresh_active_windows(AEROSPACE_FOCUSED_SPACE, tonumber(env.FOCUSED_WINDOW))
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	-- sbar.delay(1, function()
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
	-- end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)

spaces[spaces_indicator.name] = spaces_indicator

return spaces
