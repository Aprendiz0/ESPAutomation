function source_wifi_get_ap(sck, body)

    wifi.sta.getap(function(t)

        local isFirst = true

        sendHeader(sck, "application/json")
        sck:send('[')

        o_log.print_log('finded wifi 2')

        for ssid, v in pairs(t) do
            local authmode, rssi, bssid, channel =
                string.match(v, "([^,]+),([^,]+),([^,]+),([^,]+)")

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