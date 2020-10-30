function o_wifi_register_events()
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
        o_log.print_log("\n\tSTA - CONNECTED" .. "\n\tSSID: " .. T.SSID ..
                            "\n\tBSSID: " .. T.BSSID .. "\n\tChannel: " ..
                            T.channel)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
        o_log.print_log("\n\tSTA - DISCONNECTED" .. "\n\tSSID: " .. T.SSID ..
                            "\n\tBSSID: " .. T.BSSID .. "\n\treason: " ..
                            T.reason)

        if T.reason == wifi.eventmon.reason.AUTH_EXPIRE then
            o_log.print_log("Wrong password for: " .. T.SSID)
            wifi.sta.disconnect()
        end
    end)

    wifi.eventmon.register(wifi.eventmon.STA_AUTHMODE_CHANGE, function(T)
        o_log.print_log("\n\tSTA - AUTHMODE CHANGE" .. "\n\told_auth_mode: " ..
                            T.old_auth_mode .. "\n\tnew_auth_mode: " ..
                            T.new_auth_mode)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
        o_log.print_log("\n\tSTA - GOT IP" .. "\n\tStation IP: " .. T.IP ..
                            "\n\tSubnet mask: " .. T.netmask ..
                            "\n\tGateway IP: " .. T.gateway)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, function()
        o_log.print_log("\n\tSTA - DHCP TIMEOUT")
    end)

    wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, function(T)
        o_log.print_log("\n\tAP - STATION CONNECTED" .. "\n\tMAC: " .. T.MAC ..
                            "\n\tAID: " .. T.AID)
    end)

    wifi.eventmon.register(wifi.eventmon.AP_STADISCONNECTED, function(T)
        o_log.print_log(
            "\n\tAP - STATION DISCONNECTED" .. "\n\tMAC: " .. T.MAC ..
                "\n\tAID: " .. T.AID)
    end)

    --[[
    wifi.eventmon.register(wifi.eventmon.AP_PROBEREQRECVED, function(T)
        o_log.print_log("\n\tAP - PROBE REQUEST RECEIVED" .. "\n\tMAC: " .. T.MAC ..
                  "\n\tRSSI: " .. T.RSSI)
    end)
    ]]

    wifi.eventmon.register(wifi.eventmon.WIFI_MODE_CHANGED, function(T)
        o_log.print_log("\n\tSTA - WIFI MODE CHANGED" .. "\n\told_mode: " ..
                            T.old_mode .. "\n\tnew_mode: " .. T.new_mode)
    end)

    o_log.print_log("Wifi events registred..")
end
