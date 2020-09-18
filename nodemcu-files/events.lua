-- to test
gpio = {
    OUTPUT = 0,
    HIGH = 1,
    mode = function(pin, val)
        print("GPIO MODE: pin " .. pin .. " / mode: " .. val)
    end,
    write = function(pin, val)
        print("GPIO WRITE: pin " .. pin .. " / val: " .. val)
    end
}
-- to test

event = {}

event.constants = {
    startEv = {allone = 0, onGpioRead = 1},
    eventAction = {gpio = {write = 0}, dispatch = 1}
}

event.events = {}

event.getEvent = function(evName) return event.events[evName] end

event.dispatch = function(evName)
    local eventDisp = event.getEvent(evName)
    if eventDisp then eventDisp.doAction() end
end

event.new = function(id, name, startEv, startEvParams, eventAction,
                     eventActionParams)

    local eventR = {
        id = id,
        name = name,
        startEv = startEv,
        startEvParams = startEvParams,
        eventAction = eventAction,
        eventActionParams = eventActionParams
    }

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

    -- -- event functions
    -- define doAction
    if eventAction == event.constants.eventAction.gpio.write then

        gpio.mode(eventR.eventActionParams.pin, gpio.HIGH)

        eventR.doAction = function()
            gpio.write(eventR.eventActionParams.pin, eventR.eventActionParams.val)
        end

    elseif eventAction == event.constants.eventAction.dispatch then

        if eventR.eventActionParams.val ~= eventR.id then
            eventR.doAction = function()
                event.dispatch(eventR.eventActionParams.val)
            end
        end

    end

    if eventR.doAction == nil then eventR.doAction = function() end end

    -- define checkStart

    if eventR.checkStart == nil then
        eventR.checkStart = function() return true end
    end

    -- // End
    event.events[id] = eventR
    return eventR

end

-- teste do evento
local eventoTeste = event.new(1, "teste", event.constants.startEv.allone, nil,
                        event.constants.eventAction.gpio.write,
                        {pin = 1, val = gpio.HIGH})

-- prints
print(eventoTeste.name)
eventoTeste.doAction()

print("checkAndStart")
eventoTeste.checkAndStart()

-- prints dispatch
print("dispatch 1")
event.dispatch(1)

-- teste do evento
local eventoTeste2 = event.new(2, "teste", event.constants.startEv.allone, nil,
                         event.constants.eventAction.dispatch,
                         {val = 1})

-- prints dispatch
print("dispatch by action 1")
eventoTeste2.doAction()
