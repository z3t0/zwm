-- utilities

function table_count(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

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

function alert_simple(msg) 
    hs.alert(msg)
end

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

function string_match(str, table)
    for k, v in pairs(table) do
        if string.match(str, v) then
            return true
        end
    end
    return false
end
