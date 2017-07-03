-- Variables
config_file_path = os.getenv("HOME").. "/.zwm"

-- Parse configuration

local function parse()
   print("Configuration:")
   print(hs.inspect(zwm.config))
   
   local c = zwm.config

   -- reloads on config file change
   if c.autoReload ~= nil and c.autoReload == true then
      local config_watcher = hs.pathwatcher.new(config_file_path, load_config):start()
   end

end

function load_config()
      parse()
      hs.alert.show("loaded config")
end

