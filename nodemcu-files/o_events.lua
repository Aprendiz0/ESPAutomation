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
        o_events.new(event.id, event.name, event.startCondition, event.starts,
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

o_events.new =
    o_general.file_function("of_events_new.lua", "create_new_o_event")

--[[
-- teste do evento
print("--- criando evento 1")
local eventoTeste = o_events.new(1, "teste", nil, {
    {type = o_events.constants.eventStart.alone, param = nil}
}, {
    {
        type = o_events.constants.eventAction.gpioWrite,
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
    {type = o_events.constants.eventStart.alone, param = nil}
}, {
    {
        type = o_events.constants.eventAction.dispatch,
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
        type = o_events.constants.eventStart.gpioRead,
        param = {pin = 3, val = gpio.LOW}
    }
}, {
    {
        type = o_events.constants.eventAction.gpioWrite,
        param = {pin = 1, val = gpio.HIGH}
    }
})

-- prints dispatch
print("dispatch by action 3")
eventoTeste3.checkAndStart()
]]
