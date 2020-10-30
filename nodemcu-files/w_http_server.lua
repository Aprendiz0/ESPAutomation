source_data = {
    GET = {
        [0] = {file = "h_home.html", path = "/"},
        [1] = {file = "h_events.html", path = "/events"},
        [2] = {file = "h_wifi_config.html", path = "/wifi_config"},
        [3] = {file = "h_not_found.html", path = "/404"}
    },
    POST = {
        [0] = {
            path = "/wifi/getap",
            func = o_general.file_function("wf_source_wifi_get_ap.lua",
                                           "source_wifi_get_ap")
        },
        [1] = {
            path = "/wifi/set",
            func = o_general.file_function("wf_source_wifi_set.lua",
                                           "source_wifi_set")
        },
        [2] = {
            path = "/events/set",
            func = o_general.file_function("wf_source_events_set.lua",
                                           "source_events_set")
        }
    }
}

srv = net.createServer(net.TCP)

srv:listen(80, function(conn)
    conn:on("receive", function(sck, request)

        local _, _, method, path, query =
            string.find(request, "([A-Z]+) (.+)?(.+) HTTP");

        if (method == nil) then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end

        local body = string.match(request, "\r\n\r\n(.*)")

        o_log.print_log("+H", method, path, query, node.heap())

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
    sck:on("sent", function(lsck) lsck:close() end)
    sck:send("\n")
    collectgarbage("collect")
    o_log.print_log("+NS", node.heap())
end

function sendfile(sck, contentType, fileName)
    local fd = nil

    local function send(lsck)
        local str = fd.readline()
        if str then
            lsck:send(str)
        else
            fd.close()
            fd = nil
            finish(lsck)
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
