o_vars = {
    prefix_name = "eeprom_vars_",

    build_name = function(name) return o_vars.prefix_name .. name end,

    save = function(name, table)
        local content = sjson.encode(table)
        local ok = file.putcontents(o_vars.build_name(name), content)
        o_log.print_log(o_vars.build_name(name) .. " saved with content: " ..
                            content)
        return ok
    end,

    get = function(name)
        if file.exists(o_vars.build_name(name)) then
            local content = file.getcontents(o_vars.build_name(name))
            o_log.print_log(
                "read content of file '" .. o_vars.build_name(name) .. "': " ..
                    content)
            return sjson.decode(content)
        end
        return nil
    end
}

-- first load
o_general.execute_file_function("of_vars_first_load.lua", "o_vars_first_load")
-- first load
