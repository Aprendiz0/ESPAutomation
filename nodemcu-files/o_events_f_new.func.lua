function create_new_o_event(id, name, eventStartCondition, l_eventStart,
                            l_eventAction)

    local eventR = {
        id = id,
        name = name,
        eventStartCondition = eventStartCondition,
        l_eventStart = l_eventStart,
        l_eventAction = l_eventAction,
        lf_eventStart = {},
        lf_eventAction = {}
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

        if value.o_events == o_events.constants.eventAction.gpioWrite then

            eventActionFunction = function()
                gpio.mode(value.param.pin, gpio.OUTPUT)
                gpio.write(value.param.pin, value.param.val)
            end

        elseif value.o_events == o_events.constants.eventAction.dispatch then

            if value.param.val ~= eventR.id then
                eventActionFunction = function()
                    o_events.dispatch(value.param.val)
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

        if value.o_events == o_events.constants.eventStart.alone then

            eventStartFunction = function() return true end

        elseif value.o_events == o_events.constants.eventStart.gpioRead then

            eventStartFunction = function()
                gpio.mode(value.param.pin, gpio.INPUT)
                if gpio.read(value.param.pin) == value.param.val then
                    return true
                else
                    return false
                end
            end

        end

        if eventStartFunction then
            table.insert(eventR.lf_eventStart, eventStartFunction)
        end

        eventStartFunction = nil

    end

    eventR.checkStart = function()

        for k, value in pairs(eventR.lf_eventStart) do
            local v = value()
            if v and eventR.eventStartCondition ==
                o_events.constants.eventStartCondition.if_or then
                v = nil
                return true
            elseif not v and eventR.eventStartCondition ==
                o_events.constants.eventStartCondition.if_and then
                v = nil
                return false
            end
        end

        if eventR.eventStartCondition ==
            o_events.constants.eventStartCondition.if_or then
            return false;
        else
            return true;
        end

    end

    -- // End
    o_events.events[id] = eventR
    return eventR

end
