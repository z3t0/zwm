-- utilities

function log(err)
-- TODO: log file
   error(err)
end

-- return the number of items in a table
function table_count(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- recursively prints table
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

-- prints an error to the console
-- TODO: proper error handling
function error(msg)
    print("error: \n" .. msg)
end

-- Alert in center of the screen
function alert_simple(msg) 
    hs.alert(msg)
end

-- Alert from notifications center
function alert(msg, title) 
    if title == nil then
      title = "zwm"
    end

    if config["silent"] then
        print(msg)
    else
        hs.notify.new({title="zwm", informativeText=msg}):send()
    end
end

-- if string matches options from table
function string_match(str, table)
    for k, v in pairs(table) do
        if string.match(str, v) then
            return true
        end
    end
    return false
end

-- if item matches a key in the table, return that pair
function match_item(item, table)
    for k, v in pairs(table) do
        if string.match(item, k) then
            return {i = k, f = v}
        end
    end

    return nil
end

function exact_in_table(item, table)
    for k, v in pairs(table) do
        if item == k then
            return {i = k, f = v}
        end
    end

    return nil
end

-- hex to rgb
function hex_to_rgb(hex)
    local hex = hex:gsub("#","")
    local rgb = {r =tonumber("0x"..hex:sub(1,2))/255, g = tonumber("0x"..hex:sub(3,4))/255, b = tonumber("0x"..hex:sub(5,6))/255}

    return rgb
end

-- converts text to ansi color
function ansi_color(c)
    if c == "black" then
        return 30
    elseif c == "red" then
        return 31
    elseif c == "green" then
        return 32
    elseif c == "yellow" then
        return 33
    elseif c == "blue" then
        return 34
    elseif c == "purple" then 
        return 35
    elseif c == "cyan" then 
        return 36
    elseif c == "white" then
        return 37
    end

end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
