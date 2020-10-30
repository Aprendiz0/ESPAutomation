function o_eventRoutines_events_start()

    local timer = o_eventRoutines.routines["events"];

    if timer then
        timer:stop()
        timer:unregister()
    end

    o_eventRoutines.routines["events"] = nil;

end
