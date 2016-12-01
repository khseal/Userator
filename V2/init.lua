pcall(function() dofile("Startup.lua") end)
 
local autorunTimer = tmr.create()
 
autorunTimer:register(
    1000,
    tmr.ALARM_AUTO,
    function (t)
        if not (wifi.sta.getip()) then
            return;
        end
        autorunTimer:unregister()
        pcall(function() dofile("conn.lua") end)
    end)
 
autorunTimer:start()
 
