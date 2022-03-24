
--This class initializes a new turtle. If you want to resume the session of an existing turtle just make
--sure to call read_pos() before doing anythin else. Then it should work
generalState = {}

function init_turtle(arg)
	initiateRecipes()
	initGatherableAndMineableResources()
	if arg ~= nil and #arg == 4 then
		current_pos = vector.new(arg[1], arg[2], arg[3])
		current_dir = arg[4]
	else
		current_pos = vector.new(11, getYPos(),11)
		current_dir = directions["NORTH"]
	end
	setHouseGroundLevel(current_pos.y)
	write_pos()
	setupChests()
	writeChestFile()
end


function initProgressFiles()
	local h=fs.open("miningProgress.michi","w")
	h.write("{}")
	h.close()
end

function initComputerFile()
	log("Getting message!")
	local state = textutils.unserialize(uncompress(comm_getMessage()))
	local startPlan=getStep(1)
	addItemsToPlanAndCalculateAvailableSteps(startPlan,state.resources)
	state["currentPlan"]=startPlan
	state["activeSteps"]={}
	state["turtlesIdling"]=1
	state["turtlesMining"]=0
	state["turtlesGathering"]=0
	state["turtlesFarming"]={}
	state["turtlesFarming"]["minecraft:sugar_cane"]=0
	state["farmTimestampAvailableList"]={}
	state.farmTimestampAvailableList["minecraft:sugar_cane"]=0
	state["farmCooldowns"]={}
	state.farmCooldowns["minecraft:sugar_cane"]=300
	local h=fs.open("bossState.michi","w")
	log(textutils.serialize(state))
	h.write(textutils.serialize(state))
	h.close()
end

function initBossFromFile()
	local h=fs.open("bossState.michi","r")
	generalState = textutils.unserialize(h.readAll())
	h.close()
end


