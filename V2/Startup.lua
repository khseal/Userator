print('Setting up WIFI...')
wifi.setmode(wifi.STATION)
wifi.sta.config('Boroda', 'abrakodabra')
wifi.sta.connect()