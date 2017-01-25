require ("utilities")
function get_applications() 
    local applications = hs.application.runningApplications()
    local not_applications = {}

    local n=#applications

    -- Certain apps show up after the filter but should not.
    local edge_cases = {"Notification Center"}

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

    return applications
end