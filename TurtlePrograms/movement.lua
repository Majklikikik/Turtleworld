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

current_dir ={}
current_pos ={}

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
			if block["name"]=="computercraft:turtle_normal" then
				sleep(1)
			else
				turtle.dig()
			end
		end
	end

	if current_dir == directions["NORTH"] then
		current_pos.z = current_pos.z -1
	elseif current_dir == directions["EAST"] then
		current_pos.x = current_pos.x +1
	elseif current_dir == directions["SOUTH"] then
		current_pos.z = current_pos.z+1
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
			if block["name"]=="computercraft:turtle_normal" then
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
			if block["name"]=="computercraft:turtle_normal" then
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
			if block["name"]=="computercraft:turtle_normal" then
				sleep(1)
			else
				turtle.dig()
				turn_left()
				turn_left()
			end
		end
	end

	if current_dir == directions["NORTH"] then
		current_pos.z = current_pos.z + 1
	elseif current_dir == directions["EAST"] then
		current_pos.x = current_pos.x - 1
	elseif current_dir == directions["SOUTH"] then
		current_pos.z = current_pos.z - 1
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






--naively implements navigation going towards a position with priority x y z ...
-- please use navigate instead unless you know what you are doing
-- first moves in y, then z, then x
function go_towards(position)
	log("going towards x: "..position.x.." y: "..position.y.." z: "..position.z)
	log("from"..current_pos.x)
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
		turn(directions["EAST"])
		move_forward()
		offset.x = offset.x + 1
	end

	if offset.z > 0 then
		turn(directionsdirections["SOUTH"])
	elseif offset.z < 0 then
		turn(directions["NORTH"])
	end
	-- move --
	while offset.z ~= 0 do
		move_forward()

		if current_dir == directions["SOUTH"] then
			offset.z = offset.z -1
		else
			offset.z = offset.z +1
		end

	end



	-- move in x --
	-- only increase x in even z pos, only decrease x in odd z pos --
	-- thus turtles wont hit each other in the face and get stuck --
	if (offset.x > 0 and current_pos.z % 2 == 1) or ((offset.x < 0 and current_pos.z % 2 == 0)) then
		turn(directions["NORTH"])
		move_forward()
		offset.x = offset.x + 1
	end

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

function moveOverGround(arg)
	-- 0: Forward
	-- 1: Up
	-- 2: Back
	-- 3: Down
	-- If you can not move forward, try moving up and then forward
	-- if moving up is also not possible, try moving backwards first
	-- if that is also not possible go down
	-- if that is also not possible just dig downwards
	if arg ==nil then
		arg=0
	end

	local counter = 0
	if arg==0 then
		if not move_forward(false) then
			while not move_forward(false) do moveOverGround(1) end
		end
		while move_down(false) do end
	end

	if arg==1 then
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

	if arg==2 then
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