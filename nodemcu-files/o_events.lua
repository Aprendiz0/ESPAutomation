--[[

-- to test
gpio = {
    OUTPUT = 0,
    INPUT = 1,
    LOW = 0,
    HIGH = 1,
    mode = function(pin, val)
        o_log.print_log("GPIO MODE: pin " .. pin .. " / mode: " .. val)
    end,
    write = function(pin, val)
        o_log.print_log("GPIO WRITE: pin " .. pin .. " / val: " .. val)
    end,
    read = function(pin)
        local val = gpio.LOW
        o_log.print_log("GPIO READ: pin " .. pin .. " / val: " .. val)
        return val
    end
}
-- to test

]] o_events = {temp = {}}

o_events.constants = {
    eventStartCondition = {if_and = 0, if_or = 1},
    eventStart = {alone = 0, gpioRead = 1},
    eventAction = {gpioWrite = 0, dispatch = 1}
}

o_events.events = {}

o_events.getEvent = function(evId) return o_events.events[evId] end

o_events.removeEvent = function(evId) o_events.events[evId] = nil end

o_events.dispatch = function(evId)
    local eventDisp = o_events.getEvent(evId)
    if eventDisp then eventDisp.doAction() end
end

o_events.new = o_general.file_function("o_events_f_new.func.lua",
                                       "create_new_o_event")

--[[
-- teste do evento
o_log.print_log("--- criando evento 1")
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
o_log.print_log(eventoTeste.name)
eventoTeste.doAction()

o_log.print_log("checkAndStart")
eventoTeste.checkAndStart()

-- prints dispatch
o_log.print_log("dispatch 1")
o_events.dispatch(1)

-- teste do evento
o_log.print_log("--- criando evento 2")
local eventoTeste2 = o_events.new(2, "teste 2", nil, {
    {o_events = o_events.constants.eventStart.alone, param = nil}
}, {
    {
        o_events = o_events.constants.eventAction.dispatch,
        param = {val = eventoTeste.id}
    }
})

-- prints dispatch
o_log.print_log("dispatch by o_events 2, action 1")
eventoTeste2.doAction()

-- teste do evento
o_log.print_log("--- criando evento 3")
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
o_log.print_log("dispatch by action 3")
eventoTeste3.checkAndStart()
]]
