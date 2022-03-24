-- Uses FTB Ultimate 1.3.0
require("req")

-- Initiation, clearing of the first two houseChunks of Trees, Flattening of the first two houseChunks
function initiateAndFlatten()
    init_turtle()
    --clear area for Chests
    flattenRectangle(10, 10, 12, 12,houseGroundLevel,10)
    initiateChests()

    --clean the two house chunks from trees
    lookInChunkForWood(1,nil,true)
    lookInChunkForWood(2,nil,true)
    lookInChunkForWood(3, nil,true)
    goFromOutsideToChestPoint()
    dropAbundantItems()
    dropInventory()


    --flatten them
    flattenRectangle(10, 13, 15, 15,nil,2)
    flattenRectangle(13, 10, 15, 12,nil,2)
    flattenRectangle(0,10,9,15,nil,2)
    flattenRectangle(0,0,15,9,nil,2)
    flattenRectangle(16,0,31,15,nil,2)
    goFromOutsideToChestPoint()
    dropAbundantItems()
    dropInventory()
end

function increaseChestCountTo(targetCount)
    local chestCosts = resourceCosts("minecraft:chest",targetCount-chests["count"], getTotalItemCounts())
    log("Farming Wood to get a total of 20 Chests!")
    log(chestCosts)
    singleTurtleFarmWood(chestCosts[woodsName])
    buildBaseChests(targetCount-chests["count"])
end

function makeSugarCaneFarm()
    --make Sugarcane Farm
    local sugarCaneFarmCosts = subtractValuesPositive(resourceCostsList(standardvalues_sugarCaneFarmAndFurnaces()), getTotalItemCounts())
    log("Collecting stuff for Sugarcane Farm and Furnaces. Going to Mine: ")
    log(mineableResources(sugarCaneFarmCosts))
    singleTurtleMineResources(mineableResources(sugarCaneFarmCosts))

    log("Gathering stuff for Sugarcane Farm and Furnaces. Going to Gather: ")
    log(gatherableResources(sugarCaneFarmCosts))
    local getAllSugarcane={}
    getAllSugarcane["minecraft:sugar_cane"]=true
    singleTurtleGatherResource(gatherableResources(sugarCaneFarmCosts), getAllSugarcane)

    log("Building Furnaces!")
    buildBaseFurnaces()
    buildSugarcaneFarm()
end

function collectResourcesForBase()
    local baseCosts = resourceCostsList(standardvalues_baseBuildingItems(), getTotalItemCounts())
    log("Needed items to build base:")
    log(baseCosts)
    local toMine = mineableResources(baseCosts)
    log("From these: the Following are mineable")
    log(toMine)
    local toGatherFromSurface = gatherableResources(baseCosts)
    log("From these: the Following are Gatherable from the Surface")
    log(toGatherFromSurface)
    log("From these wood: ")
    log(baseCosts[woodsName])
    log("Sugarcane : ")
    log(baseCosts["minecraft:sugar_cane"])

    log("Going to mine!")
    singleTurtleMineResources(toMine, 60)
    log("Everything mined! Chests: ")
    --log(chests)

    log("Going to gather!")
    singleTurtleGatherResource(toGatherFromSurface)
    log("Gathered all! Chests: ")
    --log(chests)

    log("Getting wood!")
    singleTurtleFarmWood(baseCosts[woodsName])
    log("Got all Resources for base building! Chests: ")

    log("Getting Sugarcane!")
    singleTurtleFarmSugarcane(baseCosts["minecraft:sugar_cane"], false)

    log("Placing remaining sugarcane in Farm")
    placeRemainingSugarcane(3)
end


