function source_get_saved_events(sck, body)

    local content = o_vars.getJSON("saved_events")
    local leng = string.len(content)
    sendHeader(sck, "application/json")

    for i = 1, leng, 100 do
        local cont = string.sub(content, i, (i + 99))
        if cont and cont ~= "" then
            sck:send(cont)
        end
    end

    finish(sck)

end
