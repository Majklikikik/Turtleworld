function singleTurtleFindWater()
    local waterBucketCount = 0
    local i1 = 2
    while true do
        log("Looking for Water in Chunk "..i1)
        goFromHouseLeavingPointToChunk(i1)
        turn(directions["NORTH"])
        if singleTurtleCheckWater() >= 2 then return end
        for i2=1,8 do
            for _=1,15 do
                moveOverGround()
                if singleTurtleCheckWater() >= 2 then return end
            end
            turn_right()
            moveOverGround()
            if singleTurtleCheckWater() >= 2 then return end
            turn_right()
            for _=1,15 do
                moveOverGround()
                if singleTurtleCheckWater() >= 2 then return end
            end
            if i2~=8 then
                turn_left()
                moveOverGround()
                if singleTurtleCheckWater() >= 2 then return end
                turn_left()
            end
        end
        i1 = i1 + 1
    end
end

function  singleTurtleCheckWater()
    while current_pos.y < 63 do move_up() end
    if current_pos.y>63 then return 0 end
    selectItem("minecraft:bucket")
    turtle.placeDown()
    sleep(1)
    countInventory()
    if inventory_inv["minecraft:bucket"] ~= nil then
        selectItem("minecraft:bucket")
        turtle.placeDown()
    end

    countInventory()
    if inventory_inv["minecraft:water_bucket"]==nil then return 0 end
    return inventory_inv["minecraft:water_bucket"]
end

function singleTurtleMineResources(toMine, maxTunnel)
    if isEmpty(toMine) then return end
    local i = 1
    local miningResult = nil
    while miningResult== nil or miningResult == false do
        log("Mining the following items in Chunk #"..i..":")
        log(toMine)
        miningResult = mineAndReturnToHouse(i, 1, maxTunnel, toMine)
        if miningResult == nil then
            saveMiningProgress(i, -1)
        elseif miningResult == false then
            saveMiningProgress(i, maxTunnel)
            log("Dug all Tunnels")
        else
            saveMiningProgress(i, miningResult)
        end
        goFromOutsideToChestPoint()
        dropAbundantItems()
        countInventory()
        toMine = subtractValuesPositive(toMine, inventory_inv)
        dropInventory()
        log(os.clock())
        i = i+1
    end
end

function singleTurtleFarmWood(woodCount)
    if woodCount == nil or woodCount == 0  then return end
    log("Farming "..woodCount.." wood!")
    local i = 4
    local farmingResult = false
    while farmingResult == false do
        log("Searching trees, now in Chunk #"..i)
        farmingResult = lookInChunkForWood(i,nil,true)
        if farmingResult == false then
            saveFarmingProgress(i, false)
        end
        goFromOutsideToChestPoint()
        dropAbundantItems()
        woodCount = woodCount - countTotalWood()
        dropInventory()
        log(os.clock())
        i = i+1
        if woodCount < 1 then farmingResult = true end
    end
end

function singleTurtleGatherResource(resourceList, collectAllList)
    resourceList[woodsName] = nil
    if isEmpty(resourceList)  then return end
    resourceList = copyTable(resourceList)
    log("Gathering: ")
    log(resourceList)
    local i = 2
    local gatheredAll = false
    while gatheredAll == false do
        log("Gathering in Chunk "..i)
        log(resourceList)
        gatherBlocksFromSurfaceInChunk(i,resourceList, nil,  collectAllList)
        for k,l in pairs(resourceList) do
            saveGatheringProgress(i, k, false)
        end
        countInventory()
        resourceList = subtractValuesPositive(resourceList, inventory_inv)
        goFromOutsideToChestPoint()
        dropAbundantItems()
        dropInventory()
        log(os.clock())
        i = i+1
        if isEmpty(resourceList) then gatheredAll = true end
    end
end

