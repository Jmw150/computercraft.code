local home = vector.new(146, 67, 261)
local collected = 0 -- To see how much stuff it ran into 
local orientation = 0 -- direction it faces
local steps = 0 -- steps left to get to base
local x = 0 --temporary storage spots
local y = 0
local z = 0
local closeness = 0 -- how close do you want to be to base


local function distanceFromHome()
	position = vector.new(gps.locate(5))
	displacement = position - home
end
local function collect()
	collected = collected + 1
	if math.fmod(collected, 25) == 0 then
		print( "Mined "..collected.." items." )
	end
end

--set of try commands
local function tryDig()
	while turtle.detect() do
		if turtle.dig() then
			collect()
			sleep(0.5)
		else
			return false
		end
	end
	return true
end

local function tryDigUp()
	while turtle.detectUp() do
		if turtle.digUp() then
			collect()
			sleep(0.5)
		else
			return false
		end
	end
	return true
end

local function tryDigDown()
	while turtle.detectDown() do
		if turtle.digDown() then
			collect()
			sleep(0.5)
		else
			return false
		end
	end
	return true
end

local function refuel()
	local fuelLevel = turtle.getFuelLevel()
	if fuelLevel == "unlimited" or fuelLevel > 0 then
		return
	end
	
	local function tryRefuel()
		for n=1,16 do
			if turtle.getItemCount(n) > 0 then
				turtle.select(n)
				if turtle.refuel(1) then
					turtle.select(1)
					return true
				end
			end
		end
		turtle.select(1)
		return false
	end
	
	if not tryRefuel() then
		print( "Add more fuel to continue." )
		while not tryRefuel() do
			os.pullEvent( "turtle_inventory" )
		end
		print( "Resuming" )
	end
end

local function tryUp()
	refuel()
	while not turtle.up() do
		if turtle.detectUp() then
			if not tryDigUp() then
				return false
			end
		elseif turtle.attackUp() then
			collect()
		else
			sleep( 0.5 )
		end
	end
	return true
end

local function tryDown()
	refuel()
	while not turtle.down() do
		if turtle.detectDown() then
			if not tryDigDown() then
				return false
			end
		elseif turtle.attackDown() then
			collect()
		else
			sleep( 0.5 )
		end
	end
	return true
end

local function tryForward()
	refuel()
	while not turtle.forward() do
		if turtle.detect() then
			if not tryDig() then
				return false
			end
		elseif turtle.attack() then
			collect()
		else
			sleep( 0.5 )
		end
	end
	return true
end --end of try commands
local function right()
	turtle.turnRight()
	orientation = orientation + 1
	orientation = math.fmod(orientation, 4)
end
local function left()
	turtle.turnLeft()
	orientation = orientation - 1
	orientation = math.fmod(orientation, 4)
end

-- getting bearings
distanceFromHome() 
steps = (position.x - home.x)+(position.y - home.y)+(position.z - home.z)
if steps < 1 and steps > 1 then
	print("Close enough") 
	exit() end
x = position.x
z = position.z
tryDig()
tryForward()
distanceFromHome()
x = position.x - x
z = position.z - z
if x > 0 then orientation = 0 end
if z > 0 then orientation = 1 end
if x < 0 then orientation = 2 end
if z < 0 then orientation = 3 end
steps = (position.x - home.x)+(position.y - home.y)+(position.z - home.z)
--actually getting home
while steps > closeness or steps < closeness do 
	--y	
	if position.y - home.y < 0 then 
		tryDigUp()
		tryUp()
	end
	if position.y - home.y > 0 then 
		tryDigDown()
		tryDown()
	end
	--x
	if position.x - home.x < 0 then 
		while orientation ~= 0 do right() end
		tryDig()
		tryForward()
	end
	if position.x - home.x > 0 then 
		while orientation ~= 2 do right() end
		tryDig()
		tryForward()
	end
	--z
	if position.z - home.z < 0 then 
		while orientation ~= 1 do right() end
		tryDig()
		tryForward()
	end
	if position.z - home.z > 0 then 
		while orientation ~= 3 do right() end
		tryDig()
		tryForward()
	end
	distanceFromHome()
	steps = (position.x - home.x)+(position.y - home.y)+(position.z - home.z)
end
