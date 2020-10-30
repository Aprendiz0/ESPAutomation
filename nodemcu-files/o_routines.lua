o_eventRoutines = {
    temp = {},
    routines = {},
    events = {
        init = o_general.file_function("of_routines_events_start.lua",
                                        "o_routines_events_start"),
        stop = o_general.file_function("of_routines_events_stop.lua",
                                       "o_eventRoutines_events_stop")
    }
}
