function events_new_start_gpr(evId, pin, val)

    gpio.mode(pin, gpio.INPUT)
    --[[ local r = gpio.read(pin)
    if r ~= value.param.state then
        value.param.state = r ]]
        o_log.print_log("event[" .. evId ..
                            "] check: reading on gpio pin: " ..
                            val)
        if gpio.read(pin) == val then
            return true
        else
            return false
        end
    --[[ else
        return false
    end ]]

end