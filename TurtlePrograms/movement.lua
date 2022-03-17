-- This class implements every neccessary movement function and tracks the position of the turtle
-- Use the here defined methods instead of the turtle api to avoid weird side-effects

require("logger")


directions = {} --{"NORTH", "EAST", "SOUTH", "WEST"}

-- lua hat keine enums deshalb diese komische Lösung -- 
directions["NORTH"] = 0
directions["EAST"] = 1
directions["SOUTH"] = 2
directions["WEST"] = 3

home = vector.new(-460, 66,207)

basespots_chestBase = vector.new(11, houseGroundLevel, 11)
houseGroundLevel = 65

houseFrom=vector.new(0,60,0)
houseTo=vector.new(32,70,32)


current_dir ={}
current_pos ={}


function setHouseGroundLevel(level)
	houseGroundLevel = level
	basespots_chestBase.y=level
end

function write_pos()
	local pos = {}
	pos["position"] = current_pos
	pos["direction"] = current_dir
	local h = fs.open("pos.txt", "w")
	h.write(textutils.serialize(pos))
	h.close()
end

function read_pos()
	local h = fs.open("pos.txt", "r")
	local pos = textutils.unserialize(h.readAll())
	current_dir = pos["direction"]
	current_pos = pos["position"]
	h.close()
end




function move_forward(force)
	if force==nil then force=true end
	while not turtle.forward() do
		local inWay
		local block
		inWay, block = turtle.inspect()
		if inWay then
			if force==false then return false end
			if blockNameIsTurtle(block["name"]) then
				sleep(1)
			else
				turtle.dig()
			end
		end
	end

	if current_dir == directions["NORTH"] then
		current_pos.z = current_pos.z + 1
	elseif current_dir == directions["EAST"] then
		current_pos.x = current_pos.x + 1
	elseif current_dir == directions["SOUTH"] then
		current_pos.z = current_pos.z - 1
	elseif current_dir == directions["WEST"] then
		current_pos.x = current_pos.x -1
	end
	return true
end

function move_up(force)
	if force==nil then force=true end
	while not turtle.up() do
		local inWay
		local block
		inWay, block = turtle.inspectUp()
		if inWay then
			if force==false then return false end
			if blockNameIsTurtle(block["name"]) then
				sleep(1)
			else
				turtle.digUp()
			end
		end
	end
	current_pos.y = current_pos.y +1
	return true
end

function move_down(force)
	if force==nil then force=true end
	while not turtle.down() do
		local inWay
		local block
		inWay, block = turtle.inspectDown()
		if inWay then
			if force==false then return false end
			if blockNameIsTurtle(block["name"]) then
				move_forward()
				sleep(1)
				turn_left()
				turn_left()
				move_forward()
				turn_left()
				turn_left()
			else
				turtle.digDown()
			end
		end
	end
	current_pos.y = current_pos.y - 1
	return true
end

function blockNameIsTurtle(name)
	return name=="computercraft:turtle_normal"
end

function notTurtleName(name)
	return not blockNameIsTurtle(name)
end

function move_back(force)
	if force==nil then force=true end
	while not turtle.back() do
		if force==false then return false end
		local inWay
		local block
		turn_left()
		turn_left()
		inWay, block = turtle.inspect()
		if inWay then
			if blockNameIsTurtle(block["name"]) then
				sleep(1)
			else
				turtle.dig()
				turn_left()
				turn_left()
			end
		end
	end

	if current_dir == directions["NORTH"] then
		current_pos.z = current_pos.z - 1
	elseif current_dir == directions["EAST"] then
		current_pos.x = current_pos.x - 1
	elseif current_dir == directions["SOUTH"] then
		current_pos.z = current_pos.z + 1
	elseif current_dir == directions["WEST"] then
		current_pos.x = current_pos.x + 1
	end
	return true
end

function turn(dir)
	local turn_offset = math.fmod((dir - current_dir) + 4, 4)

	if turn_offset == 3 then
		turn_left()  --distance between directions
	elseif turn_offset == 1 then
		turn_right()
	elseif turn_offset == 2 then
		turn_left()
		turn_left()
	end
end

function turn_left()

	turtle.turnLeft()
	current_dir = math.fmod(current_dir -1 +4 , 4)
end
function turn_right()
	turtle.turnRight()
	current_dir = math.fmod(current_dir +1 , 4)
end

function goFromHouseLeavingPointToChunk(chunkNum)
	log("Moving to Chunk"..chunkNum)
	local coordinate= spiralNumberToCoordinate(chunkNum)*16
	goFromHouseLeavingPointToOutsidePointOverground(coordinate)
end

function goFromHouseLeavingPointToOutsidePointUnderground(pos)
	navigateCoordinates(17,houseGroundLevel,-2)
	navigateCoordinates(pos)
end

