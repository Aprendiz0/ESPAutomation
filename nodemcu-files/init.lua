--[[
require("vars")

print(node.heap())

o_wifi.setmode(wifi.STATIONAP)
--o_wifi.setap()
o_wifi.setsta()

require("http_server")
require("http-example")

ok, json = pcall(sjson.encode, {key="value"})
if ok then
  print(json)
  print(sjson.decode('{"key":"value"}').key)
else
  print("failed to encode!")
end
]]

require("vars")
require("events")
require("routines")
require("o_wifi")
require("http_server")

print(node.heap())

o_wifi.setmode(wifi.STATIONAP)
o_wifi.setsta()