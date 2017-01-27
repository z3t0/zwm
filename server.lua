spaces = require("hs._asm.undocumented.spaces")
require("spaces")

local function received(msg)
	print("Server Received : '" .. msg .. "'")
	if msg == "connect" then
	end
end

local function callback(req, path, hed, raw)
	print("callback")
end

-- [[
-- Commands:
-- 		0 : spaces
--
--]]
function send_spaces()
	local all_spaces = get_spaces()
	local current = spaces.activeSpace()
	local output = "1 "

	local i = 0
	
	for i in ipairs(all_spaces) do
		if all_spaces[i] == current then
			output = output .. tostring(i) .. "* "
		else 
			output = output .. tostring(i) .. " "
		end
	end

	ws:send(output)
end

ws = hs.httpserver.new()
ws:websocket("/zwm", received)
ws:setCallback(callback)
ws:setPort(8888)
ws:start()

send_spaces()