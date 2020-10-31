function o_routines_events_stop()

    local timer = o_routines.routines["events"];

    if timer then
        timer:stop()
        timer:unregister()
    end

    o_routines.routines["events"] = nil;

end
