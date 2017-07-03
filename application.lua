-- applications
-- deals with assigning applications to the correct space
dofile(zwm.spoonPath.."utilities.lua")

local function application_deactivated(app, name)
	-- TODO: Application has been deactivated
end
local function application_activated(app, name)
	-- TODO: Application has been deactivated
end

local function application_hidden(app, name)
	-- TODO: Application has been hidden
end

local function space(app, space)
	return function()
		return send_to_space(app, space)
	end
end

local function application_launched(app, name)
	-- TODO: Application has been launched
	local mappings = config["applications"]
	local match = match_item(name, mappings)

	-- TODO: error checking workspaces

	if match ~= nil then
		print(name)
		local t = hs.timer.doAfter(0.1, space(app, match.f))
		-- send_to_space(app, match.f)
	end
end

local function application_launching(app, name)
	-- TODO: Application has been launching
	
end

local function application_terminated(app, name)
	-- TODO: Application has been terminated
end

local function application_unhidden(app, name)
	-- TODO: Application has been unhidden
end

-- calback
local function application_event(name, event, app)
	if event == hs.application.watcher.activated then
		application_activated(app, name)

	elseif event == hs.application.watcher.deactivated then
		application_deactivated(app, name)

		elseif event == hs.application.watcher.hidden then
		application_hidden(app, name)
		elseif event == hs.application.watcher.launched then
		application_launched(app, name)
		elseif event == hs.application.watcher.launching then
		application_launching(app, name)
		elseif event == hs.application.watcher.terminated then
		application_terminated(app, name)
		elseif event == hs.application.watcher.unhidden then
			application_unhidden(app, name)
	end
end

zwm.application_watcher = hs.application.watcher.new(application_event):start()
