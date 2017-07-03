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

zwm.config_default = c

function get_default()
   return deepcopy(zwm.config_default)
end
