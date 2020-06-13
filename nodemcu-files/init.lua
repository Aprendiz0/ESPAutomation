require("vars")
require("o_wifi")

print(node.heap())

o_wifi.setmode(wifi.STATIONAP)
o_wifi.setap()
o_wifi.setsta()

require("http_server")
--require("http-example")
