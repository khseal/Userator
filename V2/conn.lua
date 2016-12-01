print('IP is ' .. wifi.sta.getip())
pcall(function() require("ESPSky").connect("46.4.26.233", 1883, "0ab3uisc1qom0vriivs01thuxr8fndiw") end)
dofile('httpapi.lua')
dofile('gpio.lua')
