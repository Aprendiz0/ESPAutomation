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

event = {}

event.constants = {
    eventStartCondition = {if_and = 0, if_or = 1},
    eventStart = {alone = 0, gpioRead = 1},
    eventAction = {gpioWrite = 0, dispatch = 1}
}

event.events = {}

event.getEvent = function(evName) return event.events[evName] end

event.removeEvent = function(evName) event.events[evName] = nil end

event.dispatch = function(evName)
    local eventDisp = event.getEvent(evName)
    if eventDisp then eventDisp.doAction() end
end

event.new = function(id, name, eventStartCondition, l_eventStart, l_eventAction)

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
        eventR.eventStartCondition = event.constants.eventStartCondition.if_and
    end

    -- // event standard function
    -- checkAndStart
    -- // event standard function

    -- // event functions
    -- doAction
    -- checkStart
    -- // event functions

    -- -- event standard function

    eventR.checkAndStart = function()
        if eventR.checkStart() then eventR.doAction() end
    end

    ------------------------------------------------
    -- -- event functions
    ------------------------------------------------

    ------------------------------------------------
    -- define doAction
    ------------------------------------------------
    for key, value in pairs(eventR.l_eventAction) do

        local eventActionFunction = nil

        if value.event == event.constants.eventAction.gpioWrite then

            eventActionFunction = function()
                gpio.mode(value.param.pin, gpio.OUTPUT)
                gpio.write(value.param.pin, value.param.val)
            end

        elseif value.event == event.constants.eventAction.dispatch then

            if value.param.val ~= eventR.id then
                eventActionFunction = function()
                    event.dispatch(value.param.val)
                end
            end

        end

        if eventActionFunction then
            table.insert(eventR.lf_eventAction, eventActionFunction)
        end

    end

    eventR.doAction = function()
        for key, value in pairs(eventR.lf_eventAction) do value() end
    end

    ------------------------------------------------
    -- define checkStart
    ------------------------------------------------
    for key, value in pairs(eventR.l_eventStart) do

        local eventStartFunction = nil

        if value.event == event.constants.eventStart.alone then

            eventStartFunction = function() return true end

        elseif value.event == event.constants.eventStart.gpioRead then

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

    end

    eventR.checkStart = function()

        for key, value in pairs(eventR.lf_eventStart) do
            local v = value()
            if v and eventR.eventStartCondition ==
                event.constants.eventStartCondition.if_or then
                return true
            elseif not v and eventR.eventStartCondition ==
                event.constants.eventStartCondition.if_and then
                return false
            end
        end

        if eventR.eventStartCondition ==
            event.constants.eventStartCondition.if_or then
            return false;
        else
            return true;
        end

    end

    -- // End
    event.events[id] = eventR
    return eventR

end

--[[
-- teste do evento
print("--- criando evento 1")
local eventoTeste = event.new(1, "teste", nil, {
    {event = event.constants.eventStart.alone, param = nil}
}, {
    {
        event = event.constants.eventAction.gpioWrite,
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
event.dispatch(1)

-- teste do evento
print("--- criando evento 2")
local eventoTeste2 = event.new(2, "teste 2", nil, {
    {event = event.constants.eventStart.alone, param = nil}
}, {
    {
        event = event.constants.eventAction.dispatch,
        param = {val = eventoTeste.id}
    }
})

-- prints dispatch
print("dispatch by event 2, action 1")
eventoTeste2.doAction()

-- teste do evento
print("--- criando evento 3")
local eventoTeste3 = event.new(3, "teste 3", nil, {
    {
        event = event.constants.eventStart.gpioRead,
        param = {pin = 3, val = gpio.LOW}
    }
}, {
    {
        event = event.constants.eventAction.gpioWrite,
        param = {pin = 1, val = gpio.HIGH}
    }
})

-- prints dispatch
print("dispatch by action 3")
eventoTeste3.checkAndStart()
]]
