source_data = {
    GET = {
        [0] = {file = "events.html", path = "/"},
        [1] = {file = "home.html", path = "/home"},
        [2] = {file = "wifi_config.html", path = "/wifi_config"},
        [3] = {file = "not_found.html", path = "/404"}
    },
    POST = {
        [0] = {path = "/wifi/getap", func = source_wifi_get_ap},
        [1] = {path = "/wifi/set", func = source_wifi_set},
        [2] = {path = "/events/set", func = source_events_set}
    }
}

function source_wifi_get_ap(sck, body)
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
end

function source_wifi_set(sck, body)
    sendHeader(sck, "application/json")
    sck:send('{ "ok": "true" }')
    finish(sck)
end

function source_events_set(sck, body)
    for i, line in ipairs(sjson.deconde(body)) do
        print(i)
        print(sjson.encode(line))
        print(line["id"])
        print(line.id)
    end
    sendHeader(sck, "application/json")
    sck:send('{ "ok": "true" }')
    finish(sck)
end
