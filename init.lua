 --[[
zwm

Copyright (C) 2017 Rafi Khan
Licensed under the MIT License

 --]]

require("utilities")
require("window")

-- zwm
applications = get_applications()

function config_load()
    if config then
        hs.printf("Config loaded")

        local mod1 = config["mod1"]
        local mod2 = config["mod2"]

        -- key bindings
        if config["key_bindings"] then

            for binding, info in pairs(config["key_bindings"]) do
                
                -- Launching Applications
                if info["type"] == "application" then
                    if (info["key"] ~= "" and info["action"] ~= "") then 
                        hs.hotkey.bind(mod1, info["key"], nil, function() 
                            hs.application.open(info["action"])
                        end)
                    end
                
                -- Controlling the window manager
                elseif info["type"] == "window" then 
                    if (info["key"] ~= "" and info["action"] ~= "") then 

                        -- tiling
                        local tiling = {"previous", "next", "toggle"}

                        if (string_match(info["action"], tiling)) then

                            local function bind() 
                               
                                local action = info["action"]

                                if action == "window_tiling_toggle" then
                                    -- TODO: Add other modes for this
                                    if config["window_management"]["mode"] == "monocle" then
                                        config["window_management"]["mode"] = "none"
                                        alert("tiling disabled")
                                    elseif config["window_management"]["mode"] == "none" then
                                        config["window_management"]["mode"] = "monocle"
                                        window_tile()
                                        alert("tiling enabled")
                                    end

                                elseif action == "window_previous" then
                                    application_next(false)
                                elseif action == "window_next" then    
                                    application_next(true)        
                                end

                            end

                            hs.hotkey.bind(mod1, info["key"], bind, nil, bind)

                        end
    
                        -- movement
                        local movement = {"left", "right", "down", "up"}
                      
                        if (string_match(info["action"], movement)) then
                            local function bind()
                                local win = hs.window.focusedWindow()
                                local f = win:frame()
                                local move_amount = config["window_management"]["move_amount"]
                                
                                if info["action"] == "window_left" then
                                    f.x = f.x - move_amount
                                elseif info["action"] == "window_right" then
                                    f.x = f.x + move_amount
                                elseif info["action"] == "window_up" then
                                    f.y = f.y - move_amount
                                elseif info["action"] == "window_down" then
                                    f.y = f.y + move_amount
                                else
                                    error("invalid window movement binding: " .. info["action"])
                                end

                                win:setFrame(f)
                            end
                            
                            hs.hotkey.bind(mod1, info["key"], bind, nil, bind)
                        end
                    end

                else
                    print("error: " .. info["type"] .. " not implemented")

                end
                
            end
        end
    else
        alert("Config not loaded properly")
    end
end

-- configuration file

config_file_dir = os.getenv("HOME").. "/.zwm"


function load_config(file)
    local config_source = hs.execute("cat " .. config_file_dir .. "/config.json")

    if config_source == "" then
        alert("empty config")
    else 
        hs.printf("zwm config: \n" .. config_source)
        config = hs.json.decode(config_source)
        config_load()
        alert("loaded config")
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

local config_watcher = hs.pathwatcher.new(config_file_dir, reload_config):start()


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