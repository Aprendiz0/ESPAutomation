function o_wifi_unregister_events()
    wifi.eventmon.unregister(wifi.eventmon.STA_CONNECTED)
    wifi.eventmon.unregister(wifi.eventmon.STA_DISCONNECTED)
    wifi.eventmon.unregister(wifi.eventmon.STA_AUTHMODE_CHANGE)
    wifi.eventmon.unregister(wifi.eventmon.STA_GOT_IP)
    wifi.eventmon.unregister(wifi.eventmon.STA_DHCP_TIMEOUT)
    wifi.eventmon.unregister(wifi.eventmon.AP_STACONNECTED)
    wifi.eventmon.unregister(wifi.eventmon.AP_STADISCONNECTED)
    wifi.eventmon.unregister(wifi.eventmon.AP_PROBEREQRECVED)
    wifi.eventmon.unregister(wifi.eventmon.WIFI_MODE_CHANGED)

    o_log.print_log("Wifi events unregistred..")
end
