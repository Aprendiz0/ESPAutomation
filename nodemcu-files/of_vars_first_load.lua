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
        table.sta_ssid = "Casa network 100Mb"
        table.sta_pass = "1357924680"
        o_vars.save("wifi_conf", table)
        table = nil
    end

    if not file.exists(o_vars.build_name("saved_events")) then
        local table = {}
        o_vars.save("saved_events", table)
        table = nil
    end
    
    o_log.print_log("first o_vars ok")
    
end
-- first load
