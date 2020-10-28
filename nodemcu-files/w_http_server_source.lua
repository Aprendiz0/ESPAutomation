function source_wifi_get_ap(sck, body)

    wifi.sta.getap(function(t)

        local isFirst = true
        
        sendHeader(sck, "application/json")
        sck:send('[')

        print('finded wifi 2')

        for ssid, v in pairs(t) do
            local authmode, rssi, bssid, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]+)")

            if not isFirst then
                sck:send(',')
            else
                isFirst = false
            end

            sck:send('{ "ssid": "' .. ssid .. '", "bssid": "' .. bssid ..
                         '", "rssi": "' .. rssi .. '", "authmode": "' ..
                         authmode .. '", "channel": "' .. channel .. '" }')

        end

        isFirst = nil

        sck:send(']')
        finish(sck)

    end)
    
end

function source_wifi_set(sck, body)
    print(body)
    sendHeader(sck, "application/json")
    sck:send('{ "ok": "true" }')
    finish(sck)
end

function source_events_set(sck, body)
    for i, line in ipairs(sjson.decode(body)) do
        print(i)
        print(sjson.encode(line))
        print(line["id"])
        print(line.id)
    end
    sendHeader(sck, "application/json")
    sck:send('{ "ok": "true" }')
    finish(sck)
end

source_data = {
    GET = {
        [0] = {file = "h_events.html", path = "/events"},
        [1] = {file = "h_home.html", path = "/home"},
        [2] = {file = "h_wifi_config.html", path = "/wifi_config"},
        [3] = {file = "h_not_found.html", path = "/404"},
        [4] = {file = "h_wifi_config.html", path = "/"} -- to test
    },
    POST = {
        [0] = {path = "/wifi/getap", func = source_wifi_get_ap},
        [1] = {path = "/wifi/set", func = source_wifi_set},
        [2] = {path = "/events/set", func = source_events_set}
    }
}
