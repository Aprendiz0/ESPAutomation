-- first load
function o_vars_first_load()
    if not file.exists(o_vars.build_name("wifi_conf")) then
        local table = {}
        table.ap_ssid = "teste"
        table.ap_pass = "teste1234"
        table.ap_maxu = "1"
        table.ap_ip = "192.168.4.1"
        table.ap_netm = "255.255.255.0"
        table.ap_gatw = "192.168.4.1"
        table.sta_ssid = "Claro Virtua 172 2.4g"
        table.sta_pass = "10877520"
        o_vars.save("wifi_conf", table)
        table = nil
        o_log.print_log("first o_vars ok")
    end
end
-- first load
