function events_new_action_disp(evId, val)
    o_events.dispatch(val)
    o_log.print_log("event[" .. evId .. "] dispathing event with id: " .. val)
end
