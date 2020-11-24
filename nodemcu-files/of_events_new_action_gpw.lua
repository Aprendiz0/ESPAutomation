function events_new_action_gpw(evId, pin, val)
    --[[ gpio.mode(pin, gpio.INPUT)
    local r = gpio.read(pin)
    if r ~= value.param.state then
        value.param.state = r ]]
        gpio.mode(pin, gpio.OUTPUT)
        gpio.write(pin, val)
        o_log.print_log("event[" .. evId ..
                            "] writing on gpio pin: " ..
                            pin)
    --[[ end ]]
end