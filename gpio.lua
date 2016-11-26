LightPin=0
VentingPin=1
ToiletPin=2
PIRPin=4


gpio.mode(LightPin, gpio.OUTPUT)
gpio.mode(VentingPin, gpio.OUTPUT)
gpio.mode(ToiletPin, gpio.OUTPUT)
gpio.mode(PIRPin, gpio.INPUT)


last_state = 1
tmr.alarm(0,300, 1, function()
    if gpio.read(PIRPin) ~= last_state then
        last_state = gpio.read(PIRPin)
            if last_state == 1 
            then  
            print("ON")
            gpio.write(LightPin,gpio.LOW)
            gpio.write(VentingPin,gpio.HIGH) 
            http.get("http://192.168.5.3/cgi-bin/stuff?command=light_on")
            http.get("http://192.168.5.3/cgi-bin/stuff?command=venting_off")
            else 
            print("OFF")
            gpio.write(LightPin,gpio.HIGH)
            http.get("http://192.168.5.3/cgi-bin/stuff?command=light_off")
            gpio.write(VentingPin,gpio.LOW)
            http.get("http://192.168.5.3/cgi-bin/stuff?command=venting_on")
            tmr.alarm(1, 20000, tmr.ALARM_SINGLE, function() 
            gpio.write(VentingPin,gpio.HIGH) 
            http.get("http://192.168.5.3/cgi-bin/stuff?command=venting_off")
            end)
            end
        end
    end)

