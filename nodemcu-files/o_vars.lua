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

    getJSON = function (name)
        if file.exists(o_vars.build_name(name)) then
            return file.getcontents(o_vars.build_name(name))
        end
        return nil
    end,

    get = function(name)
        local content = o_vars.getJSON(name)
        if content then
            o_log.print_log(
                "read content of file '" .. o_vars.build_name(name) .. "': " ..
                    content)
            return sjson.decode(content)
        end
        return nil
    end
}

-- first load
o_general.file_function("of_vars_first_load.lua", "o_vars_first_load")()
-- first load
