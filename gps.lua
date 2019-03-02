local function printUsage()
	print( "Usages:" )
	print( "gps host" )
	print( "gps host <x> <y> <z>" )
	print( "gps locate" )
end

local tArgs = { ... }
if #tArgs < 1 then
	printUsage()
	return
end

local function readNumber()
	local num = nil
	while num == nil do
		num = tonumber(read())
		if not num then
			write( "Not a number. Try again: " )
		end
	end
	return math.floor( num + 0.5 )
end

local function open()
	local bOpen, sFreeSide = false, nil
	for n,sSide in pairs(rs.getSides()) do	
		if peripheral.getType( sSide ) == "modem" then
			sFreeSide = sSide
			if rednet.isOpen( sSide ) then
				bOpen = true
				break
			end
		end
	end
	
	if not bOpen then
		if sFreeSide then
			print( "No modem active. Opening "..sFreeSide.." modem" )
			rednet.open( sFreeSide )
			return true
		else
			print( "No modem attached" )
			return false
		end
	end
	return true
end
	
local sCommand = tArgs[1]
if sCommand == "locate" then
	if open() then
		gps.locate( 2, true )
	end
	
elseif sCommand == "host" then
	if turtle then
		print( "Turtles cannot act as GPS hosts." )
		return
	end

	if open() then
		local x,y,z
		if #tArgs >= 4 then
			x = tonumber(tArgs[2])
			y = tonumber(tArgs[3])
			z = tonumber(tArgs[4])
			if x == nil or y == nil or z == nil then
				printUsage()
				return
			end
			print( "Position is "..x..","..y..","..z )
		else
			x,y,z = gps.locate( 2, true )
			if x == nil then
				print( "Run \"gps host <x> <y> <z>\" to set position manually" )
				return
			end
		end
	
		print( "Serving GPS requests" )
	
		local nServed = 0
		while true do
			sender,message,distance = rednet.receive()
			if message == "PING" then
				rednet.send(sender, textutils.serialize({x,y,z}))
				
				nServed = nServed + 1
				if nServed > 1 then
					local x,y = term.getCursorPos()
					term.setCursorPos(1,y-1)
				end
				print( nServed.." GPS Requests served" )
			end
		end
	end
	
else
	printUsage()
	return
end
