--[[
zwm

Copyright (C) 2017 Rafi Khan
Licensed under the MIT License

--]]

-- Spoon information
zwm = {}
zwm.name = "zwm"
zwm.version = "0.0.1"
zwm.author = "Rafi Khan"
zwm.license = "MIT"
zwm.homepage = "https://github.com/z3t0/zwm"

-- Internal function used to find our location, so we know where to load files from
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end

zwm.spoonPath = script_path()

-- Load other files
dofile(zwm.spoonPath.."utilities.lua")
dofile(zwm.spoonPath.."window.lua")
dofile(zwm.spoonPath.."spaces.lua")
dofile(zwm.spoonPath.."menubar.lua")
dofile(zwm.spoonPath.."application.lua")
dofile(zwm.spoonPath.."config_default.lua")
dofile(zwm.spoonPath.."config.lua")

-- zwm
function zwm:init()
   local config = dofile(os.getenv("HOME").."/.zwm/config.lua")
   if config ~= nil then
      load_config(config)
   end
end

-- applications = get_applications()


-- hammerspoon config
-- reload this file on change.
function reload_hammerspoon(files)
	doReload = false
	for _,file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

local myWatcher = hs.pathwatcher.new(zwm.spoonPath, reload_hammerspoon):start()

return zwm
