--[[
zwm

Copyright (C) 2017 Rafi Khan
Licensed under the MIT License

--]]

-- global object
-- TODO: Enforce this
zwm = {}


require("utilities")
require("window")
require("spaces")
require("menubar")
require("application")

-- zwm
applications = get_applications()

-- configuration file
-- TODO: exact file path
config_file_dir = os.getenv("HOME").. "/.zwm"

-- parses key bindings into individual keys with modifier(s)
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
		-- todo error checking for acceptable keys
		parsed.key = key
	end

	return parsed
end

-- loads the configuration
function config_load()
	if config then
		hs.printf("Config loaded")

		-- key bindings
		if config["key_bindings"] then

			-- dynamic bindings
			for b, info in pairs(config["key_bindings"]) do

				local type = info["type"]
				local key = info["key"]
				local action = info["action"]
				local binding = parse_keybinding(info["key"])

				-- Launching Applications
				if type == "application" then
					if (key ~= "" and action ~= "") then 
						-- open .app
						local bind = nil
						if action:sub(action:len() - 3, action:len()) == ".app" then
							bind = function() 
							hs.application.open(action)
						end
						elseif action == "application_quit" then
							bind = function()
							hs.application.frontmostApplication():kill()
						end
					end

					if bind ~= nil then
						hs.hotkey.bind(binding.mods, binding.key, bind, nil, nil) 
					end
				end

				elseif type == "space" then
					if action == "space_change" then
						local bind = nil
						-- switch to number keys
						for i=1, 9 do
							bind_test = func_change_to_space(i)
							if bind_test ~= nil then
								hs.hotkey.bind(binding.key, tostring(i), nil, bind_test)
							else
								print("nil at " .. i)
							end
						end

					elseif action == "space_move" then
						-- move window to number keys
						for i=1, 9 do
							local binding = parse_keybinding(info["key"] .. '-' .. tostring(i))
							local bind_test = func_move_to_space(i)
							if bind_test ~= nil then
								hs.hotkey.bind(binding.mods, binding.key, nil, bind_test)
							else
								print("nil at " .. i)
							end
						end
					end

					-- Controlling the window manager
					elseif type == "window_management" then 
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

										elseif action == "application_previous" then
											application_next(false)
											elseif action == "application_next" then    
												application_next(true)     
												elseif action == "window_previous" then
													window_next(false)
													elseif action == "window_next" then    
														window_next(true)       
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

		-- spaces icon
		if config["spaces"] then
			workspaces = {}
			for s, text in pairs(config["spaces"]) do
				workspaces[s] = text
			end
		end
	else
		alert("Config not loaded properly")
	end
end

 -- reads the config as a json file
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

-- reloads the config file on directory change
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

-- Initialisation
load_config(config_file_path)	-- load configuaration
local config_watcher = hs.pathwatcher.new(config_file_dir, reload_config):start() -- watch for file changes
set_workspaces()

-- hammerspoon config
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