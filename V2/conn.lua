print('IP is ' .. wifi.sta.getip())
pcall(function() require("ESPSky").connect("46.4.26.233", 1883, "youid") end)
dofile('httpapi.lua')
dofile('gpio.lua')
