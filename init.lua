 --[[
zwm

Copyright (C) 2017 Rafi Khan
Licensed under the MIT License

 --]]

require("utilities")
require("window")
require("server")

-- zwm
applications = get_applications()

function parse_keybinding(b)
    -- converts "-" separate binding into usable binding
    local mods_config = config["mods"]
    
    local mod_found = false

    -- replace modifiers with corresponding keys
    for k, v in pairs(mods_config) do
        if b:match(k) then
            b = b:gsub(k, v)
            mod_found = true
        end
    end

    local parsed = {}
    
    -- if neither modifier is there assume mod1
    if mod_found then
        parsed.mods = b:sub(1, b:len() - 2)
    else
        parsed.mods = mods_config["mod1"]
    end    
    
    local key = nil

    -- get key
    for i in string.gmatch(b, '([^-]+)') do
        key = i
    end

    if key ~= nil then
        print("key found: " .. key)
        -- todo error checking for acceptable keys
        parsed.key = key
    end

    return parsed
end

function config_load()
    if config then
        hs.printf("Config loaded")

        -- key bindings
        if config["key_bindings"] then
            for b, info in pairs(config["key_bindings"]) do
                
                local type = info["type"]
                local key = info["key"]
                local action = info["action"]
                local binding = parse_keybinding(info["key"])

                -- Launching Applications
                if type == "application" then
                    if (key ~= "" and action ~= "") then 
                        hs.hotkey.bind(binding.mods, binding.key, nil, function() 
                            print_r(binding)
                            hs.application.open(action)
                        end)
                    end

                elseif type == "space" then
                
                -- Controlling the window manager
                elseif type == "window" then 
                    if (key ~= "" and action ~= "") then 

                        -- tiling
                        local tiling = {"previous", "next", "toggle"}

                        if (string_match(action, tiling)) then

                            local function bind() 
                               
                                local action = action

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

                            hs.hotkey.bind(binding.mods, binding.key, bind, nil, bind)

                        end
    
                        -- movement
                        local movement = {"left", "right", "down", "up"}
                      
                        if (string_match(action, movement)) then
                            local function bind()
                                local win = hs.window.focusedWindow()
                                local f = win:frame()
                                local move_amount = config["window_management"]["move_amount"]
                                
                                if action == "window_left" then
                                    f.x = f.x - move_amount
                                elseif action == "window_right" then
                                    f.x = f.x + move_amount
                                elseif action == "window_up" then
                                    f.y = f.y - move_amount
                                elseif action == "window_down" then
                                    f.y = f.y + move_amount
                                else
                                    error("invalid window movement binding: " .. action)
                                end

                                win:setFrame(f)
                            end
                            
                            hs.hotkey.bind(binding.mods, binding.key, bind, nil, bind)
                        end
                    end

                else
                    print("error: " .. type .. " not implemented")

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