-- spaces

spaces = require("hs._asm.undocumented.spaces")
dofile(zwm.spoonPath.."utilities.lua")

-- returns spaces in order, but its best to not move spaces around
-- FIXME: This only addresses the primary screen (https://github.com/z3t0/zwm/issues/15)
function get_spaces()
    local all_spaces = spaces.layout()
    local inner = nil

    for k, v in pairs(all_spaces) do
        if v ~= nil and type(v) == "table" then
            inner = v
            break
        end
    end

    if inner ~= nil then
       return inner
    end

end

function change_to_space(space)
    local new_space = get_spaces()[space]
   
    if new_space == spaces.activeSpace() then
        return
    elseif new_space ~= nil then
        spaces.changeToSpace(new_space, false)
    else
        error("space does not exist: " .. tostring(space))
    end

	set_workspaces()
end

function func_change_to_space(index)
    return function()
        return change_to_space(index)
    end
end

function move_to_space(space)
    local win = hs.window.focusedWindow()
    local new_space = get_spaces()[space]
   
    if new_space == spaces.activeSpace() then
        return
    elseif new_space ~= nil then
        win:spacesMoveTo(new_space)
    else
        error("space does not exist: " .. tostring(space))
    end
end

-- sends an application and all of its windows to a space
function send_to_space(app, space)
    ba = app
    windows = app:allWindows()
    print(hs.inspect(windows))
    local new_space = get_spaces()[space]
   
    if new_space == spaces.activeSpace() then
        return

    elseif new_space ~= nil then
        for k, v in pairs(windows) do 
             v:spacesMoveTo(new_space)
        end
    end
end

function func_move_to_space(index)
    return function()
        return move_to_space(index)
    end
end
