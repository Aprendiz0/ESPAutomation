--[[

-- to test
gpio = {
    OUTPUT = 0,
    INPUT = 1,
    LOW = 0,
    HIGH = 1,
    mode = function(pin, val)
        print("GPIO MODE: pin " .. pin .. " / mode: " .. val)
    end,
    write = function(pin, val)
        print("GPIO WRITE: pin " .. pin .. " / val: " .. val)
    end,
    read = function(pin)
        local val = gpio.LOW
        print("GPIO READ: pin " .. pin .. " / val: " .. val)
        return val
    end
}
-- to test

]] o_events = {}

o_events.constants = {
    eventStartCondition = {if_and = 0, if_or = 1},
    eventStart = {alone = 0, gpioRead = 1},
    eventAction = {gpioWrite = 0, dispatch = 1}
}

o_events.events = {}

o_events.getEvent = function(evName) return o_events.events[evName] end

o_events.removeEvent = function(evName) o_events.events[evName] = nil end

o_events.dispatch = function(evName)
    local eventDisp = o_events.getEvent(evName)
    if eventDisp then eventDisp.doAction() end
end

o_events.new = function(id, name, eventStartCondition, l_eventStart, l_eventAction)

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
        eventR.eventStartCondition = o_events.constants.eventStartCondition.if_and
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

--[[
-- teste do evento
print("--- criando evento 1")
local eventoTeste = o_events.new(1, "teste", nil, {
    {o_events = o_events.constants.eventStart.alone, param = nil}
}, {
    {
        o_events = o_events.constants.eventAction.gpioWrite,
        param = {pin = 5, val = gpio.HIGH}
    }
})

--
-- prints
print(eventoTeste.name)
eventoTeste.doAction()

print("checkAndStart")
eventoTeste.checkAndStart()

-- prints dispatch
print("dispatch 1")
o_events.dispatch(1)

-- teste do evento
print("--- criando evento 2")
local eventoTeste2 = o_events.new(2, "teste 2", nil, {
    {o_events = o_events.constants.eventStart.alone, param = nil}
}, {
    {
        o_events = o_events.constants.eventAction.dispatch,
        param = {val = eventoTeste.id}
    }
})

-- prints dispatch
print("dispatch by o_events 2, action 1")
eventoTeste2.doAction()

-- teste do evento
print("--- criando evento 3")
local eventoTeste3 = o_events.new(3, "teste 3", nil, {
    {
        o_events = o_events.constants.eventStart.gpioRead,
        param = {pin = 3, val = gpio.LOW}
    }
}, {
    {
        o_events = o_events.constants.eventAction.gpioWrite,
        param = {pin = 1, val = gpio.HIGH}
    }
})

-- prints dispatch
print("dispatch by action 3")
eventoTeste3.checkAndStart()
]]
