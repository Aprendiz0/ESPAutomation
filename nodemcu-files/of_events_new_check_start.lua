function events_new_check_start(lf_eventStart, eventStartCondition)

    for k, value in pairs(lf_eventStart) do
        local v = value()
        if v and eventStartCondition ==
            o_events.constants.eventStartCondition.if_or then
            v = nil
            return true
        elseif not v and eventStartCondition ==
            o_events.constants.eventStartCondition.if_and then
            v = nil
            return false
        end
    end

    if eventStartCondition == o_events.constants.eventStartCondition.if_or then
        return false;
    else
        return true;
    end

end
