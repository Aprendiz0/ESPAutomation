o_general = {
    file_function = function(file_name, function_name)
        return function(...)
            dofile(file_name)
            local r = _G[function_name](...)
            _G[function_name] = nil
            return r
        end

    end
}
