-- Uses FTB Ultimate 1.3.0
require("req")

-- Initiation, clearing of the first two houseChunks of Trees, Flattening of the first two houseChunks
function initiateAndFlatten()
    init_turtle()
    --clear area for Chests
    flattenRectangle(10, 10, 12, 12, houseGroundLevel, 10)
    initiateChests()

    --clean the two house chunks from trees
    lookInChunkForWood(1, nil, true)
    lookInChunkForWood(2, nil, true)
    lookInChunkForWood(3, nil, true)
    goFromOutsideToChestPoint()
    dropAbundantItems()
    dropInventory()


    --flatten them
    flattenRectangle(10, 13, 15, 15, nil, 2)
    flattenRectangle(13, 10, 15, 12, nil, 2)
    flattenRectangle(0, 10, 9, 15, nil, 2)
    flattenRectangle(0, 0, 15, 9, nil, 2)
    flattenRectangle(16, 0, 31, 15, nil, 2)
    goFromOutsideToChestPoint()
    dropAbundantItems()
    dropInventory()
end

function increaseChestCountTo(targetCount)
    local chestCosts = resourceCosts("minecraft:chest", targetCount - chests["count"], getTotalItemCounts())
    log("Farming Wood to get a total of 20 Chests!")
    log(chestCosts)
    singleTurtleFarmWood(chestCosts[woodsName])
    buildBaseChests(targetCount - chests["count"])
end

function makeSugarCaneFarm()
    --make Sugarcane Farm
    local sugarCaneFarmCosts = subtractValuesPositive(resourceCostsList(standardvalues_sugarCaneFarmAndFurnaces()),
        getTotalItemCounts())
    log("Collecting stuff for Sugarcane Farm and Furnaces. Going to Mine: ")
    log(mineableResources(sugarCaneFarmCosts))
    singleTurtleMineResources(mineableResources(sugarCaneFarmCosts), 60)

    log("Gathering stuff for Sugarcane Farm and Furnaces. Going to Gather: ")
    log(gatherableResources(sugarCaneFarmCosts))
    local getAllSugarcane = {}
    getAllSugarcane["minecraft:sugar_cane"] = true
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

    --log("Placing remaining sugarcane in Farm")
    --placeRemainingSugarcane(3)
end

function craftBaseStuff()
    local plan = generateCraftingPlanForItemList(standardvalues_baseBuildingItems(), getTotalItemCounts())[1]
    log("The Crafting Plan is: ")
    log(plan)
    log("Executing it! Plan has " .. #plan .. " steps.")
    for i = #plan, 1, -1 do
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
    local commSpot1 = vector.new(basespots_computerQueue.x - 2, basespots_computerQueue.y, basespots_computerQueue.z + 1)
    local commSpot2 = vector.new(basespots_chestQueue.x - 2, basespots_chestQueue.y, basespots_chestQueue.z + 1)
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
    local items = {}
    items["computercraft:turtle_normal"] = 1
    items["minecraft:diamond_pickaxe"] = 1
    items["computercraft:disk"] = 1
    items["computercraft:disk_drive"] = 1
    items["minecraft:lever"] = 1
    items["minecraft:stone_bricks"] = 1
    getItems(items)
    navigate(basespots_queue)
    turn(directions.NORTH)
    selectItem("minecraft:stone_bricks")
    move_forward()
    move_up()
    turtle.place()
    move_back()
    selectItem("minecraft:lever")
    turtle.place()
    move_down()


    navigate(basespots_spawn)
    turn(directions.NORTH)
    move_back()
    selectItem("computercraft:disk_drive")
    turtle.place()
    selectItem("computercraft:disk")
    turtle.drop()
    sleep(1)
    copyProgramsToDisk()

    move_back()
    selectItem("computercraft:turtle_normal")
    turtle.place()
    selectItem("minecraft:diamond_pickaxe")
    turtle.drop()
    os.sleep(0.1)
    local boss = peripheral.wrap("front")
    log("Could connect to boss:")
    log(boss ~= nil)
    boss.turnOn()
    navigateCoordinates(25, houseGroundLevel, 5)
    navigateCoordinates(basespots_chestBase.x, houseGroundLevel, z)
    navigate(basespots_chestBase)
    turn(directions.NORTH)    
end

function switchToBossMode()
    fs.delete("startup")
    --fs.copy("computerstartup", "startup")
    os.setComputerLabel("Boss")
    require("communication")
    require("init")
    require("logger")
    require("generalHelpingFunctions")
    log("Getting start state")
    initComputerFile()
    local h = fs.open("BOSS", "w")
    h.write("I AM THE BOSS")
    log("Writer is nil: ")
    log(h == nil)
    h.close()
    log("Bossfiles written.")
    write_pos()
end

function setTestTarget()
    local h = fs.open("bossState.michi", "r")
    local state = textutils.unserialize(h.readAll())
    h.close()
    local startPlan = getTestStep(1)
    addItemsToPlanAndCalculateAvailableSteps(startPlan, state.resources)
    state.currentPlan = startPlan
    local h = fs.open("bossState.michi", "w")
    h.write(textutils.serialize(state))
    h.close()
end

--init_turtle({16,66,10,directions["NORTH"]})
init_turtle({ 11, 64, 11, directions["NORTH"] })
--inventur()
inventur()
--initiateAndFlatten()


--increaseChestCountTo(20)


--makeSugarCaneFarm()
addFarm("minecraft:sugar_cane")


collectResourcesForBase()
craftBaseStuff()
--addBrickRoadToQueue()

buildBase()
switchToBossMode()
setTestTarget()
os.reboot()
