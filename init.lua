 --[[
zwm

Copyright (C) 2017 Rafi Khan
Licensed under the MIT License

 --]]

-- zwm

-- configuration file

config_file_dir = os.getenv("HOME").. "/.zwm"


function load_config(file)
    local config_source = hs.execute("cat " .. config_file_dir .. "/config.json")

    if config_source == "" then
        hs.alert.show("empty config")
    else 
        hs.printf("zwm config: \n" .. config_source)
        config = hs.json.decode(config_source)
        hs.alert.show("loaded config")
    end

end

function reload_config(files)
   doReload = false
    for _,file in pairs(files) do
        if file:sub(-11) == "config.json" then
            doReload = true
        end
    end
    if doReload then  
        load_config(config_file_dir)
    end
end

load_config(config_file_path)

if config then
    hs.printf("Config loaded")

    if config["autoReload"] then
        local config_watcher = hs.pathwatcher.new(config_file_dir, reload_config):start()
    end

    local mod = config["mod"]

    -- key bindings
    if config["key_bindings"] then

        for binding, info in pairs(config["key_bindings"]) do
            
            if info["type"] == "application" then

                if (info["key"] ~= "" and info["app"] ~= "") then 
                    hs.hotkey.bind(mod, info["key"], nil, function() 
                        hs.application.open(info["app"])
                    end)
                end

            else
            print("error: " .. info["type"] .. " not implemented")

            end
            
        end
    end
else
    hs.alert.show("Config not loaded properly")
end

-- hammerspoon

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
local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_hammerspoon):start()
hs.alert.show("Hammerspoon loaded")