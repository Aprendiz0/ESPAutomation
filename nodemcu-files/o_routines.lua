o_routines = {
    temp = {},
    routines = {},
    events = {
        start = o_general.file_function("of_routines_events_start.lua",
                                        "o_routines_events_start"),
        stop = o_general.file_function("of_routines_events_stop.lua",
                                       "o_routines_events_stop")
    }
}