
local function GPIODOWN(connection, pin)
       gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, gpio.HIGH)
    
       -- Send back JSON response.
   connection:send("HTTP/1.0 200 OK\r\nAccess-Control-Allow-Origin: *\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
   connection:send('{"error":0, "message":"OK"}')

end

   
      local function GPIOUP(connection, pin)
    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, gpio.LOW)

   -- Send back JSON response.
   connection:send("HTTP/1.0 200 OK\r\nAccess-Control-Allow-Origin: *\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
   connection:send('{"error":0, "message":"OK"}')

end


return function (connection, req, args)
   print('Button pressed!', args.data)
   if     args.data == 'light_on' 
   then GPIOUP(connection, 0)  
   http.get("http://192.168.5.3/cgi-bin/stuff?command=light_on")
   elseif args.data == 'light_off' 
   then GPIODOWN(connection, 0)  
   http.get("http://192.168.5.3/cgi-bin/stuff?command=light_off")
     elseif args.data == 'venting_on' 
     then GPIOUP(connection, 1)
     http.get("http://192.168.5.3/cgi-bin/stuff?command=venting_on")	 
         elseif args.data == 'venting_off' 
		 then GPIODOWN(connection, 1) 
		    http.get("http://192.168.5.3/cgi-bin/stuff?command=venting_off")
            elseif args.data == 'toilet_on' 
			then GPIOUP(connection, 2) 
			   http.get("http://192.168.5.3/cgi-bin/stuff?command=toilet_on")
                elseif args.data == 'toilet_off' 
				then GPIODOWN(connection, 2)
				   http.get("http://192.168.5.3/cgi-bin/stuff?command=toilet_off")
   else
      connection:send("HTTP/1.0 400 OK\r\nAccess-Control-Allow-Origin: *\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
      connection:send('{"error":-1, "message":"Bad button"}')
   end
end
