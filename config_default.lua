-- default configuration for zwm
-- serves as an api documentation for now

dofile(zwm.spoonPath.."utilities.lua")

local c = {}

-- General
c.autoReload = true -- automatically reloads the configuration file

-- Window management
c.wm = {}

-- Key bindings
-- mod key
local keybindings = {}

keybindings.mods = {}
keybindings.mods[1] = 'alt'

c.keybindings = keybindings

-- Spaces
local spaces = {}
spaces.tags = {}
spaces[1] = '1'
spaces[2] = '2'

c.spaces = spaces


-- UI
local ui = {}

ui.enabled = true

ui.bar = {}
ui.bar.color_active = "FFAA00"
ui.bar.color_inactive = "#ffffff"
ui.bar.separator = " | "
ui.bar.fontsize = 15

c.ui = ui



zwm.config_default = c

function get_default()
   return deepcopy(zwm.config_default)
end
