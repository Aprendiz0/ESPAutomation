o_general = {
    file_function = function(file_name, function_name)

        return function(...)
            return
                o_general.execute_file_function(file_name, function_name, ...)
        end

    end,
    execute_file_function = function(file_name, function_name, ...)
        dofile(file_name)
        local r = _G[function_name](...)
        _G[function_name] = nil
        return r
    end
}
