-- menubar

require("utilities")

menubar = hs.menubar.new()

function set_workspaces()
	local all_spaces = get_spaces()
	local current = spaces.activeSpace()
	output = ""
	local separator = ""
	local color_active = hex_to_rgb(config["bar"].color_active)
	local color_inactive = hex_to_rgb(config["bar"].color_inactive)

	start = nil
	ending = nil

	if config["bar"].separator then
		separator = config["bar"].separator
	end

	local i = 0

	for i in ipairs(all_spaces) do
		t = replace_identifier(tostring(i))
		if all_spaces[i] == current then
			start = output:len()
			output = output .. t .. separator
			ending = output:len()
			
		else
			output = output .. t .. separator
		end
	end

	if start == 0 then
		start = 1
	end

	-- fontawesome
	local font = {font = {name = "FontAwesome", size = config["bar"].size}}
	local active = {starts = start,
		ends = ending2,
		attributes = { 
		color = { 
			red = color_active.r, 
			green = color_active.g,
			blue = color_active.b
			},
			font = {name = "FontAwesome", size = config["bar"].size}
		}
	}

	local inactive_before = {starts = 1 ,
		ends= start,
		attributes = {
		color = { 
			red = color_inactive.r, 
			green = color_inactive.g,
			blue = color_inactive.b
			},
			font = {name = "FontAwesome", size = config["bar"].size}
		}}

		local inactive_after = {starts = ending,
		ends= output:len() + 1,
		attributes = {
		color = { 
			red = color_inactive.r, 
			green = color_inactive.g,
			blue = color_inactive.b
			},
			font = {name = "FontAwesome", size = config["bar"].size}
		}}


	-- local str  F hs.styledtext.ansi(, {font={name="Monaco",size=10},backgroundColor={alpha=1}} )
	local str = hs.styledtext.new({output, inactive_before, active, inactive_after})
	menubar:setTitle(str)
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