function craftBaseStuff()
    local plan = generateCraftingPlanForItemList(standardvalues_baseBuildingItems(),getTotalItemCounts())[1]
    log("The Crafting Plan is: ")
    log(plan)
    log("Executing it! Plan has "..#plan.." steps.")
    for i=#plan, 1, -1 do
        executePlanStepSingleTurtle(plan[i])
    end
end



function buildCommSpots()
    local items = {}
    items["minecraft:stone_bricks"] = 28
    items["minecraft:redstone"] = 20

    log("Building Communication Spots")
    navigate(basespots_computerQueue)
    turn(directions.NORTH)
    move_forward()
    local commSpot1= vector.new(basespots_computerQueue.x-2,basespots_computerQueue.y,basespots_computerQueue.z+1)
    local commSpot2 = vector.new(basespots_chestQueue.x-2,basespots_chestQueue.y, basespots_chestQueue.z+1)
    log("Cleaning Area")
    cleanCommunicationSpot(commSpot1, directions.NORTH)
    cleanCommunicationSpot(commSpot2, directions.NORTH)
    navigate(basespots_chestBase)
    turn(directions.NORTH)
    getItems(items)
    log("Building Spots for Communication with BossPC and ChestTurtle")
    buildCommunicationSpot(commSpot1, directions.NORTH)
    buildCommunicationSpot(commSpot2, directions.NORTH)
    navigate(basespots_chestBase)
    turn(directions.NORTH)
end

function buildBase()
    --buildCommSpots()
    buildComputerAndTurtleSpawnSpot()
end

function buildComputerAndTurtleSpawnSpot()
    local items = {}
    items["computercraft:computer_normal"] = 1
    items["computercraft:disk"] = 1
    items["computercraft:disk_drive"] = 1
    items["minecraft:lever"]=1
    getItems(items)
    navigate(basespots_computerQueue)
    turn(directions.NORTH)

    move_forward()
    turn_left()
    move_forward()
    turn_right()
    selectItem("computercraft:disk_drive")
    turtle.place()
    selectItem("computercraft:disk")
    turtle.drop()

    if fs.exists("disk/startup") then fs.delete("disk/startup") end
    fs.copy("/computerStartup1.lua", "disk/startup")
    if fs.exists("disk/computerstartup") then fs.delete("disk/computerstartup") end
    fs.copy("/computerStartup2.lua","disk/computerstartup")
    if fs.exists("disk/recipesInitiation") then fs.delete("disk/recipesInitiation") end
    fs.copy("/recipesInitiation.lua", "disk/recipesInitiation")
    if fs.exists("disk/resourceCalculator") then fs.delete("disk/resourceCalculator") end
    fs.copy("/resourceCalculator.lua", "disk/resourceCalculator")
    if fs.exists("disk/communication") then fs.delete("disk/communication") end
    fs.copy("/communication.lua", "disk/communication")
    if fs.exists("disk/generalHelpingFunctions") then fs.delete("disk/generalHelpingFunctions") end
    fs.copy("/generalHelpingFunctions.lua", "disk/generalHelpingFunctions")
    if fs.exists("disk/itemstacksizesAndMaxCounts") then fs.delete("disk/itemstacksizesAndMaxCounts") end
    fs.copy("/itemstacksizesAndMaxCounts.lua", "disk/itemstacksizesAndMaxCounts")
    if fs.exists("disk/logger") then fs.delete("disk/logger") end
    fs.copy("/logger.lua", "disk/logger")
    if fs.exists("disk/standardValues") then fs.delete("disk/standardValues") end
    fs.copy("/standardValues.lua", "disk/standardValues")
    if fs.exists("disk/build") then fs.delete("disk/build") end
    fs.copy("/build.lua", "disk/build")
    if fs.exists("disk/crafting") then fs.delete("disk/crafting") end
    fs.copy("/crafting.lua", "disk/crafting")
    if fs.exists("disk/mining") then fs.delete("disk/mining") end
    fs.copy("/mining.lua", "disk/mining")
    if fs.exists("disk/moveInBase") then fs.delete("disk/moveInBase") end
    fs.copy("/moveInBase.lua", "disk/moveInBase")
    if fs.exists("disk/movement") then fs.delete("disk/movement") end
    fs.copy("/movement.lua", "disk/movement")
    if fs.exists("disk/recipes") then fs.delete("disk/recipes") end
    fs.copy("/recipes.lua", "disk/recipes")
    if fs.exists("disk/smelting") then fs.delete("disk/smelting") end
    fs.copy("/smelting.lua", "disk/smelting")
    if fs.exists("disk/farming") then fs.delete("disk/farming") end
    fs.copy("/farming.lua", "disk/farming")
    if fs.exists("disk/init") then fs.delete("disk/init") end
    fs.copy("/init.lua", "disk/init")
    if fs.exists("disk/computerPlanner") then fs.delete("disk/computerPlanner") end
    fs.copy("/mainPlanner.lua","disk/mainPlanner")




    local h=fs.open("disk/disk.michi","w")
    h.write("I AM A DISK")
    h.close()

    turn_right()
    move_forward()
    turn_left()
    selectItem("computercraft:computer_normal")
    turtle.place()
    os.sleep(0.1)
    local boss = peripheral.wrap("front")
    log("Could connect to boss:")
    log(boss ~= nil)
    boss.turnOn()
    local state = {}
    state.turtleCount = 1
    state.resources = getTotalItemCounts()
    state.resources["computercraft:turtle_normal"] = state.resources["computercraft:turtle_normal"] - 1
    state.resources["minecraft:diamond_pickaxe"] = state.resources["minecraft:diamond_pickaxe"] - 1
    state.stage = 1
    sleep(3)
    comm_sendMessage(compress(textutils.serialize(state)))


    --[[
    if fs.exists("disk/startup") then fs.delete("disk/startup") end
    fs.copy("/multiTurtleStartup1.lua", "disk/startup")
    if fs.exists("disk/turtleStartup") then fs.delete("disk/turtleStartup") end
    fs.cope("/multiTurtleStartup2.lua","disk/turtleStartup")
    if fs.exists("disk/processCommand") then fs.delete("disk/processCommand") end
    fs.copy("/processCommand.lua","disk/processCommand")
    ]]--
end


init_turtle({11,66,11,directions["NORTH"]})
--inventur()
inventur()
--initiateAndFlatten()


--increaseChestCountTo(20)


--makeSugarCaneFarm()
addFarm("minecraft:sugar_cane")


collectResourcesForBase()
craftBaseStuff()
buildBase()


