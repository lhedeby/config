local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

wezterm.on('update-right-status', function(window, _)
	window:set_right_status(window:active_workspace())
end)

config.audible_bell = "Disabled"
config.color_scheme = 'nordfox'
-- config.color_scheme = 'Gruvbox dark, hard (base16)'
config.default_prog = { 'C:/Program Files/PowerShell/7/pwsh.exe', '-NoLogo' }
config.window_decorations = "RESIZE"
config.tab_max_width = 26
config.tab_bar_at_bottom = true
config.check_for_updates = false
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true

config.window_padding = {
	left = 2,
	right = 0,
	top = 2,
	bottom = 0,
}

local function get_formated_description(text)
	return wezterm.format {
		{ Attribute = { Intensity = 'Bold' } },
		{ Foreground = { AnsiColor = 'Fuchsia' } },
		{ Text = text },
	}
end

config.leader = { key = "a", mods = "CTRL" }
config.keys = {
	{
		key = 'w',
		mods = 'LEADER',
		action = wezterm.action.ShowLauncherArgs { flags = "WORKSPACES" }
	},
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action { SendString = "\x01" } },
	{ key = "c", mods = "LEADER",      action = wezterm.action { SpawnTab = "CurrentPaneDomain" } },


	{ key = "1", mods = "LEADER",      action = act { ActivateTab = 0 } },
	{ key = "2", mods = "LEADER",      action = act { ActivateTab = 1 } },
	{ key = "3", mods = "LEADER",      action = act { ActivateTab = 2 } },
	{ key = "4", mods = "LEADER",      action = act { ActivateTab = 3 } },
	{ key = "5", mods = "LEADER",      action = act { ActivateTab = 4 } },
	{ key = "6", mods = "LEADER",      action = act { ActivateTab = 5 } },
	{ key = "7", mods = "LEADER",      action = act { ActivateTab = 6 } },
	{ key = "8", mods = "LEADER",      action = act { ActivateTab = 7 } },
	{ key = "9", mods = "LEADER",      action = act { ActivateTab = 8 } },
	{ key = "d", mods = "LEADER",      action = act { CloseCurrentTab = { confirm = true } } },
	{ key = "n", mods = "SHIFT|CTRL",  action = "ToggleFullScreen" },
	{ key = '{', mods = 'SHIFT|ALT',   action = act.MoveTabRelative(-1) },
	{ key = '}', mods = 'SHIFT|ALT',   action = act.MoveTabRelative(1) },
	{ key = 't', mods = 'LEADER',      action = wezterm.action.ShowTabNavigator },
	-- RENAME TAB
	{
		key = 'r',
		mods = 'LEADER',
		action = act.PromptInputLine {
			description = get_formated_description('Enter new name for tab'),
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		},
	},
	-- ASK FOR NEW WORKSPACE NAME
	{
		key = 'n',
		mods = 'LEADER',
		action = act.PromptInputLine {
			description = get_formated_description('Enter name for new workspace'),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						act.SwitchToWorkspace {
							name = line,
						},
						pane
					)
				end
			end),
		},
	},
}

return config
