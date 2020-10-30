function source_wifi_set(sck, body)
    local cred = sjson.decode(body)

    sendHeader(sck, "application/json")

    if not cred.ssid and not cred.pass then
        sck:send('{ "ok": "false" }')
    else
        local wifi_conf = o_vars.get("wifi_conf")
        wifi_conf.sta_ssid = cred.ssid
        wifi_conf.sta_pass = cred.pass
        o_vars.save("wifi_conf", wifi_conf)
        sck:send('{ "ok": "true" }')
    end
    finish(sck)
end