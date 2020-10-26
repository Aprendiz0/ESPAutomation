require("vars")
require("events")
require("routines")
require("o_wifi")
require("http_server")

print(node.heap())

o_wifi.setmode(wifi.STATIONAP)
o_wifi.setsta()