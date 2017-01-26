require ("utilities")
function get_applications() 
    local applications = hs.application.runningApplications()
    local not_applications = {}

    local n=#applications

    -- Certain apps show up after the filter but should not.
    local edge_cases = {"Notification Center", "Finder", "Übersicht", "Hammerspoon"}
    -- Finder glitching

    for k, v in pairs(applications) do
        local win = v:allWindows()

        if table_count(win) < 1 then
            not_applications[k] = true
        elseif string_match(v:name(), edge_cases) then
            not_applications[k] = true
        end
    end

    for i=1,n do
        if not_applications[i] then
                applications[i]=nil
        end
    end

    local ordered = {}
    local i = 1
    for k, v in pairs(applications) do
        ordered [i] = v
        i = i+1
    end

    return ordered
end

function window_tile()
    local tile = config["window_management"]["mode"]

    local win = hs.window.focusedWindow()
    local f = win:frame()
    local gap = config["window_management"]["gap"]
    local screen = hs.screen.mainScreen():frame()

    if tile == "monocle" then
        local new_frame = hs.geometry.rect(screen._x + gap, screen._y + gap, screen._w - (2 * gap), screen._h - (2 * gap))
        if new_frame ~= f then
            win:setFrame(new_frame)
        end
    end
end

function application_next(front)
    -- monocle
    current_app = hs.application.frontmostApplication()
    local next = {}

    local applications = get_applications()
    for i, v in ipairs(applications) do
        if v:name() == current_app:name() then
            if i == table_count(applications) then
                if front then
                    next = applications[1]
                    break
                else
                    next = applications[i - 1]
                    break
                end
            elseif i == 1 then
                if front then
                    next = applications[i + 1]
                    break
                else
                    next = applications[table_count(applications)]
                    break
                end

            else
                if front then
                    next = applications[i + 1]
                    break
                else 
                    next = applications[i - 1]
                    break
                end
            end
        end
    end

    next:activate()
    window_tile()
end