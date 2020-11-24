function create_new_o_event(id, name, eventStartCondition, l_eventStart,
                            l_eventAction)

    print("e: " .. node.heap())
    local eventR = {
        id = id,
        name = name,
        eventStartCondition = eventStartCondition,
        l_eventStart = l_eventStart,
        l_eventAction = l_eventAction,
        lf_eventStart = {},
        lf_eventAction = {},
        state = {}
    }

    if eventR.eventStartCondition == nil then
        eventR.eventStartCondition = o_events.constants.eventStartCondition
                                         .if_and
    end
    print("f: " .. node.heap())

    -- // o_events standard function
    -- checkAndStart
    -- // o_events standard function

    -- // o_events functions
    -- doAction
    -- checkStart
    -- // o_events functions

    -- -- o_events standard function

    eventR.checkAndStart = function()
        if eventR.checkStart() then eventR.doAction() end
    end

    ------------------------------------------------
    -- -- o_events functions
    ------------------------------------------------

    ------------------------------------------------
    -- define doAction
    ------------------------------------------------
    print("a: " .. node.heap())
    for key, value in pairs(eventR.l_eventAction) do

        local eventActionFunction = nil

        if value.type == o_events.constants.eventAction.gpioWrite then

            eventActionFunction = function()
                o_general.file_function("of_events_new_action_gpw.lua",
                                        "events_new_action_gpw")(eventR.id,
                                                                 value.param.pin,
                                                                 value.param.val)
            end

        elseif value.type == o_events.constants.eventAction.dispatch then

            if value.param.val ~= eventR.id then
                eventActionFunction = function()
                    o_general.file_function("of_events_new_action_disp.lua",
                                            "events_new_action_disp")(eventR.id,
                                                                      value.param
                                                                          .val)
                end
            end

        end

        if eventActionFunction then
            table.insert(eventR.lf_eventAction, eventActionFunction)
        end

        eventActionFunction = nil
    end

    print("b: " .. node.heap())
    eventR.doAction = function()
        for key, value in pairs(eventR.lf_eventAction) do value() end
    end

    ------------------------------------------------
    -- define checkStart
    ------------------------------------------------
    print("c: " .. node.heap())
    for key, value in pairs(eventR.l_eventStart) do

        local eventStartFunction = nil

        if value.type == o_events.constants.eventStart.alone then

            eventStartFunction = function()
                o_log.print_log("event[" .. eventR.id ..
                                    "] check: event starting alone")
                return true
            end

        elseif value.type == o_events.constants.eventStart.gpioRead then

            eventStartFunction = function()
                o_general.file_function("of_events_new_start_gpr.lua",
                                        "events_new_start_gpr")(eventR.id,
                                                                value.param.pin,
                                                                value.param.val)
            end

        end

        if eventStartFunction then
            table.insert(eventR.lf_eventStart, eventStartFunction)
        end

        eventStartFunction = nil

    end
    print("d: " .. node.hedp())

    eventR.checkStart = function()
        o_general.file_function("of_events_new_check_start.lua",
                                "events_new_check_start")(eventR.lf_eventStart,
                                                          eventR.eventStartCondition)
    end

    -- // End
    o_events.events[id] = eventR
    return eventR

end
