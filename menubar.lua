-- menubar

dofile(zwm.spoonPath.."utilities.lua")

menubar = hs.menubar.new()

function set_workspaces()
	local all_spaces = get_spaces()
	local current = spaces.activeSpace()
	local inactive_before_text = ""
	local inactive_after_text = ""
	local separator = ""
	local active_text = ""
	local color_active = hex_to_rgb(config["bar"].color_active)
	local color_inactive = hex_to_rgb(config["bar"].color_inactive)

	if config["bar"].separator then
		separator = config["bar"].separator
	end

	local i = 0

	for i in ipairs(all_spaces) do
		t = replace_identifier(tostring(i))
		if all_spaces[i] == current then
			active_text = t .. separator
			
		else
			if active_text:len() == 0 then
				inactive_before_text = inactive_before_text .. t .. separator
			else
				inactive_after_text = inactive_after_text .. t .. separator
			end
		end
	end

	-- fontawesome
	local font = {name = "FontAwesome", size = config["bar"].size}

	local active = hs.styledtext.new(active_text, {font = font, color = { red = color_active.r, green = color_active.g, blue = color_active.b}})
	local inactive_before = hs.styledtext.new(inactive_before_text, {font = font, color = { red = color_inactive.r, green = color_inactive.g, blue = color_inactive.b}})
	local inactive_after = hs.styledtext.new(inactive_after_text, {font = font, color = { red = color_inactive.r, green = color_inactive.g, blue = color_inactive.b}})

	local g_str = inactive_before .. active .. inactive_after

	menubar:setTitle(g_str)
end

function replace_identifier(index)
	local match = match_item(index, workspaces)
	if match == nil then
		return index
	else
		return tostring(match.f)
	end
end

-- change menubar on normal space change
local watcher = hs.spaces.watcher.new(set_workspaces)
watcher:start()
