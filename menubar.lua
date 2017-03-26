-- menubar

require("utilities")

menubar = hs.menubar.new()

function set_workspaces()
	local all_spaces = get_spaces()
	local current = spaces.activeSpace()
	local output = ""
	local separator = ""
	local color = tostring(ansi_color(config["bar"].color))
	local bg = tostring(ansi_color(config["bar"].bg))

	if config["bar"].separator then
		separator = config["bar"].separator
	end

	local i = 0

	for i in ipairs(all_spaces) do
		t = replace_identifier(tostring(i))
		if all_spaces[i] == current then

			output = output .. '\27[' .. color .. 'm' .. t .. separator .. '\27[0m'
			
		else
			output = output .. '\27[' .. bg .. 'm' .. t .. separator .. '\27[0m'
		end
	end

	-- fontawesome
	local font = {font = {name = "FontAwesome", size = config["bar"].size}}
	-- local str  = hs.styledtext.ansi(, {font={name="Monaco",size=10},backgroundColor={alpha=1}} )
	local str = hs.styledtext.ansi(output, font)
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


