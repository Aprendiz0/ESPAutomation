vars = {
    prefix_name = "vars_eeprom_",

    build_name = function(name) return vars.prefix_name .. name end,

    save = function(name, table)
        local content = sjson.encode(table)
        local ok = file.putcontents(vars.build_name(name), content)
        print(vars.build_name(name) .. " saved with content: " .. content)
        return ok
    end,

    get = function(name)
        if file.exists(vars.build_name(name)) then
            local content = file.getcontents(vars.build_name(name))
            print("read content of file '" .. vars.build_name(name) .. "': " ..
                      content)
            return sjson.decode(content)
        end
        return nil
    end
}

-- first load
if not file.exists(vars.build_name("wifi_conf")) then
    local table = {}
    table.ap_ssid = "teste"
    table.ap_pass = "teste1234"
    table.ap_maxu = "1"
    table.ap_ip = "192.168.4.1"
    table.ap_netm = "255.255.255.0"
    table.ap_gatw = "192.168.4.1"
    table.sta_ssid = "Claro Virtua 172 2.4g"
    table.sta_pass = "10877520"
    vars.save("wifi_conf", table)
    table = nil
    print("first vars ok")
end
-- first load
