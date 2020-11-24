o_events = {temp = {}}

o_events.constants = {
    eventStartCondition = {if_and = 0, if_or = 1},
    eventStart = {alone = 0, gpioRead = 1},
    eventAction = {gpioWrite = 0, dispatch = 1}
}

o_events.events = {}

o_events.removeAllEvents = function()
    o_events.events = {}
    o_vars.save("saved_events", {})
    o_log.print_log("removed all events")
end

o_events.getEventsFromVars = function()
    local saved_events = o_vars.get("saved_events")
    for e, event in ipairs(saved_events) do
        create_new_o_event(event.id, event.name, event.startCondition, event.starts,
                     event.actions)
    end
    o_log.print_log("events loaded from vars")
end

o_events.getEvent = function(evId) return o_events.events[evId] end

o_events.removeEvent = function(evId) o_events.events[evId] = nil end

o_events.dispatch = function(disp_evId)
    local eventDisp = o_events.getEvent(disp_evId)
    if eventDisp then eventDisp.doAction() end
end

--[[
o_events.new =
    o_general.file_function("of_events_new.lua", "create_new_o_event")
]]

function create_new_o_event(id, name, eventStartCondition, l_eventStart,
                            l_eventAction)

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

    eventR.doAction = function()
        for key, value in pairs(eventR.lf_eventAction) do value() end
    end

    ------------------------------------------------
    -- define checkStart
    ------------------------------------------------
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

    eventR.checkStart = function()
        o_general.file_function("of_events_new_check_start.lua",
                                "events_new_check_start")(eventR.lf_eventStart,
                                                          eventR.eventStartCondition)
    end

    -- // End
    o_events.events[id] = eventR
    return eventR

end
