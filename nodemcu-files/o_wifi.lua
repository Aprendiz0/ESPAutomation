o_wifi = {

    setmode = function(mode)
        wifi.setmode(mode)
    end,

    setap = function()
        wifi.ap.config({
            ssid = v_wifi_ap_cfg_ssid,
            pwd = v_wifi_ap_cfg_password,
            max = v_wifi_ap_cfg_maxuser,
            auth = wifi.WPA_WPA2_PSK,
            save = false
        })

        wifi.ap.setip({ -- set IP,netmask, gateway
            ip = v_wifi_ap_ip_ip,
            netmask = v_wifi_ap_ip_netmask,
            gateway = v_wifi_ap_ip_gateway
        })

        print("Wifi openned")
    end,

    setsta = function()
        if v_wifi_sta_cfg_ssid then
            wifi.sta.config({
                ssid = v_wifi_sta_cfg_ssid,
                pwd = v_wifi_sta_cfg_password,
                save = false,
                auto = false
            })
            wifi.sta.connect()
        end
    end
}
