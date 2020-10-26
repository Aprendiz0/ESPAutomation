o_wifi = {

    setmode = function(mode)
        wifi.setmode(mode)
    end,

    setap = function()
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

        print("Wifi openned: " .. wifi_conf.ap.ssid)

        wifi_conf = nil
    end,

    setsta = function()
        local wifi_conf = o_vars.get("wifi_conf")

        if wifi_conf.sta_ssid then
            wifi.sta.config({
                ssid = wifi_conf.sta_ssid,
                pwd = wifi_conf.sta_pass,
                save = false,
                auto = false
            })
            print("connecting to: " .. wifi_conf.sta_ssid)
            print(wifi.sta.connect())
        end
        
        wifi_conf = nil
    end
}
