eventRoutines = {
    routines = {},
    events = {
        start = function()

            local timer = tmr.create()

            local eventsFunction = function()
                for key, value in pairs(event.events) do
                    value:checkAndStart()
                end
            end

            timer:register(10000, tmr.ALARM_AUTO, eventsFunction)
            timer:interval(1000)
            timer:start()

            eventRoutines.routines["events"] = timer;

        end,
        stop = function()

            local timer = eventRoutines.routines["events"];

            if timer then
                timer:stop()
                timer:unregister()
            end

            eventRoutines.routines["events"] = nil;
            
        end
    }
}
