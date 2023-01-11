
--This class initializes a new turtle. If you want to resume the session of an existing turtle just make
--sure to call read_pos() before doing anythin else. Then it should work
generalState = {}

function testInit()
	init_turtle({0,0,0,0})
end

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

function copyProgramsToDisk()
	log("Copying Programs to Disk. Disk exists: ")
	log(disk.hasData("front"))
	log("Disk ID: ")
	log(disk.getID("front"))
	log("Deleting Files from Disk")
	if fs.exists("disk/startup") then fs.delete("disk/startup") end
	if fs.exists("disk/turtleStartup") then fs.delete("disk/turtleStartup") end
	if fs.exists("disk/recipesInitiation") then fs.delete("disk/recipesInitiation") end
	if fs.exists("disk/resourceCalculator") then fs.delete("disk/resourceCalculator") end
	if fs.exists("disk/communication") then fs.delete("disk/communication") end
	if fs.exists("disk/generalHelpingFunctions") then fs.delete("disk/generalHelpingFunctions") end
	if fs.exists("disk/itemstacksizesAndMaxCounts") then fs.delete("disk/itemstacksizesAndMaxCounts") end
	if fs.exists("disk/logger") then fs.delete("disk/logger") end
	if fs.exists("disk/standardValues") then fs.delete("disk/standardValues") end
	if fs.exists("disk/build") then fs.delete("disk/build") end
	if fs.exists("disk/crafting") then fs.delete("disk/crafting") end
	if fs.exists("disk/moveInBase") then fs.delete("disk/moveInBase") end
	if fs.exists("disk/mining") then fs.delete("disk/mining") end
	if fs.exists("disk/movement") then fs.delete("disk/movement") end
	if fs.exists("disk/recipes") then fs.delete("disk/recipes") end
	if fs.exists("disk/smelting") then fs.delete("disk/smelting") end
	if fs.exists("disk/init") then fs.delete("disk/init") end
	if fs.exists("disk/farming") then fs.delete("disk/farming") end
	if fs.exists("disk/processCommand") then fs.delete("disk/processCommand") end
	if fs.exists("disk/req") then fs.delete("disk/req") end
	if fs.exists("disk/inventory") then fs.delete("disk/inventory") end
	if fs.exists("disk/req") then fs.delete("disk/req") end

	log("Copying Programs")
	fs.copy("/multiTurtleStartup1.lua", "disk/startup")
	fs.copy("/multiTurtleStartup2.lua","disk/turtleStartup")
	fs.copy("/recipesInitiation.lua", "disk/recipesInitiation")
	fs.copy("/resourceCalculator.lua", "disk/resourceCalculator")
	fs.copy("/communication.lua", "disk/communication")
	fs.copy("/generalHelpingFunctions.lua", "disk/generalHelpingFunctions")
	fs.copy("/itemstacksizesAndMaxCounts.lua", "disk/itemstacksizesAndMaxCounts")
	fs.copy("/logger.lua", "disk/logger")
	fs.copy("/standardValues.lua", "disk/standardValues")
	fs.copy("/build.lua", "disk/build")
	fs.copy("/crafting.lua", "disk/crafting")
	fs.copy("/mining.lua", "disk/mining")
	fs.copy("/moveInBase.lua", "disk/moveInBase")
	fs.copy("/movement.lua", "disk/movement")
	fs.copy("/recipes.lua", "disk/recipes")
	fs.copy("/smelting.lua", "disk/smelting")
	fs.copy("/farming.lua", "disk/farming")
	fs.copy("/init.lua", "disk/init")
	fs.copy("/req2.lua", "disk/req")
	fs.copy("/processCommand.lua","disk/processCommand")
	fs.copy("/inventory.lua","disk/inventory")
	disk.setLabel("front","TurtleLauncher")
	local h = fs.open("disk/turtleNumber","w")
	h.write(textutils.serialize({ 1 }))
	h.close()
	h = fs.open("disk/height","w")
	h.write(textutils.serialize({ current_pos.y }))
	h.close()
end

function initMultiTurtle(num, height)
	current_pos = vector.new(basespots_spawn.x,height,basespots_spawn.z-1)
	current_dir = directions.NORTH
	local h = fs.open("houseGroundLevel","w")
	h.writeLine(textutils.serialize({height}))
	h.close()
	setHouseGroundLevel(height)
	os.setComputerLabel("Spartakus "..num)
end

function loadHouseGroundLevel()
	local h = fs.open("houseGroundLevel","r")
	setHouseGroundLevel(textutils.unserialize(h.readAll())[1])
	h.close()
end

function initProgressFiles()
	local h=fs.open("miningProgress.michi","w")
	h.write("{}")
	h.close()
end

function initComputerFile()
	--local state = textutils.unserialize(uncompress(comm_getMessage()))
	local state = {}
	state.turtleCount = 1
	state.resources = getTotalItemCounts()
	state.resources["computercraft:turtle_normal"] = state.resources["computercraft:turtle_normal"] - 1
	state.resources["minecraft:diamond_pickaxe"] = state.resources["minecraft:diamond_pickaxe"] - 1
	state.stage = 1
	local startPlan=getStep(1)
	addItemsToPlanAndCalculateAvailableSteps(startPlan,state.resources)
	state.currentPlan=startPlan
	state.activeSteps={}
	state.turtlesIdling=1
	state.turtlesMining=0
	state.turtlesGathering=0
	state.turtlesFarming={}
	state.turtlesFarming["minecraft:sugar_cane"]=0
	state.farmTimestampAvailableList={}
	state.farmTimestampAvailableList["minecraft:sugar_cane"]=-1
	state.farmCooldowns={}
	state.activeActions={}
	state.farmCooldowns["minecraft:sugar_cane"]=300
	-- state.machines[i][j] is the state of the j-th machine of type init_turtle
	-- the state is: -1 if the machine is ready, timestamp of when the machine will be ready if the machine is running
	state.machines={}
	state.machines[1]={}
	for i = 1,12 do
		state.machines[1][i]=-1
	end
	state.turtleStates={}
	local h=fs.open("bossState.michi","w")
	--log(state)
	h.write(textutils.serialize(state))
	h.close()
end

function initBossFromFile()
	local h=fs.open("bossState.michi","r")
	generalState = textutils.unserialize(h.readAll())
	h.close()
	read_pos()
	initiateRecipes()
	initGatherableAndMineableResources()
end