function goFromHouseLeavingPointToOutsidePointOverground(pos)
	if pos.x<houseTo.x and pos.x>houseFrom.x and pos.z > houseFrom.z then
		navigateCoordinates(current_pos.x, houseGroundLevel, -2)
		navigateCoordinates(houseTo.x+2, houseGroundLevel, -2)
		navigateOnGroundToCoordinates(pos.x, pos.z )
		return
	end
	if pos.x< current_pos.x then
		navigateCoordinates(pos.x,houseGroundLevel,-2)
		navigateOnGroundToCoordinates(pos.x,pos.z)
	else
		navigateCoordinates(pos.x,houseGroundLevel,-1)
		navigateOnGroundToCoordinates(pos.x,pos.z)
	end
end

function goFromOutsideToChestPoint()
	if current_pos.x<houseTo.x and current_pos.x>houseFrom.x and current_pos.z > houseFrom.z then
		navigateOnGroundToCoordinates(houseTo.x+1, current_pos.z )
	end
	if current_pos.x>basespots_chestBase.x then
		navigateOnGroundToCoordinates(current_pos.x, -1)
		navigateCoordinates(basespots_chestBase.x, houseGroundLevel, -1)
		turn(directions["NORTH"])
		for i=1, 12 do move_forward() end
	else
		navigateOnGroundToCoordinates(current_pos.x, -2)
		navigateCoordinates(basespots_chestBase.x, houseGroundLevel, -2)
		turn(directions["NORTH"])
		for i=1, 13 do move_forward() end
	end
	turn(directions["NORTH"])
end



function navigateOnGroundToCoordinates(x, z)
	return navigateOnGround(vector.new(x,0,z))
end
-- similar to go_towards, but:
-- 1) Goes up instead of digging
-- 2) At the target x,z, goes to the ground y level
function navigateOnGround(position)
	log("Moving on ground towards x: "..position.x.." z: "..position.z)
	local offset = position - current_pos  --calculates the offset value


	if (position.x-current_pos.x > 0 and position.z%2==1) or (position.x-current_pos.x < 0 and position.z%2==0) then
		if position.x%2==0 then
			navigateOnGround(position + vector.new(0,0,-1))
			navigateOnGround(position)
		else
			navigateOnGround(position + vector.new(0,0,1))
			navigateOnGround(position)
		end
		return
	end


	-- move in z --
	-- only increase z in even x pos, only decrease z in odd x pos --
	-- thus turtles wont hit each other in the face and get stuck --
	if (offset.z > 0 and current_pos.x % 2 == 1) or ((offset.z < 0 and current_pos.x % 2 == 0)) then
		if current_pos.z % 2 == 0 then
			turn(directions["EAST"])
			moveOverGround(0,false)
			offset.x = offset.x - 1
		else
			turn(directions["WEST"])
			moveOverGround(0,false)
			offset.x = offset.x + 1
		end
	end




	if offset.z < 0 then
		turn(directions["SOUTH"])
	elseif offset.z > 0 then
		turn(directions["NORTH"])
	end
	-- move --
	while offset.z ~= 0 do
		moveOverGround(0, false)

		if current_dir == directions["SOUTH"] then
			offset.z = offset.z + 1
		else
			offset.z = offset.z - 1
		end

	end



	-- move in x --
	-- only increase x in even z pos, only decrease x in odd z pos --
	-- thus turtles wont hit each other in the face and get stuck --
	if (offset.x > 0 and current_pos.z % 2 == 1) or ((offset.x < 0 and current_pos.z % 2 == 0)) then
		turn(directions["NORTH"])
		moveOverGround(0, false)
		offset.z = offset.z + 1
	end

	if offset.x > 0 then
		turn(directions["EAST"])
	elseif offset.x < 0 then
		turn(directions["WEST"])
	end


	-- move in x --
	while offset.x ~= 0 do
		moveOverGround(0, false)
		if current_dir == directions["EAST"] then
			offset.x= offset.x -1
		else
			offset.x = offset.x+1
		end

	end
	while move_down(false) do end
	log("going finished")
end


function navigateCoordinates(x, y, z)
	return navigate(vector.new(x,y,z))
end


