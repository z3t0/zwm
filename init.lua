 --[[
zwm

Copyright (C) 2017 Rafi Khan
Licensed under the MIT License

 --]]

-- utility functions
function error(msg)
    print("error: \n" .. msg)
end

-- zwm


function load()
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
                    if (info["key"] ~= "" and info["action"] ~= "") then 
                        hs.hotkey.bind(mod, info["key"], nil, function() 
                            hs.application.open(info["action"])
                        end)
                    end
                elseif info["type"] == "window" then 
                    if (info["key"] ~= "" and info["action"] ~= "") then 
                        local function bind()
                            local win = hs.window.focusedWindow()
                            local f = win:frame()
                            local move_amount = config["window_management"]["move_amount"]
                            
                            if info["action"] == "window_left" then
                                f.x = f.x - move_amount
                            elseif info["action"] == "window_right" then
                                f.x = f.x + move_amount
                            elseif info["action"] == "window_up" then
                            -- BUG: Up is down down is up https://github.com/Hammerspoon/hammerspoon/issues/1208
                                f.y = f.y - move_amount
                            elseif info["action"] == "window_down" then
                                f.y = f.y + move_amount
                            else
                                error("invalid window movement binding: " .. info["action"])
                            end

                            win:setFrame(f)
                        end

                        hs.hotkey.bind(mod, info["key"], bind, nil, bind)
                    end

                else
                    print("error: " .. info["type"] .. " not implemented")

                end
                
            end
        end
    else
        hs.alert.show("Config not loaded properly")
    end
end

-- configuration file

config_file_dir = os.getenv("HOME").. "/.zwm"


function load_config(file)
    local config_source = hs.execute("cat " .. config_file_dir .. "/config.json")

    if config_source == "" then
        hs.alert.show("empty config")
    else 
        hs.printf("zwm config: \n" .. config_source)
        config = hs.json.decode(config_source)
        load()
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