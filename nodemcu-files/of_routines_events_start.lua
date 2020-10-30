function o_eventRoutines_events_start()

    local timer = tmr.create()

    local eventsFunction = function()
        for key, value in pairs(o_events.events) do
            value:checkAndStart()
        end
    end

    timer:register(10000, tmr.ALARM_AUTO, eventsFunction)
    timer:interval(1000)
    timer:start()

    o_eventRoutines.routines["events"] = timer;

end