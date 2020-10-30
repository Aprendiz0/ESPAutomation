o_wifi = {

    setap = o_general.file_function("of_wifi_setap.func.lua", "o_wifi_setap"),

    setsta = o_general.file_function("of_wifi_setsta.func.lua", "o_wifi_setsta"),

    register_events = o_general.file_function("of_wifi_register_events.func.lua",
                                              "o_wifi_register_events"),

    unregister_events = o_general.file_function(
        "o_wifi_unregister_events.func.lua", "o_wifi_unregister_events")
}