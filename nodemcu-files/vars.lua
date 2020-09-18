-- Wifi AP config
v_wifi_ap_cfg_ssid = "teste"
v_wifi_ap_cfg_password = "teste1234"
v_wifi_ap_cfg_maxuser = 1
v_wifi_ap_ip_ip = "192.168.4.1"
v_wifi_ap_ip_netmask = "255.255.255.0"
v_wifi_ap_ip_gateway = "192.168.4.1"
v_wifi_sta_cfg_ssid = "Casa network"
v_wifi_sta_cfg_password = "xxxxxxxx"

vars = {
    save = function()
        file.putcontents("vars_eeprom", content .. "\n" .. name .. "=" .. value)
        for key, value in pairs(vars.get) do
            print(key)
        end
    end,

    load = function()
        if file.exists("vars_eeprom") then
            for key, value in pairs(vars.get) do
                print(key)
            end
        end
    end,

    get = {
        
    }
}

vars.load()
