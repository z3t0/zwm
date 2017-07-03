dofile(zwm.spoonPath.."utilities.lua")

-- Variables
config_file_path = os.getenv("HOME").. "/.zwm"

-- Parse configuration
local function parse(config)

   if config ~= nil then
      
      print("Configuration:")
      print(hs.inspect(config))
      
      local c = config

      -- Key bindings
      -- load mod keys

      if c.keybindings ~= nil then
	 
	 local k = c.keybindings

	 if k.mods ~= nil then
	    for index = 1, #k.mods do
	       if exact_in_table(k.mods[index], hs.keycodes.map) == nil then
		  log("mod: '".. k.mods[index] .."' not supported")
	       end
	    end

	 else
	    log("no mods found")
	 end

      end
      
      -- Spaces
      

      -- reloads on config file change
      if c.autoReload ~= nil and c.autoReload == true then
	 local config_watcher = hs.pathwatcher.new(config_file_path, load_config):start()
      end

      -- TODO: error checking
      zwm.config = config

   end


end

function load_config(config)
      parse(config)
      hs.alert.show("loaded config")
end