--naively implements navigation going towards a position.
-- please use navigate instead unless you know what you are doing
-- first moves in y, then z, then x
-- if something is in the way, it digs through!
function navigate(position)
	log("going towards x: "..position.x.." y: "..position.y.." z: "..position.z)
	--if the target is on the east, but on odd z coordinate, go to a point one block northern or southern and then to the target
	if (position.x-current_pos.x > 0 and position.z%2==1) or (position.x-current_pos.x < 0 and position.z%2==0) then
		if position.x%2==0 then
			navigate(position + vector.new(0,0,-1))
			navigate(position)
		else
			navigate(position + vector.new(0,0,1))
			navigate(position)
		end
		return
	end




	local offset = position - current_pos  --calculates the offset value

	-- move in y --
	if offset.y < 0 then
		while offset.y ~= 0 do
			move_down()
			offset.y = offset.y+1
		end
	else
		while offset.y ~= 0 do
			move_up()
			offset.y = offset.y-1

		end
	end

	-- move in z --
	-- only increase z in even x pos, only decrease z in odd x pos --
	-- thus turtles wont hit each other in the face and get stuck --
	if (offset.z > 0 and current_pos.x % 2 == 1) or ((offset.z < 0 and current_pos.x % 2 == 0)) then
		if current_pos.z % 2 == 0 then
			turn(directions["EAST"])
			move_forward()
			offset.x = offset.x - 1
		else
			turn(directions["WEST"])
			move_forward()
			offset.x = offset.x + 1
		end
	end

	if offset.z < 0 then
		turn(directions["SOUTH"])
	elseif offset.z > 0 then
		turn(directions["NORTH"])
	end
	-- move --
	while offset.z ~= 0 do
		move_forward()

		if current_dir == directions["SOUTH"] then
			offset.z = offset.z + 1
		else
			offset.z = offset.z - 1
		end

	end



	-- move in x --
	-- only increase x in even z pos, only decrease x in odd z pos --
	-- thus turtles wont hit each other in the face and get stuck --
	if offset.x > 0 then
		turn(directions["EAST"])
	elseif offset.x < 0 then
		turn(directions["WEST"])
	end


	-- move in x --
	while offset.x ~= 0 do
		move_forward()
		if current_dir == directions["EAST"] then
			offset.x= offset.x -1
		else
			offset.x = offset.x+1
		end

	end

	log("going finished")
end


--returns true if the turtle is in the starting areal boundary box
function in_house(pos)
	return pos.x < home.x + 5  and pos.x > home.x - 5 and
			pos.z < home.z + 5  and pos.z > home.z - 5 and
			pos.y < home.y + 10 and pos.y > home.y - 2
end

--determines if for a given goal the house is in the way. 
-- hopefully finds all cases
function house_in_the_way(pos)
	-- three cases if house is straight in the way
	if in_house(vector.new(home.x,pos.y, pos.z)) and in_house(vector.new(home.x,current_pos.y, current_pos.z))
			and ((pos.x >= home.x +5 and current_pos.x <= home.x -5) or (current_pos.x >= home.x +5 and pos.x <= home.x -5)) then
		return true
	elseif in_house(vector.new(pos.x,home.y, pos.z)) and in_house(vector.new(current_pos.x,home.y, current_pos.z))
			and ((pos.y >= home.y + 10 and current_pos.y <= home.y -2) or (current_pos.y >= home.y +10 and pos.y <= home.y -2)) then
		return true
	elseif in_house(vector.new(pos.x, pos.y, home.z)) and in_house(vector.new(current_pos.x,current_pos.y, home.z))
			and ((pos.z >= home.z +5 and current_pos.z <= home.z -5) or (current_pos.z >= home.z +5 and pos.z <= home.z -5)) then
		return true
	end

	-- case if turtle would walk x first and then walk in to the house while traversing the z - axis


	if  in_house(vector.new(home.x, pos.y, pos.z)) and
			in_house(vector.new(home.x, current_pos.y, home.z)) and
			((current_pos.x < home.x+5 and pos.x >= home.x +5) or (pos.x <= home.x -5 and current_pos.x > home.x -5)) then
		return true
	elseif  in_house(vector.new(pos.x, home.y, pos.z)) and
			in_house(vector.new(home.x, home.y, current_pos.z)) and
			((current_pos.y < home.y +10 and pos.y >= home.y +10) or (pos.y <= home.y -2 and current_pos.y > home.y -2)) then
		return true
	end
	return false




end

function moveOverGround(direction, goToGround)
	-- 0: Forward
	-- 1: Up
	-- 2: Back
	-- 3: Down
	-- If you can not move forward, try moving up and then forward
	-- if moving up is also not possible, try moving backwards first
	-- if that is also not possible go down
	-- if that is also not possible just dig downwards
	if direction ==nil then	direction=0	end
	if goToGround == nil then goToGround = true end

	local counter = 0
	if direction==0 then
		if not move_forward(false) then
			while not move_forward(false) do moveOverGround(1) end
		end
		if goToGround then while move_down(false) do end end
	end

	if direction==1 then
		if not move_up(false) then
			while not move_up(false) do
				if moveOverGround(2) then
					counter=counter + 1
				else
					break
				end
			end
			for i=1,counter do
				moveOverGround(0)
			end
		end
	end

	if direction==2 then
		local reachedGround = false
		if not move_back(false) then
			while not move_back(false) do
				if not reachedGround then
					reachedGround = not move_down(false)
				else
					move_up(true)
				end
			end
			if reachedGround then move_forward() end
		end
		return not reachedGround
	end
end