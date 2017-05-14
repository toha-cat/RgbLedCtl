dofile("config.lua")

redV = 0
blueV = 0
greenV = 0

server = 0

clientList = {}

-- normalize value from PWM
function normalize(v)
	return v*4
--	return v*(v/128)
end
-- PWM initialization for LED and setting of start values
function initLed()
	pwm.setup(5,200,256) 
	pwm.setup(6,200,256) 
	pwm.setup(7,200,256)

	pwm.setduty(5,0) 
	pwm.setduty(7,0) 
	pwm.setduty(6,0)

	pwm.start(5) 
	pwm.start(6) 
	pwm.start(7)
end
-- Set the color of LED
function setLedColor(r,g,b) 
	pwm.setduty(5,normalize(r)) 
	pwm.setduty(7,normalize(g)) 
	pwm.setduty(6,normalize(b))
end
-- Get the current LED color in RGB
function getColor()
	return string.format("#%02x/%02x/%02x", redV, blueV, greenV)
end
-- Get the value of each color from RGB
function parseColor(color)
	print(color)
	redV = tonumber(color:sub(2,3), 16)
	greenV = tonumber(color:sub(4,5), 16)
	blueV = tonumber(color:sub(6,7), 16)
	return redV, greenV, blueV
end
-- Set the color of the LED, input parameter RGB string
function setColor(color)
	parseColor(color)
	setLedColor(redV, greenV, blueV)
end
--  Initializing WiFi as a client and connecting to the network
function initNetwork()
	cfg = {}
	cfg.ip=c_ip
	cfg.netmask=c_netmask
	cfg.gateway=c_gateway
	wifi.sta.setip(cfg)
	wifi.setmode(wifi.STATION)
	wifi.sta.config(c_wifi_ssid,c_wifi_key,1)  -- enable auto connect and connect to access point
end
-- Parsing messages from clients
function readyMess(client, mess)
	-- TODO processing of commands, not only color can come, but also animation
	setColor(mess)
end
-- Sending messages to clients
function sendMess(mess)
	for i = 1, #clientList, 1 do
		local c = clientList[i]
		c:send(mess)
	end
end
-- Removing clients from the list
function removeClient(client)
	local cIp,cPort = client:getpeer()
	for i = 1, #clientList, 1 do
		local c = clientList[i]
		local ip,port = c:getpeer()
		if ip == cIp and cPort == port then
			table.remove(clientList, i)
			break
		end
	end
end
-- Create and start a TCP server
function initServer( ... )
	server = net.createServer(net.TCP, 3000)
	server:listen(5050,
		function(c)
			c:on("receive", readyMess)
			c:on("disconnection", removeClient)
			table.insert(clientList, c)
			-- c:send("hello world")
		end
	)
end

initLed()
initNetwork()
initServer()
