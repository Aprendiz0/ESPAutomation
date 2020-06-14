url_data = {
    root = {
        url = "/",
        file = "index.html"
    },
    not_found = {
        file = "not_found.html"
    },
    wifi = {
        getap = {
            url = "/wifi/getap"
        },
        set = {
            url = "/wifi/set"
        }
    },
    files = {
        home = "home.html",
        wifi_config = "wifi_config.html",
    } 
}

srv = net.createServer(net.TCP)

srv:listen(80, function(conn)
    conn:on("receive", function(sck, request)
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if (method == nil) then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        print("+H", method, path, vars, node.heap())

        -- sck:send("<h1> Hello, NodeMCU.</h1>")

        -- sendfile(sck, "index.html")

        if method == "GET" then

            if path == url_data.root.url then
                sendfile(sck, "text/html", url_data.root.file)
            elseif path == url_data.wifi.getap.url then

                wifi.sta.getap(function(t)

                    sendHeader(sck, "application/json")
                    sck:send('[')
                    local isFirst = true

                    for name, info in pairs(t) do
                        if not isFirst then
                            sck:send(',')
                        else
                            isFirst = false
                        end
                        sck:send('{ "name": "' .. name .. '", "info": "' .. info .. '" }')
                    end

                    sck:send(']')
                    finish(sck)

                end)

            elseif path == ("/" .. url_data.files.home) then
                sendfile(sck, "text/html", url_data.files.home)
            elseif path == ("/" .. url_data.files.wifi_config) then
                sendfile(sck, "text/html", url_data.files.wifi_config)
            else
                sendfile(sck, "text/html", url_data.not_found.file)
            end

        elseif method == "POST" then

            if path == url_data.wifi.set.url then
                getEncodedJson(request)
                sendHeader(sck, "application/json")
                sck:send('{ "ok": "true" }')
                finish(sck)

            end

        end
    end)

end)

function sendfile(sck, contentType, fileName)
    local function send(localSocket)
        local str = file.readline()
        if str then
            localSocket:send(str)
        else
            finish(sck)
        end
    end

    file.open(fileName)
    sck:on("sent", send) -- triggers the send() function again once the first chunk of data was sent
    send(sck)
end

function finish(sck)
    sck:close()
    collectgarbage("collect")
    print("+NS", node.heap())
end

function sendHeader(sck, contentType)

    sck:send("HTTP/1.1 200 OK\r\n" .. "Server: NodeMCU on ESP8266\r\n" .. "Content-Type: " .. contentType ..
                 "; charset=UTF-8\r\n\r\n")

end

function getEncodedJson(request)
    local str = string.match(request, "\r\n\r\n(.*)")
    print(str)
    return sjson.decode(str)
end
