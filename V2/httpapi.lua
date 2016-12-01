-- Serving static files
dofile('http.lc')
httpServer:listen(80)

-- Custom API
-- Get text/html
httpServer:use('/button', function(req, res)
    
--local function PWMON(connection, pin)
--    pwm.setup(pin, 50, 71)
--    http.get("http://192.168.5.3/cgi-bin/stuff?command=toilet_on")
--    pwm.setduty(pin, 71); pwm.start(pin); tmr.delay(500000); pwm.stop(pin) --turn to position 0 again
--    pwm.setduty(pin, 127); pwm.start(pin); tmr.delay(500000); pwm.stop(pin)
--    pwm.setduty(pin, 71); pwm.start(pin); tmr.delay(500000); pwm.stop(pin)
--    http.get("http://192.168.5.3/cgi-bin/stuff?command=toilet_off")
--   res:send("HTTP/1.0 200 OK\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
--    res:send('{"error":0, "message":"OK"}')
--end


local function GPIODOWN(connection, pin)
    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, gpio.HIGH)
    
       -- Send back JSON response.
--   res:send("HTTP/1.0 200 OK\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
   res:send('{"error":0, "message":"OK"}')

end

   
      local function GPIOUP(connection, pin)
    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, gpio.LOW)

   -- Send back JSON response.
--   res:send("HTTP/1.0 200 OK\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
   res:send('{"error":0, "message":"OK"}')

end
   
   print('Button pressed!',  req.query.data)
   if      req.query.data== 'light_on' 
   then GPIOUP(connection, 6)  
   http.get("http://192.168.5.3/cgi-bin/stuff?command=light_on")
   elseif  req.query.data == 'light_off' 
   then GPIODOWN(connection, 6)  
   http.get("http://192.168.5.3/cgi-bin/stuff?command=light_off")
     elseif  req.query.data == 'venting_on' 
     then GPIOUP(connection, 1)
     http.get("http://192.168.5.3/cgi-bin/stuff?command=venting_on")     
         elseif  req.query.data == 'venting_off' 
         then GPIODOWN(connection, 1) 
            http.get("http://192.168.5.3/cgi-bin/stuff?command=venting_off")
            elseif  req.query.data == 'toilet_on' 
            then 
            PWMON(connection, 5)
--                GPIOUP(connection, 2) 
--               http.get("http://192.168.5.3/cgi-bin/stuff?command=toilet_on")
--               elseif  req.query.data == 'toilet_off' 
--                then 
--                   GPIODOWN(connection, 2)
--                  http.get("http://192.168.5.3/cgi-bin/stuff?command=toilet_off")
   else
--     res:send("HTTP/1.0 400 OK\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
     res:send('{"error":-1, "message":"Bad button"}')
   end
end)