function placeRemainingSugarcane(keepCount)
    if keepCount == nil then keepCount = 0 end
    if getTotalItemCounts()["minecraft:sugar_cane"] == nil then return end
    turtle.select(1)
    local sugCount = getTotalItemCounts()["minecraft:sugar_cane"] - keepCount
    if sugCount == nil or sugCount <= 0 then return end
    log("Placing the remaining "..sugCount.." sugar cane")
    getItemsOneType("minecraft:sugar_cane",sugCount)
    singleTurtleFarmSugarcane(-1, true)
end

function singleTurtleFarmSugarcane(count, fillUp)
    if count == 0 or count == nil then return end
    navigateCoordinates(18, houseGroundLevel, 11)
    move_up()
    countInventory()
    turtle.select(1)
    turn(directions.EAST)
    repeat
        move_up()
        for i=1,10 do
            move_forward()
        end
        move_forward()
        turn_left()
        move_forward()
        move_forward()
        turn_left()
        for i=1,10 do
            move_forward()
        end
        move_forward()
        turn_left()
        move_forward()
        move_forward()
        turn_left()
        move_down()

        for i=1,10 do
            move_forward()
            if fillUp then turtle.placeDown() end
        end
        move_forward()
        turn_left()
        move_forward()
        if fillUp then turtle.placeDown() end
        move_forward()
        turn_left()
        for i=1,10 do
            move_forward()
            if fillUp then turtle.placeDown() end
        end
        move_forward()
        turn_left()
        move_forward()
        if fillUp then turtle.placeDown() end
        move_forward()
        turn_left()
        sleep(10)
        countInventory()
    until inventory_inv["minecraft:sugar_cane"]~= nil and inventory_inv["minecraft:sugar_cane"] >= count
    navigate(basespots_chestBase)
    turn(directions.NORTH)
    dropInventory()
end


function initiateChests()
    --Collect 6 times Wood, should be of the same Type
    local chunkNum=1
    while not lookInChunkForWood(chunkNum,6,false,true) do
        chunkNum=chunkNum + 1
    end
    countInventory()
    local chestCount
    local toKeep = {}
    if inventory_inv["minecraft:birch_log"]~=nil and inventory_inv["minecraft:birch_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:birch_log"]/2))
        toKeep["minecraft:birch_log"]=chestCount*2
    elseif inventory_inv["minecraft:spruce_log"]~=nil and inventory_inv["minecraft:spruce_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:spruce_log"]/2))
        toKeep["minecraft:spruce_log"]=chestCount*2
    elseif inventory_inv["minecraft:oak_log"]~=nil and inventory_inv["minecraft:oak_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:oak_log"]/2))
        toKeep["minecraft:oak_log"]=chestCount*2
    elseif inventory_inv["minecraft:jungle_log"]~=nil and inventory_inv["minecraft:jungle_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:jungle_log"]/2))
        toKeep["minecraft:jungle_log"]=chestCount*2
    elseif inventory_inv["minecraft:acacia_log"]~=nil and inventory_inv["minecraft:acacia_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:acacia_log"]/2))
        toKeep["minecraft:acacia_log"]=chestCount*2
    elseif inventory_inv["minecraft:dark_oak_log"]~=nil and inventory_inv["minecraft:dark_oak_log"]>=6 then
        chestCount=math.min(8,math.floor(inventory_inv["minecraft:dark_oak_log"]/2))
        toKeep["minecraft:dark_oak_log"]=chestCount*2
    else
        log("Error, somehow didn't get 6 of the same wood type")
        error("Woods wrong")
    end

    log("Going to Chestbase: "..basespots_chestBase.x..":"..basespots_chestBase.y..":"..basespots_chestBase.z)
    logPos()
    navigate(basespots_chestBase)
    turn(directions["NORTH"])
    dropEverythinExcept(toKeep)
    log("Crafting "..chestCount.." chests!")
    craft("minecraft:startPlanks", 8*chestCount) -- Fails if more than 6 logs are in inventory
    craft("minecraft:startChest", chestCount)
    turn(directions["NORTH"])
    for _ = 1, chestCount do
        placeChest()
    end

end