local function received(msg)
    print("Server Received : '" .. msg .. "'")
    if msg == "connect" then
        return "success"
    end
end

local function callback(req, path, hed, raw)
    print("callback")
end

ws = hs.httpserver.new()
ws:websocket("/zwm", received)
ws:setCallback(callback)
ws:setPort(8888)
ws:start()
hs.printf("port : " .. tostring(ws:getPort()))