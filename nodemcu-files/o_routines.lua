o_eventRoutines = {
    temp = {},
    routines = {},
    events = {
        init = o_general.file_function("of_routines_events_init.func.lua",
                                        "o_eventRoutines_events_init"),
        stop = o_general.file_function("of_routines_events_stop.func.lua",
                                       "o_eventRoutines_events_stop")
    }
}
