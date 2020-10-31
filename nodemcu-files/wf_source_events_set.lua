function source_events_set(sck, body)
    print(body)

    o_events.removeAllEvents()

    local l_events = sjson.decode(body)
    o_vars.save("saved_events", l_events)

    o_events.getEventsFromVars()

    sendHeader(sck, "application/json")
    sck:send('{ "ok": "true" }')
    finish(sck)
end
