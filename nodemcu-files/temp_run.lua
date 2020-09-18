wifi.sta.getap(function(t)

    for name, info in pairs(t) do
        print('{ "name": "' .. name .. '", "info": "' .. info .. '" }')
    end

end)