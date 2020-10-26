require("http_server_source")

srv = net.createServer(net.TCP)

srv:listen(80, function(conn)
    conn:on("receive", function(sck, request)

        local _, _, method, path, query =
            string.find(request, "([A-Z]+) (.+)?(.+) HTTP");

        if (method == nil) then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end

        local body = string.match(request, "\r\n\r\n(.*)")

        print("+H", method, path, query, node.heap())

        local source_data_method = source_data[method]

        if source_data_method then
            local source = find_source(source_data_method, path)
            if source then
                if source.file then
                    sendfile(sck, "text/html", source.file)
                elseif source.func then
                    source.func(sck, body)
                end
            else
                source = find_source(source_data_method, "/404")
                if source.file then
                    sendfile(sck, "text/html", source.file)
                elseif source.func then
                    source.func(sck, body)
                end
            end
            source = nil
        end
        source_data_method = nil
        method = nil
        path = nil
        query = nil
        body = nil
    end)

end)

function sendHeader(sck, contentType)
    sck:send("HTTP/1.1 200 OK\r\n" .. "Server: NodeMCU on ESP8266\r\n" ..
                 "Content-Type: " .. contentType .. "; charset=UTF-8\r\n\r\n")
end

function finish(sck)
    sck:close()
    collectgarbage("collect")
    print("+NS", node.heap())
end

function sendfile(sck, contentType, fileName)
    local fd = nil

    local function send(localSocket)
        local str = fd.readline()
        if str then
            localSocket:send(str)
        else
            fd.close()
            fd = nil
            finish(localSocket)
        end
        str = nil
    end

    fd = file.open(fileName)
    sck:on("sent", send) -- triggers the send() function again once the first chunk of data was sent

    sendHeader(sck, contentType)
    send(sck)

end

function find_source(source_data_method, path)
    for k, value in pairs(source_data_method) do
        if value.path ~= nil and value.path == path then return value end
    end
    return nil
end
