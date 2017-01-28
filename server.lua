spaces = require("hs._asm.undocumented.spaces")
require("spaces")


local function callback(req, path, hed, raw)
	print("callback")
end

-- [[
-- Commands:
-- 		0 : spaces
--
--]]
--

function get_message(code)
	message = nil

	if code == 0 then
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

		message = output
	end

	return message
end

function send_spaces()
	ws:send(get_message(0))
end


local function received(msg)
	print("Server Received : '" .. msg .. "'")
	if msg == "connect" then
		sending = get_message(0)
	end

	return sending
end

ws = hs.httpserver.new()
ws:websocket("/zwm", received)
ws:setCallback(callback)
ws:setPort(8888)
ws:start()