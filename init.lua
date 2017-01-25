 --[[
zwm

Copyright (C) 2017 Rafi Khan
Licensed under the MIT License

 --]]

-- utility functions

function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

function error(msg)
    print("error: \n" .. msg)
end

function alert(msg) 
    hs.alert.show(msg)
end

function string_match(str, table)
    for k, v in pairs(table) do
        if string.match(str, v) then
            return true
        end
    end
    return false
end

-- zwm

tiling_modes = {"monocle"}

function config_load()
    if config then
        hs.printf("Config loaded")

        local mod = config["mod"]

        -- key bindings
        if config["key_bindings"] then

            for binding, info in pairs(config["key_bindings"]) do
                
                -- Launching Applications
                if info["type"] == "application" then
                    if (info["key"] ~= "" and info["action"] ~= "") then 
                        hs.hotkey.bind(mod, info["key"], nil, function() 
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
                                local win = hs.window.focusedWindow()
                                local f = win:frame()
                                local gap = config["window_management"]["gap"]
                                screen_frame = hs.screen.mainScreen():frame()


                                if info["action"] == "window_tiling_toggle" then
                                    alert("Tiling: monocle")

                                    new_frame = hs.geometry.rect(screen_frame._x + gap, screen_frame._y + gap, screen_frame._w - (2 * gap), screen_frame._h - (2 * gap))
                                    win:setFrame(new_frame)                               
                                    -- win:centerOnScreen()
                                end

                            end

                            hs.hotkey.bind(mod, info["key"], bind, nil, bind)

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
        config_load()
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
hs.alert.show("Hammerspoon loaded")