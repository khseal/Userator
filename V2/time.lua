getTime = function()
     conn=net.createConnection(net.TCP, 0)
     conn:on("connection",function(conn, payload)
            conn:send("HEAD / HTTP/1.1\r\n"..
                      "Host: google.com\r\n"..
                      "Accept: */*\r\n"..
                      "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                      "\r\n\r\n")
            end)           
     conn:on("receive", function(conn, payload)
          tstamp = string.sub(payload,string.find(payload,"Date: ")+6,string.find(payload,"Date: ")+35)
--          print('Timestamp : '..tstamp)
    t = {}
    i=0
    for token in string.gmatch(tstamp, "[^%s]+") do
       t[i] = token
--       print(t[i])
       i=i+1
    end

    h1=0+string.sub(t[4],0,2)
    print(h1)

          conn:close()
     end)
    conn:connect(80,'google.com')
    conn = nil

return h1
end
