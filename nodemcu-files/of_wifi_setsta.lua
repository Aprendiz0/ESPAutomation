function o_wifi_setsta()
    local wifi_conf = o_vars.get("wifi_conf")

    if wifi_conf.sta_ssid then
        wifi.sta.config({
            ssid = wifi_conf.sta_ssid,
            pwd = wifi_conf.sta_pass,
            save = false,
            auto = false
        })
        o_log.print_log("connecting to: " .. wifi_conf.sta_ssid)
        wifi.sta.connect(function(t)
            o_log.print_log("Connected to: " .. t.SSID)
        end)
    end

    wifi_conf = nil
end