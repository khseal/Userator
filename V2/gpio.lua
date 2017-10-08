require('time')
getTime()
if h1 == nil then h1 = 12 end
LightPin=0
VentingPin=1
BathroomPin=2
ToiletPin=3
PIRPin=4
PIR2Pin=5


gpio.mode(LightPin, gpio.OUTPUT)
gpio.mode(VentingPin, gpio.OUTPUT)
gpio.mode(BathroomPin, gpio.OUTPUT)
gpio.mode(ToiletPin, gpio.OUTPUT)
gpio.mode(PIRPin, gpio.INPUT)
gpio.mode(PIR2Pin, gpio.INPUT)


tmr.alarm(0,300000, 1, function()
getTime()
if h1 == nil then h1 = 12 end
end)



last_state = 1
last_state2 = 1
AssDist = 400
AssDetect = 0
how_long_ass = 0
ass_not_here = 0
ass_cooler = 0

local function PWMON(connection, pin)
    pwm.setup(pin, 50, 71)
    pwm.setduty(pin, 27); pwm.start(pin); tmr.delay(500000); pwm.stop(pin) --turn to position 0 again
    pwm.setduty(pin, 95); pwm.start(pin); tmr.delay(500000); pwm.stop(pin)
    pwm.setduty(pin, 27); pwm.start(pin); tmr.delay(500000); pwm.stop(pin)
end

tmr.alarm(1,500, 1, function() ToiletSensor = adc.read(0) 
    
    if (ToiletSensor > AssDist) then 
        AssDetect = 1
        AssTime = tmr.time()
        tmr.start(2)
--        print("Gopa Detect")
    end
    if(how_long_ass > 10) then
    tmr.start(3) 
    end
 end)
 


tmr.alarm(2,2000, 1, function() 
        tmr.stop(1) 
        ToiletSensor = adc.read(0) 
        if (ToiletSensor > AssDist) then
            print("Gopa Used")
            how_long_ass = tmr.time() - AssTime
            ass_not_here = 0 
            else
            ass_not_here = ass_not_here + 1              
        end 
        
        if(ass_not_here > 5) then
        AssDetect = 0
        ass_not_here = 0
        print("Gopa Free")
        tmr.stop(2)
        tmr.start(1)
        end
 end)     

tmr.alarm(3,2000, tmr.ALARM_SEMI, function()
        if ( AssDetect == 0) then 
        how_long_ass = 0
		ass_cooler = 1
        print("Smuvaju Govno")
		PWMON(connection, 6)
        end
 --        print("Govno ne Smuto")
 end) 
 
 
tmr.alarm(4,300, 1, function()
    if gpio.read(PIRPin) ~= last_state then
        last_state = gpio.read(PIRPin)
            if last_state == 1 
            then  
--            print("ON")
            if h1 > 20 or h1 < 4 then 
            gpio.write(BathroomPin,gpio.LOW)
            http.get("http://192.168.5.3/cgi-bin/stuff?command=bathroom_on")
            else
            gpio.write(LightPin,gpio.LOW)
            http.get("http://192.168.5.3/cgi-bin/stuff?command=light_on")
            end
            gpio.write(VentingPin,gpio.HIGH) 
            http.get("http://192.168.5.3/cgi-bin/stuff?command=venting_off")
            elseif   AssDetect == 0 then
--           print("OFF")
            gpio.write(LightPin,gpio.HIGH)
            http.get("http://192.168.5.3/cgi-bin/stuff?command=light_off")
			ass_not_here = 0
            if last_state2 == 0  then  
            gpio.write(BathroomPin,gpio.HIGH)
            http.get("http://192.168.5.3/cgi-bin/stuff?command=bathroom_off")
            end
			if ass_cooler == 1  then 
			ass_cooler = 0
            gpio.write(VentingPin,gpio.LOW)
            http.get("http://192.168.5.3/cgi-bin/stuff?command=venting_on")
            tmr.alarm(5,40000, tmr.ALARM_SINGLE, function() 
            gpio.write(VentingPin,gpio.HIGH) 
            http.get("http://192.168.5.3/cgi-bin/stuff?command=venting_off")
            end)
			end
            end
        end
	    if gpio.read(PIR2Pin) ~= last_state2 then
        last_state2 = gpio.read(PIR2Pin)
            if last_state2 == 1 
            then  
--            print("ON")
            gpio.write(BathroomPin,gpio.LOW)
            http.get("http://192.168.5.3/cgi-bin/stuff?command=bathroom_on")
            else 
--           print("OFF")
            gpio.write(BathroomPin,gpio.HIGH)
            http.get("http://192.168.5.3/cgi-bin/stuff?command=bathroom_off")
            end
        end
    end)
	
