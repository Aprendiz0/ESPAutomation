function o_routines_events_start()

    local timer = tmr.create()

    local eventsFunction = function()
        for key, value in pairs(o_events.events) do
            value:checkAndStart()
            o_log.print_log("checking event with id [" .. value.id .. "] to start +HP " .. node.heap())
        end
    end

    timer:register(10000, tmr.ALARM_AUTO, eventsFunction)
    timer:interval(1000)
    timer:start()

    o_routines.routines["events"] = timer;

end