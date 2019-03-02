-- rational agents


local function printUsage()
	print( "Usages:" )
	print( "agent [type] [steps]" )
	print( "type  = (reflex, model, goal, utility)" )
	print( "steps = number of actions" )
end

local tArgs = { ... }
if #tArgs < 1 then
	printUsage()
	return
end

local height = 0

local collected = 0

local function collect()
	collected = collected + 1
	if math.fmod(collected, 25) == 0 then
		print( "Mined "..collected.." items." )
	end
end

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
		print( "Resuming Tunnel." )
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
end

local right = false -- trutles are quite blind

local function rightorleft()
    if turtle.detect() then
      right = false
    else
      right = true
    end
end


local function ReflexDigAgent()
    if turtle.detectDown() then
        tryDigDown()
    elseif right == true then
        tryForward()
        right = false
    elseif right == false then
        turtle.turnRight()
        turtle.turnRight()
        tryForward()
        turtle.turnRight()
        turtle.turnRight()
        right = true
    end
end

--[[
modeldat = {
   state,
   model,
   rules,
   action
}
local function ModelBasedVacuumAgent()
   
   end
]]--

-- make this go off gps instead
rightorleft() -- are in the right cell or the left cell?


local agent = tArgs[1]
local steps = tArgs[2]
if agent == "reflex" then
   for i=1,tonumber(steps) do
      ReflexDigAgent()
   end
else
   print("not made yet")
end

