print('Setting up WIFI...')
wifi.setmode(wifi.STATION)
wifi.sta.config('AP', 'pass')
wifi.sta.connect()
