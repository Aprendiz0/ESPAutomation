print("o_general: " .. node.heap())
require("o_general")

print("o_log: " .. node.heap())
require("o_log")

print("o_vars: " .. node.heap())
require("o_vars")

print("o_events: " .. node.heap())
require("o_events")

print("o_routines: " .. node.heap())
require("o_routines")

print("o_wifi: " .. node.heap())
require("o_wifi")

print("w_http_server: " .. node.heap())
require("w_http_server")

print("all: " .. node.heap())

-- o_wifi.register_events()
wifi.setmode(wifi.STATIONAP)
o_wifi.setsta()

o_routines.events.start()