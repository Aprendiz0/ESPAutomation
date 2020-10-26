o_vars = {
    prefix_name = "o_vars_eeprom_",

    build_name = function(name) return o_vars.prefix_name .. name end,

    save = function(name, table)
        local content = sjson.encode(table)
        local ok = file.putcontents(o_vars.build_name(name), content)
        print(o_vars.build_name(name) .. " saved with content: " .. content)
        return ok
    end,

    get = function(name)
        if file.exists(o_vars.build_name(name)) then
            local content = file.getcontents(o_vars.build_name(name))
            print("read content of file '" .. o_vars.build_name(name) .. "': " ..
                      content)
            return sjson.decode(content)
        end
        return nil
    end
}

-- first load
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
    print("first o_vars ok")
end
-- first load
