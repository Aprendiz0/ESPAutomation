function source_events_set(sck, body)
    print(body)
    for i, line in ipairs(sjson.decode(body)) do
        print(i)
        print(sjson.encode(line))
        print(line["id"])
        print(line.id)
    end
    sendHeader(sck, "application/json")
    sck:send('{ "ok": "true" }')
    finish(sck)
end