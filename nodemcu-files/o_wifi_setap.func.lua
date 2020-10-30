function o_wifi_setap()
    local wifi_conf = o_vars.get("wifi_conf")

    wifi.ap.config({
        ssid = wifi_conf.ap_ssid,
        pwd = wifi_conf.ap_pass,
        max = wifi_conf.ap_maxu,
        auth = wifi.WPA_WPA2_PSK,
        save = false
    })

    wifi.ap.setip({ -- set IP,netmask, gateway
        ip = wifi_conf.ap_ip,
        netmask = wifi_conf.ap_netm,
        gateway = wifi_conf.ap_getw
    })

    o_log.print_log("Wifi openned: " .. wifi_conf.ap.ssid)

    wifi_conf = nil
end