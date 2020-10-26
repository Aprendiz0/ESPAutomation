require("o_vars")
require("o_events")
require("o_routines")
require("o_wifi")
require("w_http_server")

print(node.heap())

o_wifi.setmode(wifi.STATIONAP)
o_wifi.setsta()