o_eventRoutines = {
    routines = {},
    events = {
        start = function()

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

        end,
        stop = function()

            local timer = o_eventRoutines.routines["events"];

            if timer then
                timer:stop()
                timer:unregister()
            end

            o_eventRoutines.routines["events"] = nil;
            
        end
    }
}
